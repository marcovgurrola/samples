var selIndex = 0;
var listLength = 0;
var player;

/*************************Media Methods*************************/
function channelChanged()
{
	this.blur();
	obtainFeed(document.getElementById("channels").selectedIndex);
}

function getChannelUrl(chann)
{
	if(chann==0) { return "http://rss.cnn.com/services/podcasting/ac360/rss.xml"; }
	if(chann==1) { return "http://rss.cnn.com/services/podcasting/studentnews/rss.xml"; }
	if(chann==2) { return "http://itunes.apple.com/us/tv-season/fareed-zakaria-gps/id484251557"; }
	if(chann==3) { return "http://rss.cnn.com/services/podcasting/ac360audio/rss"; }
	if(chann==4) { return "http://rss.cnn.com/services/podcasting/eboutfront/rss"; }
	if(chann==5) { return "http://rss.cnn.com/services/podcasting/piersmorganaudio/rss"; }
	if(chann==6) { return "http://rss.cnn.com/services/podcasting/fareedzakaria_audio/rss.xml"; }
	if(chann==7) { return "http://rss.cnn.com/services/podcasting/cnnopinion/rss"; }
	if(chann==8) { return "http://rss.cnn.com/services/podcasting/reliablesourcesaudio/rss"; }
}

function setPlayer(index, up)
{
	var list = document.getElementById("chan_items");
	player = document.getElementById("player");
	list.selectedIndex = index;
	selIndex = index;
	listLength = list.childNodes.length;
	
	if(up === undefined) { }
	else
	{
		// scroll
		var selected = list.childNodes[index];
		var selectedHeight = selected.offsetHeight;
		var top = list.scrollTop;
    	var listHeight = list.scrollHeight;
    
        //All except top item goes up
        if(up)
        { if(top != 0) list.scrollTop = top - selectedHeight; }    
        else //Down
        {
            var nextHeight = top + selectedHeight;
            var maxHeight = listHeight - selectedHeight;

			//All except bottom item goes down
            if(nextHeight <= maxHeight) list.scrollTop = top + selectedHeight;
        }
    }
	
	player.src = rssFeed.items[index].link;
	var nextTagIndex = rssFeed.items[index].description.indexOf("<");
	if(nextTagIndex > 0)
	{ 
		document.getElementById("playerDesc").innerHTML =
		 	rssFeed.items[index].description.substring(0, nextTagIndex); }
	else
	{ 
		document.getElementById("playerDesc").innerHTML =
			rssFeed.items[index].description;
	}
	
	toggleItemsClass(list);
}

function toggleItemsClass(list)
{
	for (var i = 0; i < list.childElementCount; i++)
	{
		if(i == list.selectedIndex)
			list.childNodes[i].childNodes[0].classList.add('selectedItem');
		else
			list.childNodes[i].childNodes[0].classList.remove('selectedItem');
	}
}

function playPause()
{
	if(player.paused) player.play();
	else player.pause();
}

function changeVolume(delta)
{
	var vol = player.volume + delta;
	if(vol >= 0 && vol <= 1) player.volume = vol;
}

//Forwards or rewinds the video track
function seek(delta)
{
	var seekableTime = player.currentTime + delta;
    if(seekableTime >= 0 && seekableTime <= player.duration ) 
		player.currentTime = seekableTime;
}

function hideShowControls() {
  if (player.hasAttribute("controls"))
  	player.removeAttribute("controls");
  else
  	player.setAttribute("controls", "controls");
}

function executeCommand(code)
{
	player.focus();
	
	//1-9 channel selection
	if(code >= 49 && code <= 57)
	{ 
		var channel = code - 49;
		document.getElementById("channels").selectedIndex = channel;
		obtainFeed(channel);
	}
	else
	{
	
		// - from normal or numpad
		if(code == 109) code = 189;
	
		// + from normal or numpad
		if(code == 107) code = 187;
	
   		switch(code) {
			case 13: // Enter
				playPause();
        		break;
			case 37: // left
				seek(-2);
      		  	break;
      		case 39: // right
				seek(2);
        		break;
			case 32: // Space Bar
				hideShowControls();
        		break;
        	case 189: // -
				changeVolume(-0.1);
        		break;
       		case 187: // +
				changeVolume(0.1);
        		break;
        	case 38: // up
				if(selIndex - 1 > -1)
					setPlayer(selIndex - 1, true);
        		break;
        		case 40: // down
					if(selIndex + 1 < listLength)
						setPlayer(selIndex + 1, false);	
        		break;
        		default: 
           			player.blur();
        			return false; // other keys
    	}
    }
    
    player.blur();
	return true;
}