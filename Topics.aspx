 <%@ Page Language="C#" AutoEventWireup="true"%>

<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data" %>

<%@ Register src="ctrl/headerCtrl.ascx" tagname="headerCtrl" tagprefix="uc1" %>
<%@ Register src="ctrl/pubCtrl.ascx" tagname="pubCtrl" tagprefix="uc2" %>
<%@ Register src="ctrl/footerCtrl.ascx" tagname="footerCtrl" tagprefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    string strConnection = ConfigurationManager.AppSettings["ConnectionString"];
    
    string s_id   = null;
    string s_name = null;
    string s_description = null;
    string s_keywords = null;
    
    string t_id        = null;
    string t_name      = null;
    string t_date_release = null;
    string t_length    = null;
    string t_nb_views  = null;
    string t_nb_videos = null;
    
    HtmlHead head = null;
    HtmlMeta meta = null;
    
    MySqlConnection dbConnection = null;
    MySqlCommand slctCmd1 = null;
    MySqlCommand slctCmd2 = null;

    MySqlDataReader dataReader1 = null;
    MySqlDataReader dataReader2 = null;

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["sid"] == null) Response.Redirect("Default.aspx");
            else s_id = Request.QueryString["sid"];

            dbConnection = new MySqlConnection(strConnection);
            dbConnection.Open();

            slctCmd1 = new MySqlCommand("SELECT s_name, s_description, s_keywords FROM subjects WHERE s_id=" + s_id, dbConnection);
            dataReader1 = slctCmd1.ExecuteReader();
            while (dataReader1.Read())
            {
                s_name = dataReader1[0].ToString();
                s_description = dataReader1[1].ToString();
                s_keywords = dataReader1[2].ToString();
            }
            dataReader1.Close();
            slctCmd1.Dispose();

            int i = s_description.Length;

            if (i < 160)
            {
                while (i != 160)
                {
                    s_description += " ";
                    i++;
                }
            }

            head = this.Page.Header;

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "KEYWORDS");
            meta.Attributes.Add("content", s_keywords);
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "DESCRIPTION");
            meta.Attributes.Add("content", s_description.Substring(0, 160));
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "AUTHOR");
            meta.Attributes.Add("content", "getiteasy.net");
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "LANGUAGE");
            meta.Attributes.Add("content", "FR");
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "REVISIT-AFTER");
            meta.Attributes.Add("content", "2 DAYS");
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "COPYRIGHT");
            meta.Attributes.Add("content", "getiteasy.net");
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "ROBOTS");
            meta.Attributes.Add("content", "INDEX, FOLLOW");
            head.Controls.Add(meta);
        }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
</script>


<html>
<head runat="server">
    <title>Cours disponibles en <%=s_name%> | getiteasy.net | cours, formations et tutoriaux en arabe gratuitement et en darija</title>
    <link href="style.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" />
</head>
<body>
    <form id="form1" runat="server">
    <uc1:headerCtrl ID="headerCtrl" runat="server" />
    <div id="core_02">
        <uc2:pubCtrl ID="pubCtrl" runat="server" />
        <div id="content">
            <div id="path">
                <a href="http://www.getiteasy.net/ma">getiteasy.net</a>&nbsp;»&nbsp;<a href="" style="text-decoration: none"><%=s_name.ToUpper()%></a>
            </div>
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
            <div id="subject_title">
                COURS EN <%=s_name.ToUpper()%>
            </div>
            
            <div id="topics_list">
                <table id="table_01">
                    <tr id="table_01_line_01">
                        <td></td>
                        <th>DUREE [HH:MM]</th>
                        <th>DATE DE SORTIE</th>
                        <th>VUE</th>
                        <th>LESSONS</th>
                    </tr>
                <%
                    try {
                        slctCmd2 = new MySqlCommand("SELECT t_id, t_name, DATE_FORMAT(t_date_release, '%d-%m-%Y'), TIME_FORMAT(t_length, '%H:%i'), t_nb_views, t_nb_videos, t_keywords FROM topics WHERE s_id=" + s_id, dbConnection);

                        dataReader2 = slctCmd2.ExecuteReader();

                        while (dataReader2.Read())
                        {
                            t_id   = dataReader2[0].ToString();
                            t_name = dataReader2[1].ToString();
                            t_date_release = dataReader2[2].ToString();
                            t_length    = dataReader2[3].ToString();
                            t_nb_views  = dataReader2[4].ToString();
                            t_nb_videos = dataReader2[5].ToString();

                            hyperLink.Text = t_name;
                            hyperLink.NavigateUrl = "Course.aspx?tid=" + t_id;
                        
                    %>    
                            <tr id="table_01_line_02">
                                <td><asp:HyperLink ID="hyperLink" runat="server" CssClass="topics_links"></asp:HyperLink></td>
                                <th><%=t_length%></th>
                                <th><%=t_date_release%></th>
                                <th><%=t_nb_views%></th>
                                <th><%=t_nb_videos%></th>
                            </tr>
                    <%
                        }

                        dataReader2.Close();
                        slctCmd2.Dispose();
                    } catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
                %>
                </table>
            </div>

            <div id="description"><%=s_description%></div>
        </div>
    </div>    
    <uc3:footerCtrl ID="footerCtrl" runat="server" />
    </form>
</body>
</html>
