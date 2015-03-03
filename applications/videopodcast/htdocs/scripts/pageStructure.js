var RSSUrl
var rssFeed;

/*************************HTML structure Methods*************************/
//parsed RSS 2.0 channel
function ChannelRSS2(tags, rssType)
{
	try
	{
	
		this.title;
		this.description;
		this.link;

		//array of ItemRSS2 objects
		this.items = new Array();
	
		var chanElement;
		var chanTitle;
		var chanLink;
		var chanDescription;
		var itemElements;

		if(rssType)
		{
			chanElement = tags.getElementsByTagName("channel")[0];
			itemElements = tags.getElementsByTagName("item");
		}
		else
			itemElements = tags.getElementsByClassName("tv-episode tv video");

		for (var i=0; i < itemElements.length; i++)
		{
			Item = new ItemRSS2(itemElements[i], rssType);
			this.items.push(Item);
		}
	
		if(rssType)
		{
			var props	= new Array("title", "link", "description");
			for (var i = 0; i < props.length; i++)
			{
				tmpElement = chanElement.getElementsByTagName(props[i])[0];
				if (tmpElement!= null)
					eval("this." + props[i] + "=tmpElement.childNodes[0].nodeValue");
			}
		}
		else
		{
			this.title = tags.getElementById("title").childNodes[1].childNodes[0].data;
			this.description = tags.getElementsByClassName('product-review')[0].
				childNodes[3].innerHTML;
			this.link = "test";
		}
	}
	catch(err) { showMessage('Error while trying to get external info: ' + err.message); }
}

//RSS 2.0 item
function ItemRSS2(itemXml, rssType)
{
	this.title;
	this.link;
	this.description;
	this.pubDate;

	if(rssType)
	{
		var props = new Array("title", "link", "description", "pubDate"); 
		for (var i=0; i < props.length; i++)
		{
			element = itemXml.getElementsByTagName(props[i])[0];
			if (element != null)
			{
				if(element.childNodes[0] == undefined)
					eval("this." + props[i] + " = 'NA'");
				else
					eval("this." + props[i] + " = element.childNodes[0].nodeValue");
			}
			else
				eval("this." + props[i] + " = 'NA'");
		}
	}
	else
	{
		this.title = itemXml.attributes['preview-album'].value;
		this.link = itemXml.attributes['video-preview-url'].value;
		this.description = itemXml.cells[2].innerText.trim();
		this.pubDate = itemXml.attributes['preview-title'].value;
	}
	
	if(this.pubDate != null && this.pubDate != "NA")
	{
		var dt = new Date(this.pubDate);
		this.pubDate = dt.toDateString();
	}
}

//uses xmlhttpreq to get the raw rss xml
function obtainFeed(channel)
{
	try
	{
		// gets the RSS url to process it through the php proxy
		RSSUrl = getChannelUrl(channel);
		var jsonStr = "/json";
		var xmlStr = ".xml";
		var request;
		var rssType;
	
		if(RSSUrl.indexOf("rss") > -1)
		{ 
			rssType = true;
			if(RSSUrl.indexOf(xmlStr) < 0) RSSUrl += xmlStr;
		}
		else rssType = false;
	
		if(rssType)
		{
			var requestData = { name: "got", id: 123, key: "Wg6Yu8s" };
			request = $.ajax({
				url: "proxy.php",
				data: { crossurl: RSSUrl + jsonStr + $.param(requestData) },			
				dataType: 'json'
			});
		}
		else
		{
			request = $.ajax({
				url: "proxy.php",
				data: { crossurl: RSSUrl },			
				dataType: 'html',
			});
		}
	
		request.complete(function()
		{
			if (request.readyState == 4)
			{
				if (request.status != 200)
					throw "Error " + request.status + ": " + request.statusText;
				else
				{
					if (request.responseText != null)
					{
						// Chrome and Firefox support
						if (window.XMLHttpRequest)
						{
							parser = new DOMParser();
							if(rssType)
								xmlDoc = parser.parseFromString(request.responseText,"text/xml");
							else
								xmlDoc = parser.parseFromString(request.responseText, "text/html");
						}
						else throw "Browser not supported";
					
						convert2HTML(xmlDoc, rssType);
					}
					else throw "empty RSS response";
				}
			}
			else throw "Request state: " + request.readyState;
		});
		
		request.error(function()
		{
			if (request.status != 200)
				showMessage("Error " + request.status + ": " + request.statusText);
		});
	}
	catch(err) { showMessage(err.message); }
}

//parses and displays the RSS Feed Data
function convert2HTML(tags, rssType)
{
	rssFeed = new ChannelRSS2(tags, rssType);
	
	//defaults for html tags
	var itemStartTag = "<li id='item";
	var itemEndTag = "</li>";

	//populate channel data
	var props = new Array("title", "description");
	for (var i = 0; i < props.length; i++)
	{
		eval("document.getElementById('chan_" + props[i] + "').innerHTML = ''");
		prop = eval("rssFeed." + props[i]);
		if (prop != null)
			eval("document.getElementById('chan_" + props[i] + "').innerHTML = prop");
	}

	//populating items
	document.getElementById("chan_items").innerHTML = "";
	for (var i = 0; i < rssFeed.items.length; i++)
	{
		item_html = itemStartTag + i + "' onclick = 'setPlayer(" + i + ")'>";
		item_html += "<a href='#'>";
		
		if(rssFeed.items[i].title == null) rssFeed.items[i].title = "NA.";
		if(rssFeed.items[i].pubDate == null) rssFeed.items[i].pubDate = "NA.";
		
		var strFullTitle = rssFeed.items[i].title + " " + rssFeed.items[i].pubDate;
		if(strFullTitle.length > 40) strFullTitle = strFullTitle.substring(0, 40);
		
		item_html += strFullTitle;
		item_html += "</a>";
		item_html += itemEndTag;

		document.getElementById("chan_items").innerHTML += item_html;
	}

	//Default channel and podcast selection
	setPlayer(0);
}

function showMessage(msg)
{
	alert(msg);
}