#include maps\mp\_utility;
#include common_scripts\utility;

#define mr getdvar("map_rotation")
#define map getdvar("mapname")

init()
{
    if(mr != "0")
        level thread handleMapRotation();
}

handleMapRotation() 
{
    level waittill("final_killcam_done");
    if(mr == "1")
    {
        if(map == "mp_carrier")
            cmdexec("map mp_studio");
        else if(map == "mp_studio")
            cmdexec("map mp_bridge");
        else if(map == "mp_bridge")
            cmdexec("map mp_vertigo");
        else if(map == "mp_vertigo")
            cmdexec("map mp_hydro");
        else if(map == "mp_hydro")
            cmdexec("map mp_carrier"); //rotation restarts.
        else
            return;
    }
    else if(mr == "2")
    {
        if(map == "mp_carrier")
            cmdexec("map mp_studio");
        else if(map == "mp_studio")
            cmdexec("map mp_bridge");
        else if(map == "mp_bridge")
            cmdexec("map mp_vertigo");
        else if(map == "mp_vertigo")
            cmdexec("map mp_turbine");
        else if(map == "mp_turbine")
            cmdexec("map mp_socotra");
        else if(map == "mp_socotra")
            cmdexec("map mp_nuketown_2020");
        else if(map == "mp_nuketown_2020")
            cmdexec("map mp_raid");
        else if(map == "mp_raid")
            cmdexec("map mp_village");
        else if(map == "mp_village")
            cmdexec("map mp_downhill");
        else if(map == "mp_downhill")
            cmdexec("map mp_express"); //rotation restarts.
        else
            return;
    }
    else if(mr == "3")
    {
        if(map == "mp_drone")
            cmdexec("map mp_slums");
        else if(map == "mp_slums")
            cmdexec("map mp_mirage");
        else if(map == "mp_mirage")
            cmdexec("map mp_concert");
        else if(map == "mp_concert")
            cmdexec("map mp_uplink");
        else if(map == "mp_uplink")
            cmdexec("map mp_dig");
        else if(map == "mp_dig")
            cmdexec("map mp_pod");
        else if(map == "mp_pod")
            cmdexec("map mp_drone"); //rotation restarts.
        else
            return;
    }
}

//spawn printline
maprotate()
{
    if(mr == "1")
        self iprintln("Map Rotation: CSDVH");
    else if(mr == "2")
        self iprintln("Map Rotation: Best Maps");
    else if(mr == "3")
        self iprintln("Map Rotation: Variety Maps");
    else if(mr == "0")
        self iprintln("Map Rotation: ^1Not Set");
}