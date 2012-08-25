<%@ Control Language="C#" ClassName="headerCtrl"%>

<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>

<link href="../style.css" rel="stylesheet" type="text/css" />

<script runat="server">
    
    string u_id = null;
    string u_login = null;
    string u_passwd = null;
    string u_fullname = null;
    int u_newMessages;
    
    MySqlConnection dbConnection = new MySqlConnection(ConfigurationManager.AppSettings["ConnectionString"]);
    MySqlCommand slctCmd = null;
    MySqlDataReader dataReader = null;
    
    

    protected void selectionChanged(object sender, EventArgs e)
    {
        Response.Redirect("Topics.aspx?sid=" + ddl_subjects.SelectedValue);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try {

        if (Session["IS_USER_LOGGED"] == null) Session["IS_USER_LOGGED"] = "false";
        if (!Page.IsPostBack)
        {
            dbConnection.Open();

            slctCmd = new MySqlCommand("SELECT s_id, s_name FROM subjects", dbConnection);
            dataReader = slctCmd.ExecuteReader();

            ListItem item = new ListItem();

            int zero   = 0;
            item.Value = zero.ToString();
            item.Text  = "selectionnez...";

            ddl_subjects.Items.Add(item);
            
            ListItem listItem = null;
            
            while (dataReader.Read())
            {

                listItem = new ListItem();
                
                listItem.Value = dataReader[0].ToString();
                listItem.Text  = dataReader[1].ToString().ToUpper();
                
                ddl_subjects.Items.Add(listItem);
            }
            dataReader.Close();
            slctCmd.Dispose();                
        }
        }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }               
    }

    public string md5(string sPassword)
    {
        MD5CryptoServiceProvider x = new MD5CryptoServiceProvider();
        byte[] bs = System.Text.Encoding.UTF8.GetBytes(sPassword);
        bs = x.ComputeHash(bs);

        StringBuilder s = new StringBuilder();

        foreach (byte b in bs)
        {
            s.Append(b.ToString("x2").ToLower());
        }

        return s.ToString();
    }
    
    protected void  logging(object sender, EventArgs e)
    {
        string _u_login = txtLogin.Text;
        string _u_passwd = txtPasswd.Text;

        MySqlConnection dbConnection_02 = new MySqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
        MySqlCommand slctUserCmd = new MySqlCommand("SELECT u_id, u_login, u_passwd, u_full_name, u_newMessages FROM users WHERE u_login='" + _u_login + "'", dbConnection_02);

        dbConnection_02.Open();
        MySqlDataReader userDataReader = slctUserCmd.ExecuteReader();

        userDataReader.Read();

        if (userDataReader.HasRows)
        {
            if (userDataReader[2].ToString() == md5(_u_passwd))
            {
                u_id     = userDataReader[0].ToString();
                u_login  = userDataReader[1].ToString();
                u_passwd = userDataReader[2].ToString();
                u_fullname = userDataReader[3].ToString();
                u_newMessages = Int32.Parse(userDataReader[4].ToString());

                userDataReader.Close();
                slctUserCmd.Dispose();

                Session["fullname"] = u_fullname;
                Session["IS_USER_LOGGED"] = "true";
            } else {
                errorMsg.Text = "Mot de passe incorrect";
            }
        } else {
            errorMsg.Text = "Nom d'utilisateur incorrect";
        }
    }

    protected void logout(object sender, EventArgs e)
    {
        Session["IS_USER_LOGGED"] = "false";
    }

    public void setUserLoggedIn(string _fullname)
    {
        Session["fullname"] = _fullname;
        u_newMessages = 0;
        Session["IS_USER_LOGGED"] = "true";
    }

    public int isUserLogged()
    {
        if (Session["IS_USER_LOGGED"] == "true") return Int32.Parse(u_id);
        else return -1;
    }

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
</script>

<div id="header_01" align="left">
    <div id="getiteasy_logo"></div>
    <div id="logging">
        <% if (Session["IS_USER_LOGGED"] == "false")
           { %>
        <table>
            <tr>
                <td colspan="2" style="height: 17px;text-align: center;"><asp:Label id="errorMsg" runat="server" CssClass="errorMsg"></asp:Label></td>
            </tr>
            <tr>
                <td>Nom d'utilisateur</td>
                <td>
                    <asp:TextBox runat="server" ID="txtLogin" CssClass="logging_textbox"></asp:TextBox>
                </td>
            </tr>
            
            <tr>
                <td>Mot de passe</td>
                <td>
                    <asp:TextBox runat="server" ID="txtPasswd" CssClass="logging_textbox" 
                        TextMode="Password" Font-Names="Calibri" Font-Size="12px"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td style="text-align: right;" colspan="2">
                    <asp:Button runat="server" id="logging_button" Text="LOGIN" BackColor="White" 
                        BorderStyle="Solid" ForeColor="Black" Height="18px" BorderColor="Black" 
                        BorderWidth="1px" Font-Size="10px" OnClick="logging"/>
                </td>
            </tr>
        </table>
        <% } else { %>
        <div id="logged_in">
            Bienvenu <strong><%=Session["fullname"].ToString()%></strong><br />
            <% if (u_newMessages == 0)
               { %> Vous n'avez aucun nouveau message <% }
               else
               { %> Vous avez <strong><%=u_newMessages%></strong> nouveaux messages <% } %>
               <br />
               <br />
               <asp:Button runat="server" id="logout_button" Text="DECONNEXION" BackColor="White" 
                        BorderStyle="Solid" ForeColor="Black" Height="18px" BorderColor="Black" 
                        BorderWidth="1px" Font-Size="10px" OnClick="logout"/>
        </div>
        <% } %>
    </div>
</div>

<div id="header_02" align="center">
    <center>
    <big style="font-family: Calibri, Arial, Serif; font-size: 16px; color: #424040">Je suis interess&eacute; par : </big>
        <asp:DropDownList ID="ddl_subjects" runat="server" AutoPostBack="true" onSelectedIndexChanged="selectionChanged">
        </asp:DropDownList>
    </center>
</div>
