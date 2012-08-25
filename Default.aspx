<%@ Page Language="C#" AutoEventWireup="true"%>

<%@ Register src="ctrl/headerCtrl.ascx" tagname="headerCtrl" tagprefix="uc1" %>
<%@ Register src="ctrl/footerCtrl.ascx" tagname="footerCtrl" tagprefix="uc2" %>
<%@ Register src="ctrl/coreCtrl.ascx" tagname="coreCtrl" tagprefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">
    HtmlHead head = null;
    HtmlMeta meta = null;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string description = "Formation en Java, HTML, CSS, PHP, C/C++ et encore d'autres langages de programmation en darija et gratuitement sur getiteasy.net, devenez un professionnel de programmation";
            head = this.Page.Header;

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "KEYWORDS");
            meta.Attributes.Add("content", "formation, gratuite, java, arabe, facile, java, html, c++, c, php, css, tutoriel, darija, programmation, programmer, poo, orientée, objet");
            head.Controls.Add(meta);

            meta = new HtmlMeta();
            meta.Attributes.Add("name", "DESCRIPTION");
            meta.Attributes.Add("content", description.Substring(0, 160));
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
    <title>getiteasy.net | cours, formations et tutoriaux en arabe gratuitement et en darija</title>
    <meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)" />
    <link rel="Stylesheet" href="style.css" type="text/css" />
</head>

<body>
    <form id="form1" runat="server">
    <uc1:headerCtrl ID="headerCtrl" runat="server" />
    <uc3:coreCtrl ID="coreCtrl" runat="server" />
    <uc2:footerCtrl ID="footerCtrl" runat="server" />
    
    </form>
</body>
</html>
