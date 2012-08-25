<%@ Control Language="C#" ClassName="coreCtrl" %>

<link href="../style.css" rel="stylesheet" type="text/css" />

<script runat="server">

</script>

<div id="core_01">
    <div style="width: 270px; float: left; height: auto; margin-top: 30px;">
    <center>
        <p style="text-align: left; font-size: 16px; font-family: Calibri, Arial, Serif; color: #424040; width: 270px;">
            <big style="font-size: 14px;">
                Vous êtes passionné(e) de l'informatique ? <br />
                et vous voulez apprendre à programmer, <br />
                en C/C++ en Java ou encore en .NET ? <br />
                vous en avez marre de chercher
                des tutoriaux par-ci et par-là. Nous avons la solution
            </big>
            <br />
            <br />
            <big>getiteasy.net, un site nouveau vous appelle</big>
            offrant <i>gratuité</i> et <i>simplicité</i>.
            <br /><br />
            Des formations en HTML, CSS, JAVA, PHOTOSHOP, C/C++, .NET et d'autres,
            exclusivement en <strong>DARIJA</strong> sur <br /><br />
            <big style="color: #48577D; font-family: Calibri, Arial; font-size: 50px;" >getiteasy</big><big style="color: #808080; font-family: Calibri, Arial; font-size: 40px;">.NET</big>
        </p>
    </center>
    </div>

    <div class="default_page_videos" style="height: 410px; background-color: rgba(255, 0, 0, 0);" >
        <div class="default_page_videos">
            <div style="height: 110px; width: 160px; margin-right: 10px; float: left;">
<!--                <asp:Image Height="110" ImageUrl="../img/video_04_html.png" runat="server" />-->
                <asp:HyperLink id="HL1" runat="server" ImageUrl="../img/video_04_html.png" NavigateUrl="/ma/Player.aspx?tid=1&vid=4"></asp:HyperLink>
            </div>
            <div style="float: right; width: 390px; height: 110px;">
                <a href="/ma/Player.aspx?tid=1&vid=4" style="font-family: Arial, Serif; font-size: 12px; font-weight: bold; color: #258AC0; text-decoration: underline;">Balises à traiter des textes</a><br />
                <big style="font-family: Arial, Serif; font-size: 13px; color: #000">Un navigateur web lit un document HTML de haut en bas, de gauche à droite. Chaque fois que le navigateur trouve une balise, il est affiché en conséquence. Les balise se dévisé en 3 partie balise douverture <>, le nom de la balise, el la balise de fermeture</big>
            </div>
        </div>

        <div class="default_page_videos" style="margin-top: 40px; vertical-align: middle;">
            <div style="height: 110px; width: 160px; margin-right: 10px; float: left;">
                <!--<asp:Image ID="Image2" Height="110" ImageUrl="../img/video_office.png" runat="server"/>-->
                <asp:HyperLink id="HL2" runat="server" ImageUrl="../img/video_office.png" NavigateUrl="/ma/Player.aspx?tid=4&vid=115"></asp:HyperLink>
            </div>
            <div style="float: right; width: 390px; height: 110px;">
                <script type="text/javascript"><!--
                    google_ad_client = "pub-4898226191720814";
                    /* 234x60, date de création 16/02/11 */
                    google_ad_slot = "1296817725";
                    google_ad_width = 234;
                    google_ad_height = 60;
                    
                </script>
                <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
            </div>                           
        </div>

        <div class="default_page_videos" style="margin-top: 40px">
            <div style="height: 110px; width: 160px; margin-right: 10px; float: left;">
                <!--<asp:Image ID="Image1" Height="110" ImageUrl="../img/video_01_poo.png" runat="server"/>-->
                <asp:HyperLink id="HL3" runat="server" ImageUrl="../img/video_01_poo.png" NavigateUrl="/ma/Player.aspx?tid=3&vid=37"></asp:HyperLink>
            </div>
            <div style="float: right; width: 390px; height: 110px;">
                <a href="/ma/Player.aspx?tid=3&vid=37" style="font-family: Arial, Serif; font-size: 12px; font-weight: bold; color: #258AC0; text-decoration: underline;">Introduction à la POO</a><br />
                <big style="font-family: Arial, Serif; font-size: 13px; color: #000">Un navigateur web lit un document HTML de haut en bas, de gauche à droite. Chaque fois que le navigateur trouve une balise, il est affiché en conséquence. Les balise se dévisé en 3 partie balise douverture <>, le nom de la balise, el la balise de fermeture</big>
                
            </div>
        </div>

    </div>
</div>