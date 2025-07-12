#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\utils;
#include scripts\mp\menu;
#include scripts\mp\structure;

fixOverFlow()
{
	fix = level createServerFontString("default", 1);
	fix.alpha = 0;
	fix setText("OVERFLOWFIX");
	
	if(level.script == "sd")
		A = 45; //A = 220;
	else 				  
		A = 45; //A = 230; 55
	
	while(true)
	{
		level waittill("CHECK_OVERFLOW");
		if(level.strings.size >= A)
		{
			fix ClearAllTextAfterHudElem();
			level.strings = [];
			level notify("FIX_OVERFLOW");
			foreach(player in level.players)
			{
				//player iprintln("^6OVERFLOW");
				if(player InMenu())
				{
					player thread setmenutext();
					player thread setmenutitle(self gettitle());
				}
			}
		}
	}
}
