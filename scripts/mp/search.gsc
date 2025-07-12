#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

//snd stuff
monitorbomb()
{
    level endon("game_ended");
    for(;;)
    {
        time = gettimeremaining();
        if(time < 1)
        {
            thread defusebomb();
            plantbomb();
        }
        wait 1;
    }
}

gettimeremaining()
{
    return floor((level.timelimit * 60 * 1000 - maps\mp\gametypes\_globallogic_utils::gettimepassed()) / 1000);
}

plantbomb()
{
    if(!level.bombplanted)
    {
        level thread maps\mp\gametypes\sd::bombplanted(level.bombzones[0], undefined);
        level.bombzones[0] maps\mp\gametypes\_gameobjects::disableobject();
    }
    return;
}

defusebomb()
{
    level endon("game_ended");
    wait level.bombtimer - 1;
    if(game["roundswon"]["attackers"] == 3 && game["roundswon"]["defenders"] < 3)
    {
        level thread maps\mp\gametypes\sd::bombdefused();
        level notify("defused");
    }
    return;
}

ondeadevent(team)
{
    if(level.bombexploded || level.bombdefused)
        return;
    
    if(team == "all")
    {
        if(level.bombplanted)
            sd_endgamewithkillcam(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
        else
            sd_endgamewithkillcam(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
    }
    else if(team == game["attackers"])
        sd_endgamewithkillcam(game["defenders"], game["strings"][game["attackers"] + "_eliminated"]);
    else if(team == game["defenders"])
        sd_endgamewithkillcam(game["attackers"], game["strings"][game["defenders"] + "_eliminated"]);
}   
 