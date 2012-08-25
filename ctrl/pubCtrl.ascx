<%@ Control Language="C#" ClassName="pubCtrl"%>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Collections" %>

<link href="../style.css" rel="stylesheet" type="text/css" />

<script runat="server">
    
    string strConnection = ConfigurationManager.AppSettings["ConnectionString"].ToString();
    
    MySqlConnection dbConnection = null;
    
    MySqlCommand slttopTopics = null;
    MySqlDataReader dataread1 = null;

    MySqlCommand slctNews = null;
    MySqlDataReader dReaderNews = null;

    string t_id = null;
    string t_name = null;

    int counter_01 = 0;
    int counter_02 = 0;

    ArrayList topics_ids = null;
    ArrayList topics_names = null;

    ArrayList ids_01 = null;
    ArrayList names_01 = null;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        try {
        dbConnection = new MySqlConnection(strConnection);
        dbConnection.Open();

        topics_ids = new ArrayList();
        topics_names = new ArrayList();

        ids_01 = new ArrayList();
        names_01 = new ArrayList();
        
        slttopTopics = new MySqlCommand("SELECT t_name, t_id FROM topics ORDER BY t_nb_views DESC LIMIT 8", dbConnection);
        dataread1 = slttopTopics.ExecuteReader();
        while (dataread1.Read())
        {
            topics_names.Add(dataread1[0].ToString());
            topics_ids.Add(dataread1[1].ToString());
            counter_01++;
        }
        dataread1.Close();
        slttopTopics.Dispose();

        slctNews = new MySqlCommand("SELECT t_id, t_name FROM topics ORDER BY t_id DESC LIMIT 8", dbConnection);
        dReaderNews = slctNews.ExecuteReader();
        while (dReaderNews.Read())
        {
            ids_01.Add(dReaderNews[0].ToString());
            names_01.Add(dReaderNews[1].ToString());
            counter_02++;
        }
        }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }

    protected void Page_Unload(object sender, EventArgs e)
    {
        try { dbConnection.Close(); }
        catch (Exception ex) { Session["error"] = ex.Message; Response.Redirect("ErrorPage.aspx"); }
    }
    
</script>

<div id="pub_banner">
    <br />
    <div class="pub_flyer_01">
    <div class="flyers_titles">TOP 8</div>
        <% int i = 0;

           while (i < counter_01)
           {

               hyperLink_topics.Text = topics_names[i].ToString();
               hyperLink_topics.NavigateUrl = "../Course.aspx?tid=" + topics_ids[i].ToString();
               i++;
        %>
                <asp:HyperLink ID="hyperLink_topics" runat="server" CssClass="flyers_links"></asp:HyperLink>
                <br />
        <%
           }
        %>
    </div>
    <br />
    <div class="pub_flyer_01" style="height: 245px; padding-left: 40px; padding-right: 40px; width: 120px; padding-top: 5px;">
        <script type="text/javascript"><!--
            google_ad_client = "pub-4898226191720814";
            /* 120x240, date de création 24/02/11 */
            google_ad_slot = "9456884992";
            google_ad_width = 120;
            google_ad_height = 240;
        </script>
        <script type="text/javascript"
        src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
        </script>
    </div>
    <br />
    <div class="pub_flyer_01">
        <div class="flyers_titles">NOUVEAUTES</div>
        <% int j = 0;

           while (j < counter_02)
           {
               hyperLink.Text = names_01[j].ToString();
               hyperLink.NavigateUrl = "../Course.aspx?tid=" + ids_01[j].ToString();
               j++;
        %>
               <asp:HyperLink ID="hyperLink" runat="server" CssClass="flyers_links"></asp:HyperLink>
               <br />
        <%
           }
        %>
    </div>
    <br />
    <div class="pub_flyer_01" style="width: 180; height: 180px; padding: 0px;">
        <center><a href="../ma/SignUp.aspx" style="text-decoration: none;"><asp:Image ImageUrl="../img/subscribe.gif" runat="server"/></a></center>
    </div>
</div>


