function flashObject(url, id, width, height, version, bg, flashvars, params, att)
{
	var pr = '';
	var attpr = '';
	var fv = '';
	var nofv = 0;
	for(i in params)
	{
		pr += '<param name="'+i+'" value="'+params[i]+'" />';
		attpr += i+'="'+params[i]+'" ';
		if(i.match(/flashvars/ig))
		{
			nofv = 1;
		}
	}
	if(nofv==0)
	{
		fv = '<param name="flashvars" value="';
		for(i in flashvars)
		{
			fv += i+'='+escape(flashvars[i])+'&';
		}
		fv += '" />';
	}
	htmlcode = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="'+width+'" height="'+height+'">'
+'	<param name="movie" value="'+url+'" />'+pr+fv/*
+'	<!--[if !IE]> <-->'
+'		<object data="'+url+'" width="'+width+'" height="'+height+'" type="application/x-shockwave-flash">'+pr+fv
+'			<a href="http://www.macromedia.com/go/getflashplayer">Vous devez installer le Plugin FlashPlayer</a> - <a href="http://www.getiteasy.net/">Getiteasy.net</a>'
+'		</object>'
+'	<!--> <![endif]-->'*/
+'	<embed src="'+url+'" width="'+width+'" height="'+height+'" '+attpr+'type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer"></embed>'
+'</object>';
	document.getElementById(id).innerHTML=htmlcode;
}