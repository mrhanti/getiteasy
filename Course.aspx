<%@ Page Language="C#"%>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Collections" %>

<%@ Register src="ctrl/headerCtrl.ascx" tagname="headerCtrl" tagprefix="uc1" %>
<%@ Register src="ctrl/pubCtrl.ascx" tagname="pubCtrl" tagprefix="uc2" %>
<%@ Register src="ctrl/footerCtrl.ascx" tagname="footerCtrl" tagprefix="uc3" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    string strConnection = ConfigurationManager.AppSettings["ConnectionString"];
    
    MySqlConnection dbConnection = null;
    
    MySqlCommand slctTitlesCmd   = null;
    MySqlCommand slctVideosCmd   = null;
    MySqlCommand slctTopicName   = null;
    MySqlCommand slctSubjectName = null;
    MySqlCommand updtNbViews = null;

    MySqlDataReader dataReader1 = null;
    MySqlDataReader dataReader2 = null;
    MySqlDataReader dataReader3 = null;
    MySqlDataReader dataReader4 = null;

    HtmlHead head = null;
    HtmlMeta meta = null;

    string s_id   = null;
    string s_name = null;
    
    string v_id     = null;
    string v_name   = null;
    string v_length = null;

    string t_id   = null;
    string t_name = null;
    string t_keywords = null;
    string t_description = null;
    
    ArrayList titles_names = null;
    ArrayList titles_ids   = null;

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try {
        if (Request.QueryString["tid"] == null) Response.Redirect("Default.aspx");
        else t_id = Request.QueryString["tid"];

        dbConnection = new MySqlConnection(strConnection);
        dbConnection.Open();

        updtNbViews = new MySqlCommand("UPDATE topics SET t_nb_views = t_nb_views + 1 WHERE t_id=" + t_id, dbConnection);
        updtNbViews.ExecuteNonQuery();
        
        slctSubjectName = new MySqlCommand("SELECT s_id, s_name FROM subjects WHERE s_id=(SELECT s_id FROM topics WHERE t_id=" + t_id + ")", dbConnection);
        dataReader4 = slctSubjectName.ExecuteReader();
        dataReader4.Read();
        
        if (dataReader4.HasRows)
        {
            s_id = dataReader4[0].ToString();
            s_name = dataReader4[1].ToString();
        }

        s_name_hyper_link.Text = s_name.ToUpper();
        s_name_hyper_link.NavigateUrl = "Topics.aspx?sid=" + s_id;
                    
        dataReader4.Close();
        slctSubjectName.Dispose();
        
        slctTopicName = new MySqlCommand("SELECT t_name, t_keywords, t_description FROM topics WHERE t_id=" + t_id, dbConnection);
        dataReader3 = slctTopicName.ExecuteReader();

        dataReader3.Read();
        if (dataReader3.HasRows)
        {
            t_name = dataReader3[0].ToString();
            t_keywords = dataReader3[1].ToString();
            t_description = dataReader3[2].ToString();
        }

        dataReader3.Close();
        slctTopicName.Dispose();
        
        titles_ids   = new ArrayList();
        titles_names = new ArrayList();
        
        slctTitlesCmd = new MySqlCommand("SELECT title_id, title_name FROM titles WHERE t_id=" + t_id + " ORDER BY title_rank", dbConnection);

        dataReader1 = slctTitlesCmd.ExecuteReader();

        while (dataReader1.Read())
        {
            titles_ids.Add(dataReader1[0].ToString());
            titles_names.Add(dataReader1[1].ToString());
        }

        dataReader1.Close();
        slctTitlesCmd.Dispose();

        int i = t_description.Length;
        
        if (i < 160)
        {
            while (i != 160)
            {
                t_description += " ";
                i++;
            }
        }
        
        head = this.Page.Header;

        meta = new HtmlMeta();
        meta.Attributes.Add("name", "KEYWORDS");
        meta.Attributes.Add("content", t_keywords);
        head.Controls.Add(meta);

        meta = new HtmlMeta();
        meta.Attributes.Add("name", "DESCRIPTION");
        meta.Attributes.Add("content", t_description.Substring(0, 160));
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
    <title><%=t_name%> | getiteasy.net | cours, formations et tutoriaux en arabe gratuitement et en darija</title>
    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" /> 
    <link rel="Stylesheet" href="style.css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:headerCtrl ID="headerCtrl" runat="server" />
        <div id="core_02">
            <uc2:pubCtrl ID="pubCtrl" runat="server" />
            <div id="content">
                <div id="path" style="margin-bottom: 40px;"">
                    <a href="http://www.getiteasy.net/ma">getiteasy.net</a>&nbsp;»&nbsp;<asp:HyperLink ID="s_name_hyper_link" runat="server"></asp:HyperLink>&nbsp;»&nbsp;<a href="" style="text-decoration: none;"><%=t_name%></a>
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
                    <%  try
                        {
                            int i = 0;
                            while (i < titles_ids.Count)
                            {
                    %>
                            
                                <div id="title_name">
                                    <%=titles_names[i].ToString().ToUpper()%>
                                    <div id="separator" style="padding-left: 30px; width: 500px"></div>
                                </div>
                    <%      
                                slctVideosCmd = new MySqlCommand("SELECT v_id, v_name, DATE_FORMAT(v_length, '%i:%S') FROM videos WHERE title_id=" + titles_ids[i].ToString() + " AND t_id=" + t_id + " ORDER BY v_rank", dbConnection);
                                dataReader2 = slctVideosCmd.ExecuteReader();
                    %>
                                <div id="videos_informations">
                    <%                            
                                while (dataReader2.Read())
                                {
                                    v_id = dataReader2[0].ToString();
                                    v_name = dataReader2[1].ToString();
                                    v_length = dataReader2[2].ToString();

                                    hyperLink.Text = v_name;
                                    hyperLink.NavigateUrl = "Player.aspx?tid=" + t_id + "&vid=" + v_id;
                                    video_length.Text = v_length;
                    %>
                                
                                    <div id="video_title">
                                        <asp:HyperLink ID="hyperLink" runat="server"></asp:HyperLink>
                                    </div>
                                    
                                    <div id="video_length_id">
                                        <asp:Label ID="video_length" runat="server"></asp:Label>
                                    </div>
                    <%
                                }
                        %>
                                </div>
                        <%
                                dataReader2.Close();
                                slctVideosCmd.Dispose();
                                i++;
                            }
                        } catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
                    %>
            </div>
        </div>
    </div>
    <uc3:footerCtrl ID="footerCtrl" runat="server" />
    </form>
</body>
</html>
