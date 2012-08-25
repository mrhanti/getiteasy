<%@ Page Language="C#" %>

<%@ Register src="ctrl/headerCtrl.ascx" tagname="headerCtrl" tagprefix="uc1" %>

<%@ Register src="ctrl/pubCtrl.ascx" tagname="pubCtrl" tagprefix="uc2" %>

<%@ Register src="ctrl/footerCtrl.ascx" tagname="footerCtrl" tagprefix="uc3" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Collections" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    MySqlConnection dbConnection = new MySqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
    MySqlCommand slctUsernames = null;
    MySqlDataReader dReaderUsernames = null;

    MySqlCommand isrtUser = null;

    ArrayList usernames = null;

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        dbConnection.Open();
        
        for (int i = 1 ; i <= 31 ; i++)
        {
            ddl_days.Items.Add(i.ToString());            
        }

        ddl_months.Items.Add("Janvier");
        ddl_months.Items.Add("Février");
        ddl_months.Items.Add("Mars");
        ddl_months.Items.Add("Avril");
        ddl_months.Items.Add("Mai");
        ddl_months.Items.Add("Juin");
        ddl_months.Items.Add("Juillet");
        ddl_months.Items.Add("Aout");
        ddl_months.Items.Add("Septembre");
        ddl_months.Items.Add("Octobre");
        ddl_months.Items.Add("Novembre");
        ddl_months.Items.Add("Décembre");

        for (int i = 1970; i < 2002; i++)
        {
            ddl_year.Items.Add(i.ToString());
        }
    }

    protected void SignUpUser(object sender, EventArgs e)
    {
        string fullname = txtFullName.Text;
        string username = txtUsername.Text;
        string passwd = txtPasswd.Text;
        string confirm_passwd = txtConfirmPasswd.Text;
        string email = txtEmail.Text;
        string birthday = ddl_year.SelectedItem.ToString() + "-" + (ddl_months.SelectedIndex + 1) + "-" + ddl_days.SelectedItem.ToString();
        string first_letter = username.Substring(0, 1);
        
        if (fullname == "" || username == "" || passwd == "" || confirm_passwd == "" || email == "") signup_msg.Text = "Vérifiez que vous avez remplis tous les champs du formulaire";
        else {
            string reply = null;

            if ((reply = isAllValid(passwd, confirm_passwd, email, username)) == "YES")
            {
                isrtUser = new MySqlCommand("INSERT INTO users(u_login, u_passwd, u_full_name, u_mail, u_birthday) VALUES ('" + username + "', md5('" + passwd + "'), '" + fullname.ToUpper() + "', '" + email + "', '" + birthday + "')", dbConnection);
                isrtUser.ExecuteNonQuery();
                isrtUser.Dispose();

                headerCtrl.setUserLoggedIn(fullname);
                Response.Redirect("Default.aspx");
            }
                
            else signup_msg.Text = reply;
       }         
    }

    protected string isAllValid(string _pw, string _cpw, string _e, string _username)
    {
        string _msg = null;
        string first_letter = _username.Substring(0, 1);
        
        usernames = new ArrayList();
        
        slctUsernames = new MySqlCommand("SELECT u_login FROM users WHERE u_login like '" + first_letter + "%'", dbConnection);
        dReaderUsernames = slctUsernames.ExecuteReader();

        while (dReaderUsernames.Read()) usernames.Add(dReaderUsernames[0].ToString());

        dReaderUsernames.Close();
        slctUsernames.Dispose();

        bool found = false;

        foreach (string s in usernames)
        {
            if (_username == s) found = true;
        }
        
        if (found) _msg = "Le nom d'utilisateur que vous avez choisi est déjà utilisé<br>";
        if (_pw != _cpw) _msg += "Votre mot de passe et votre confirmation de mot de passe ne son pas les mêmes<br>";
        if (!_e.Contains("@")) _msg += "Votre adresse électronique est invalide<br>";
        
        if (_msg == null) _msg = "YES";
        
        return _msg;
    }   
</script>

<html>
<head runat="server">
    <title>Inscription sur getiteasy.net | cours, formations et tutoriaux en arabe gratuitement et en darija</title>
    <link rel="Stylesheet" href="style.css" />
    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        
        <uc1:headerCtrl ID="headerCtrl" runat="server" />
        <div id="core_02">
            <uc2:pubCtrl ID="pubCtrl" runat="server" />
            <div id="content">
                <div id="subject_title">INSCRIPTION</div>
                
                <div id="google_banner_02">
                    <script type="text/javascript"><!--
                        google_ad_client = "pub-4898226191720814";
                        /* 468x60, date de création 24/02/11 */
                        google_ad_slot = "4090680238";
                        google_ad_width = 468;
                        google_ad_height = 60;
                    </script>
                    <script type="text/javascript"
                    src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
                    </script>
                </div>

                <center>
                <div id="signup">
                    <asp:Label ID="signup_msg" runat="server" ForeColor="Black" Font-Names="Calibri" Font-Size="10px"></asp:Label>
                    <br />
                    <br />
                    <table>
                        <tr>
                            <th>Nom Complet</th>
                            <td><asp:TextBox ID="txtFullName" runat="server" CssClass="signup_texbox"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>Nom d'utilisateur</th>
                            <td><asp:TextBox ID="txtUsername" runat="server" CssClass="signup_texbox"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>Mot de passe</th>
                            <td><asp:TextBox ID="txtPasswd" runat="server" CssClass="signup_texbox" TextMode="Password"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>Confirmer votre mot de passe</th>
                            <td><asp:TextBox ID="txtConfirmPasswd" runat="server" CssClass="signup_texbox" TextMode="Password"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>Adresse &eacute;lectronique</th>
                            <td><asp:TextBox ID="txtEmail" runat="server" CssClass="signup_texbox"></asp:TextBox></td>
                        </tr>
                        
                        <tr>    
                            <th>Date de Naissance</th>
                            <td>
                                <asp:DropDownList ID="ddl_days" runat="server" 
                                    Font-Names="Calibri, Arial, Serif" Font-Size="14px" ForeColor="#424040"></asp:DropDownList>
                                <asp:DropDownList ID="ddl_months" runat="server" 
                                    Font-Names="calibri, arial, serif" Font-Size="14px" ForeColor="#424040"></asp:DropDownList>
                                <asp:DropDownList ID="ddl_year" runat="server" 
                                    Font-Names="calibri, arial, serif" Font-Size="14px" ForeColor="#424040"></asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="2" style="text-align: right; height: 40px; vertical-align: bottom;">
                                <asp:Button runat="server" id="signupBtn" Text="Valider" BackColor="White" 
                                    BorderStyle="Solid" ForeColor="#424040" Height="22px" Width="80px" BorderColor="#424040" 
                                    BorderWidth="1px" Font-Size="13px" onclick="SignUpUser"/>
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>
                </center>
            </div>
        </div>
        
    </div>
    <uc3:footerCtrl ID="footerCtrl" runat="server" />
    </form>
</body>
</html>
