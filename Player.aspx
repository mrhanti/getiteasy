<%@ Page Language="C#"%>

<%@ Register src="ctrl/headerCtrl.ascx" tagname="headerCtrl" tagprefix="uc1" %>
<%@ Register src="ctrl/pubCtrl.ascx" tagname="pubCtrl" tagprefix="uc2" %>
<%@ Register src="ctrl/footerCtrl.ascx" tagname="footerCtrl" tagprefix="uc3" %>

<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    
    string strConnection = ConfigurationManager.AppSettings["ConnectionString"];
    
    MySqlConnection dbConnection = null;

    MySqlCommand slctSubject = null;
    MySqlCommand slctTopic   = null;
    MySqlCommand slctTitle   = null;
    MySqlCommand slctVideo   = null;
    MySqlCommand slctComment = null;
    MySqlCommand isrtComment = null;

    MySqlDataReader dReaderSubject = null;
    MySqlDataReader dReaderTopic   = null;
    MySqlDataReader dReaderTitle   = null;
    MySqlDataReader dReaderVideo   = null;
    MySqlDataReader dReaderComments = null;

    MySqlCommand slctNextVideo = null;
    MySqlDataReader dReaderNextVideo = null;
    MySqlCommand slctPreviousVideo = null;
    MySqlDataReader dReaderPreviousVideo = null;
    
    HtmlHead head = null;
    HtmlMeta meta = null;

    string next_video_id = null;
    string previous_video_id = null;

    string t_id = null;
    string v_id = null;

    string s_id = null;
    string s_name = null;
    
    string t_name = null;
    int t_nb_videos;

    string title_name = null;

    string v_name        = null;
    string v_description = null;
    string v_link = null;
    string v_length      = null;
    string v_keywords = null;
    int v_rank;

    int next_video_rank;
    int previous_video_rank;

    string full_link = null;

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try {
            t_id = Request.QueryString["tid"];
            v_id = Request.QueryString["vid"];

            if (t_id == null || v_id == null) Response.Redirect("Default.aspx");

            dbConnection = new MySqlConnection(strConnection);
            dbConnection.Open();

            slctSubject = new MySqlCommand("SELECT s_id, s_name FROM subjects WHERE s_id=(SELECT s_id FROM topics WHERE t_id=" + t_id + ")", dbConnection);
            dReaderSubject = slctSubject.ExecuteReader();
            dReaderSubject.Read();
            s_id = dReaderSubject[0].ToString();
            s_name = dReaderSubject[1].ToString();
            dReaderSubject.Close();
            slctSubject.Dispose();
            s_name_hyper_link.NavigateUrl = "Topics.aspx?sid=" + s_id;

            slctTopic = new MySqlCommand("SELECT t_name, t_nb_videos FROM topics WHERE t_id=" + t_id, dbConnection);
            dReaderTopic = slctTopic.ExecuteReader();
            dReaderTopic.Read();
            t_name = dReaderTopic[0].ToString();
            t_nb_videos = Int32.Parse(dReaderTopic[1].ToString());
            dReaderTopic.Close();
            slctTopic.Dispose();
            t_name_hyper_link.NavigateUrl = "Course.aspx?tid=" + t_id;

            slctTitle = new MySqlCommand("SELECT title_name FROM titles WHERE title_id=(SELECT title_id FROM videos WHERE v_id=" + v_id + ")", dbConnection);
            dReaderTitle = slctTitle.ExecuteReader();
            dReaderTitle.Read();
            title_name = dReaderTitle[0].ToString();
            dReaderTitle.Close();
            slctTitle.Dispose();

            slctVideo = new MySqlCommand("SELECT v_name, v_description, v_link, v_length, v_rank, v_keywords FROM videos WHERE v_id=" + v_id, dbConnection);
            dReaderVideo = slctVideo.ExecuteReader();
            dReaderVideo.Read();
            v_name = dReaderVideo[0].ToString();
            v_description = dReaderVideo[1].ToString();
            v_link += dReaderVideo[2].ToString();
            v_length = dReaderVideo[3].ToString();
            v_rank = Int32.Parse(dReaderVideo[4].ToString());
            v_keywords = dReaderVideo[5].ToString();
            dReaderVideo.Close();
            slctVideo.Dispose();

            if (v_rank == 1)
            {
                if (t_nb_videos == 1 || t_nb_videos == 0)
                {
                    previous_hyper_link.Visible = false;
                    next_hyper_link.Visible = false;
                }
                else
                {
                    next_video_rank = (v_rank + 1);
                    slctNextVideo = new MySqlCommand("SELECT v_id FROM videos WHERE v_rank=" + next_video_rank + " AND t_id=" + t_id, dbConnection);
                    dReaderNextVideo = slctNextVideo.ExecuteReader();
                    dReaderNextVideo.Read();
                    next_video_id = dReaderNextVideo[0].ToString();
                    dReaderNextVideo.Close();
                    slctNextVideo.Dispose();

                    next_hyper_link.NavigateUrl = "Player.aspx?tid=" + t_id + "&vid=" + next_video_id;
                    previous_hyper_link.Visible = false;
                    next_hyper_link.Visible = true;
                }
            }
            else if ((v_rank > 1) && (v_rank < t_nb_videos))
            {

                next_video_rank = (v_rank + 1);
                previous_video_rank = (v_rank - 1);

                slctNextVideo = new MySqlCommand("SELECT v_id FROM videos WHERE v_rank=" + next_video_rank + " AND t_id=" + t_id, dbConnection);
                dReaderNextVideo = slctNextVideo.ExecuteReader();
                dReaderNextVideo.Read();
                next_video_id = dReaderNextVideo[0].ToString();
                dReaderNextVideo.Close();
                slctNextVideo.Dispose();

                slctPreviousVideo = new MySqlCommand("SELECT v_id FROM videos WHERE v_rank=" + previous_video_rank + " AND t_id=" + t_id, dbConnection);
                dReaderPreviousVideo = slctPreviousVideo.ExecuteReader();
                dReaderPreviousVideo.Read();
                previous_video_id = dReaderPreviousVideo[0].ToString();
                dReaderPreviousVideo.Close();
                slctPreviousVideo.Dispose();


                previous_hyper_link.NavigateUrl = "Player.aspx?tid=" + t_id + "&vid=" + previous_video_id;
                next_hyper_link.NavigateUrl = "Player.aspx?tid=" + t_id + "&vid=" + next_video_id;
                previous_hyper_link.Visible = true;
                next_hyper_link.Visible = true;
            }
            else
            {
                previous_video_rank = (v_rank - 1);

                slctPreviousVideo = new MySqlCommand("SELECT v_id FROM videos WHERE v_rank=" + previous_video_rank + " AND t_id=" + t_id, dbConnection);
                dReaderPreviousVideo = slctPreviousVideo.ExecuteReader();
                dReaderPreviousVideo.Read();
                previous_video_id = dReaderPreviousVideo[0].ToString();
                dReaderPreviousVideo.Close();
                slctPreviousVideo.Dispose();

                previous_hyper_link.NavigateUrl = "Player.aspx?tid=" + t_id + "&vid=" + previous_video_id;
                previous_hyper_link.Visible = true;
                next_hyper_link.Visible = false;
            }

            int i = v_description.Length;

            if (i < 160)
            {
                while (i != 160)
                {
                    v_description += " ";
                    i++;
                }
            }

            head = this.Page.Header;

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "KEYWORDS");
            meta.Attributes.Add("content", v_keywords);
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "DESCRIPTION");
            meta.Attributes.Add("content", v_description.Substring(0, 160));
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

    protected void validateComment(object sender, EventArgs e)
    {
        string poster = txtID.Text.Replace("'", "&apos;");
        string email = txtMail.Text.Replace("'", "&apos;");
        string comment = txtComment.Text.Replace("'", "&apos;");

        comment_msg.Text = "votre commentaire sera affiché après validation de l'administration du site";

        isrtComment = new MySqlCommand("INSERT INTO comments (c_poster_name, c_poster_mail, c_content, c_date_post, v_id) VALUES ('" + poster + "', '" + email + "', '" + comment + "', CURDATE(), " + v_id + ")", dbConnection);
        isrtComment.ExecuteNonQuery();
        isrtComment.Dispose();        
        
        clear();
    }

    protected void clear()
    {
        if (Page.IsPostBack)
        {
            txtID.Text = "";
            txtMail.Text = "";
            txtComment.Text = "";
        }
    }
</script>

<html>
<head runat="server">
    <title>Cours en <%=t_name %>, <%=v_name%> | getiteasy.net | cours, formations et tutoriaux en arabe gratuitement et en darija</title>
    <link rel="Stylesheet" href="style.css" />
    <script type="text/javascript" src="flashobject/flashobject.js"></script>
    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <uc1:headerCtrl ID="headerCtrl" runat="server" />
        <div id="core_02">
            <uc2:pubCtrl ID="pubCtrl" runat="server" />
            <div id="content">
                <div id="path">
                    <a href="Default.aspx">getiteasy.net</a>&nbsp;»&nbsp;<asp:HyperLink ID="s_name_hyper_link" runat="server"><%=s_name.ToUpper()%></asp:HyperLink>&nbsp;»&nbsp;<asp:HyperLink ID="t_name_hyper_link" runat="server"><%=t_name%></asp:HyperLink>&nbsp;»&nbsp;<a href="" style="text-decoration: none;"><%=title_name%></a>
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
                
                <div id="video_name">
                    <%=v_name%>
                </div>
                
                <% full_link = "fichier=" + v_link +"&apercu=img/capture.jpg"; %>

                <div id="video_player" align="center">
                    <script type="text/javascript">
                        var link;
                        link = '<%=full_link%>';
                        var flashvars = {};
                        var params = {
                            quality: "high",
                            allowScriptAccess: "always",
                            allowFullScreen: "true",
                            wmode: "transparent",
                            flashvars: link
                        };
                        var attributes = {};
                        flashObject("flashobject/player.swf", "video_player", "600", "300", "8", false, flashvars, params, attributes);
                    </script>
                </div>

                <div id="next_previous_links">
                    <div id="link_next"><asp:HyperLink ID="next_hyper_link" runat="server" 
                            ImageUrl="img/next.png"></asp:HyperLink></div>
                    <div id="link_previous"><asp:HyperLink ID="previous_hyper_link" runat="server" 
                            ImageUrl="img/previous.png"></asp:HyperLink></div>
                </div>

                <div id="description" style="margin-top: 30px;">
                    <%=v_description%>
                </div>
                
                <%
                    slctComment = new MySqlCommand("SELECT c_poster_name, c_content, DATE_FORMAT(c_date_post, '%d-%m-%Y') FROM comments WHERE v_id=" + v_id + " AND is_valid=1", dbConnection);
                    dReaderComments = slctComment.ExecuteReader();
                    
                    if (dReaderComments.HasRows)
                    {
                        string c_poster_name = null;
                        string c_content = null;
                        string c_date_post = null;
                %>
                        <div id="comments_02" style="">
                <%      
                        while (dReaderComments.Read())
                        {
                            c_poster_name = dReaderComments[0].ToString();
                            c_content = dReaderComments[1].ToString();
                            c_date_post = dReaderComments[2].ToString();
                %>                            
                            <strong><%=c_poster_name.ToString() %></strong>, post&eacute; le <%=c_date_post%>
                            <div style="height: 1px; width: 520px; background-color: #000;"></div>
                            <br />
                            <%=c_content%>
                            <br />
                            <br />
                            <br />
                <%      }
                %>  
                        </div>  
                <%
                    }    
                %>
                
                <div id="comments_01">
                    <table id="table_03">
                        <tr>
                            <th>identifiant</th>
                            <td><asp:TextBox ID="txtID" runat="server" CssClass="comments_textboxs"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>e-mail</th>
                            <td><asp:TextBox ID="txtMail" runat="server" CssClass="comments_textboxs"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th>commentaire</th>
                            <td><asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Height="140px" CssClass="comments_textboxs"
                                    EnableTheming="True"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="text-align: right" colspan="2">
                                <asp:Button runat="server" id="validate" Text="VALIDER" BackColor="White" 
                                    BorderStyle="Solid" ForeColor="#808080" Height="18px" BorderColor="#AAAAAA" 
                                    BorderWidth="1px" Font-Size="10px" onclick="validateComment"/>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Label ID="comment_msg" runat="server" ForeColor="Black" Font-Names="Calibri" Font-Size="10px"></asp:Label>
                </div>
            </div>
        </div>
    </div>
    <uc3:footerCtrl ID="footerCtrl" runat="server" />
    </form>
</body>
</html>
