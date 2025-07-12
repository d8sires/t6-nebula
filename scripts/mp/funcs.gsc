#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\utils;
#include scripts\mp\structure;
#include scripts\mp\flags;
#include scripts\mp\search;
#include scripts\mp\bot_warfare\bot_warfare;
#include scripts\mp\bot_warfare\bots_adapter_pt6;

#define ffa getdvar("g_gametype") == "dm"
#define snd getdvar("g_gametype") == "sd"
#define gg getdvar("g_gametype") == "gun"

#define mr getdvar("map_rotation")
#define map getdvar("mapname")

//game mode funcs
gamelogic()
{
    if(ffa)
    {
        precachemodel("t6_wpn_supply_drop_ally");
        precachemodel("collision_clip_64x64x10");
        precachemodel("mp_flag_allies_1");
        setDvar("perk_armorPiercing", 9999); 
        setDvar("perk_bulletPenetrationMultiplier", 30);
        setDvar("bullet_ricochetBaseChance", 0.95);
        setDvar("bullet_penetrationMinFxDist", 1024); 
        setDvar("bulletrange", 99999);
        setDvar("bg_ladder_yawcap", 0); 
        setDvar("bg_prone_yawcap", 360); 
        setDvar("penetrationCount", 1024);
        setDvar("jump_slowdownEnable", 0); 
        setDvar("sv_enableBounces", 1);
        setdvar("bots_manage_add", 17);
        level thread initflags();
        level thread maps\mp\gametypes\_rank::registerscoreinfo("assisted_suicide", 0);
        level.callbackplayerdamage_stub = level.callbackplayerdamage;
        level.callbackplayerdamage = ::gamedamage;
    }
    else if(gg)
    {
        precachemodel("t6_wpn_supply_drop_ally");
        precachemodel("collision_clip_64x64x10");
        precachemodel("mp_flag_allies_1");
        setDvar("perk_armorPiercing", 9999); 
        setDvar("perk_bulletPenetrationMultiplier", 30);
        setDvar("bullet_ricochetBaseChance", 0.95);
        setDvar("bullet_penetrationMinFxDist", 1024); 
        setDvar("bulletrange", 99999);
        setDvar("bg_ladder_yawcap", 360); 
        setDvar("bg_prone_yawcap", 360); 
        setDvar("penetrationCount", 1024);
        setDvar("jump_slowdownEnable", 0); 
        setDvar("sv_enableBounces", 1); 
        setdvar("bots_manage_add", 17);
        level thread initflags();
        level.callbackplayerdamage_stub = level.callbackplayerdamage;
        level.callbackplayerdamage = ::gamedamage;
    }
    else if(snd)
    {
        if(game["roundsplayed"] == 0)
        {
            setDvar("perk_armorPiercing", 9999); 
            setDvar("perk_bulletPenetrationMultiplier", 30);
            setDvar("bullet_ricochetBaseChance", 0.95);
            setDvar("bullet_penetrationMinFxDist", 1024); 
            setDvar("bulletrange", 99999);
            setDvar("bg_ladder_yawcap", 360); 
            setDvar("bg_prone_yawcap", 360); 
            setDvar("penetrationCount", 1024);
            setDvar("jump_slowdownEnable", 0); 
            setDvar("sv_enableBounces", 1); 
            setDvar("player_breath_gasp_lerp", 0);
            setdvar("grenadeFrictionLow", 1);
            setdvar("grenadeBumpMax", 1);
            setdvar("grenadeBumpFreq", 1);
            setdvar("grenadeRestThreshold", 1000);
            setdvar("grenadeWobbleFreq", 1);
            setdvar("grenadeRollingEnabled", 0);
            setdvar("grenadeCurveMax", 0);
            setdvar("player_throwbackOuterRadius", 2000);
            setdvar("player_throwbackInnerRadius", 1000);
            setdvar("bots_manage_add", 1);
        }
        level thread monitorbomb(); //auto plant & defuse
        level.ondeadevent = ::ondeadevent;
        level.callbackplayerdamage_stub = level.callbackplayerdamage;
        level.callbackplayerdamage = ::gamedamage;
    }
}

//bot stuff
botswontwin()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        if(self.pers["pointstowin"] >= level.scorelimit - 4)
        {
            maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 0);
            self.pointstowin = 0;
            self.pers["pointstowin"] = self.pointstowin;
            self.score = 0;
            self.pers["score"] = self.score;
            self.kills = 0;
            self.pers["kills"] = self.kills;
            self.deaths = 0;
            self.pers["deaths"] = self.deaths;
            self.headshots = 0;
            self.pers["headshots"] = self.headshots;
        }
        wait 1;
    }
}

ifriot()
{
    if(self hasweapon("riotshield_mp"))
        self takeweapon("riotshield_mp");
    else if(self hasweapon("alcatraz_shield_mp"))
        self takeweapon("alcatraz_shield_mp");
    else if(self hasweapon("tomb_shield_mp"))
        self takeweapon("tomb_shield_mp");
}

//menu funcs
fl()
{
    self setpers("insta_fast_last", self getpers("insta_fast_last", "false") == "true" ? "false" : "true");

    if(self getpers("insta_fast_last", "true") == "true")
        self thread fastlast();
}

fastlast()
{
    if(!self isonlast())
    {
        self.pers["pointstowin"] = (level.scorelimit - 1);
        self.pointstowin = (level.scorelimit - 1);
        self.pers["kills"] = (level.scorelimit - 1);
        self.kills = (level.scorelimit - 1);
    }
    else
        return self iprintlnbold("^1Error:^7 You're already at last.");
}

fastlast2piece()
{
    self.pers["pointstowin"] = (level.scorelimit - 2);
    self.pointstowin = (level.scorelimit - 2);
    self.pers["kills"] = (level.scorelimit - 2);
    self.kills = (level.scorelimit - 2);
}

resetlast()
{
    self.pers["pointstowin"] = 0;
    self.pointstowin = 0;
    self.pers["kills"] = 0;
    self.kills = 0;
}

unsetspawn()
{
    if(isdefined(self.o) && isdefined(self.a))
    {
        self.o = undefined;
        self.a = undefined;
        self iprintln("Spawn ^1Unset");
    }
    else
        return self iprintln("^1Error:^7 You must set a location to unsave it.");
}

givecarepack()
{
    self maps\mp\killstreaks\_killstreaks::givekillstreak("inventory_supply_drop_mp");
}

doRandomClass()
{
    self takeallweapons();
    self.Sniper = strTok("dragunov_mp,barretm82_mp,dsr50_mp+steadyaim+fmj,dsr50_mp+steadyaim+acog,dsr50_mp+steadyaim+ir,dsr50_mp+steadyaim+dualclip,ballista_mp+steadyaim+fmj,ballista_mp+steadyaim+acog,ballista_mp+steadyaim+ir,ballista_mp+steadyaim+dualclip,ballista_mp+steadyaim+is,as50_mp+steadyaim+fmj,as50_mp+steadyaim+acog,as50_mp+steadyaim+ir,as50_mp+steadyaim+dualclip,svu_mp+steadyaim+fmj,svu_mp+steadyaim+acog,svu_mp+steadyaim+ir,svu_mp+steadyaim+dualclip", ",");
    self.Weapon = strTok("rnma_mp,m1911_mp,makarov_mp,c96_mp,mp40_mp,uzi_mp,ak74u_mp,mp5k_mp,thompson_mp,galil_mp,m16_mp,fnfal_mp,ak47_mp,rpd_mp,m60_mp,mg08_mp,dragunov_mp,barretm82_mp,blundergat_mp,spas_mp,rottweil72_mp,rpg_player_mp,electrocuted_hands_mp,exptitus6_mp,hk416_mp+dualoptic,srm1216_mp,870mcs_mp,an94_mp+gl,as50_mp+fmj,ballista_mp+fmj+is,ballista_mp+fmj,beretta93r_mp,beretta93r_dw_mp,crossbow_mp,dsr50_mp+fmj,evoskorpion_mp+sf,fiveseven_mp,knife_ballistic_mp,ksg_mp+silencer,mp7_mp+sf,pdw57_mp+silencer,peacekeeper_mp+sf,riotshield_mp,sa58_mp+sf,sa58_mp+fmj+silencer,saritch_mp+sf,saritch_mp+fmj+silencer,scar_mp+gl,svu_mp+fmj+silencer,tar21_mp+dualclip,type95_mp+dualclip,vector_mp+sf,vector_mp+rf,usrpg_mp", ",");
    self.Tactical = strTok("concussion_grenade_mp,emp_grenade_mp,proximity_grenade_mp,flash_grenade_mp", ",");
    self.Frag = strTok("time_bomb_mp,satchel_charge_80s_mp,molotov_dpad_mp,beartrap_mp,satchel_charge_mp,bouncingbetty_mp,claymore_mp,sticky_grenade_mp,frag_grenade_mp,hatchet_mp", ",");
    self.randsniper = randomint(self.sniper.size);
    self.randweapon = randomint(self.weapon.size);
    self.randfrag = randomint(self.frag.size);
    self.randtact = randomint(self.tact.size);
    self.randomcamo = randomintrange(1, 45);
    self thread doLoadout(); 
}

doLoadout()
{
    self thread settheperks();
    self giveweapon(self.sniper[self.randsniper], 0, self.randomcamo);
    self giveweapon(self.weapon[self.randweapon], 0, self.randomcamo);
    self switchtoweapon(self.sniper[self.randsniper]);
    self giveweapon(self.frag[self.randfrag]);
    self giveweapon(self.frag[self.randfrag]);
    self giveweapon(self.tact[self.randtact]);
    self giveweapon(self.tact[self.randtact]);

    if(!self giveweapon(self.tact[self.randtact]))
        self giveweapon("proximity_grenade_mp");  
    
    if(!self giveweapon(self.frag[self.randfrag]))
        self giveweapon("sticky_grenade_mp");

    gn = randomintrange(0, 4); 
    if(gn == 2)
    {
        mw = strTok("one_inch_punch_mp,tazer_knuckles_mp,spork_zm_alcatraz,spoon_zm_alcatraz", ",");
        r_mw = mw[randomint(mw.size)];
        self giveweapon(r_mw, 0, 0);
        self thread whichmelee();
    }
    else
        self giveweapon("knife_mp", 0, 0);

    if(gg)
    {
        ks = strtok("inventory_supply_drop_mp,rcbomb_mp,killstreak_remote_turret_mp,missile_drone_mp,inventory_minigun_mp,radar_mp", ",");
        r_s = ks[randomint(ks.size)];
        self maps\mp\killstreaks\_killstreaks::givekillstreak(r_s);
    }
}

whichmelee()
{
    if(self hasweapon("one_inch_punch_mp"))
        self iprintln("You were given ^2One Inch Punch!^7 Press [{+melee}]!");
    else if(self hasweapon("tazer_knuckles_mp"))
        self iprintln("You were given ^2Galvaknuckles!^7 Press [{+melee}]!");
    else if(self hasweapon("spork_zm_alcatraz"))
        self iprintln("You were given ^2MOTD Spork!^7 Press [{+melee}]!");
    else if(self hasweapon("spoon_zm_alcatraz"))
        self iprintln("You were given ^2MOTD Spoon!^7 Press [{+melee}]!");
}

settheperks()
{
    self setperk("specialty_longersprint");
    self setperk("specialty_unlimitedsprint");
    self setperk("specialty_bulletpenetration");
    self setperk("specialty_bulletaccuracy");
    self setperk("specialty_armorpiercing");
    self setperk("specialty_fallheight");
    self setperk("specialty_fastequipmentuse");
    self setperk("specialty_fastladderclimb");
    self setperk("specialty_fastmantle");
    self setperk("specialty_fastmeleerecovery");
    self setperk("specialty_fasttoss");
    self setperk("specialty_fastweaponswitch");

    if(gg)
    {
        fh = randomintrange(0, 6); 
        if(fh == 3)
        {
            self unsetperk("specialty_fastequipmentuse");
            self unsetperk("specialty_fastmeleerecovery");
            self unsetperk("specialty_fasttoss");
            self unsetperk("specialty_fastweaponswitch");
        }
    }
}

doRandomClassToggle()
{
    if(!isdefined(self.randomclass))
    {
        self.randomclass = true;
        self thread doRandomClassOnSpawn();
    }
    else
    {
        self.randomclass = undefined;
        self notify("stop_randomclass");
    }
}

dorandomclassonspawn()
{
    level endon("game_ended");
    self endon("stop_randomclass");
    for(;;)
    {
        self waittill("spawned_player");
        self takeallweapons();
        self.Sniper = strTok("dragunov_mp,barretm82_mp,dsr50_mp+steadyaim+fmj,dsr50_mp+steadyaim+acog,dsr50_mp+steadyaim+ir,dsr50_mp+steadyaim+dualclip,ballista_mp+steadyaim+fmj,ballista_mp+steadyaim+acog,ballista_mp+steadyaim+ir,ballista_mp+steadyaim+dualclip,ballista_mp+steadyaim+is,as50_mp+steadyaim+fmj,as50_mp+steadyaim+acog,as50_mp+steadyaim+ir,as50_mp+steadyaim+dualclip,svu_mp+steadyaim+fmj,svu_mp+steadyaim+acog,svu_mp+steadyaim+ir,svu_mp+steadyaim+dualclip", ",");
        self.Weapon = strTok("rnma_mp,m1911_mp,makarov_mp,c96_mp,mp40_mp,uzi_mp,ak74u_mp,mp5k_mp,thompson_mp,galil_mp,m16_mp,fnfal_mp,ak47_mp,rpd_mp,m60_mp,mg08_mp,dragunov_mp,barretm82_mp,blundergat_mp,spas_mp,rottweil72_mp,rpg_player_mp,electrocuted_hands_mp,exptitus6_mp,hk416_mp+dualoptic,srm1216_mp,870mcs_mp,an94_mp+gl,as50_mp+fmj,ballista_mp+fmj+is,ballista_mp+fmj,beretta93r_mp,beretta93r_dw_mp,crossbow_mp,dsr50_mp+fmj,evoskorpion_mp+sf,fiveseven_mp,knife_ballistic_mp,ksg_mp+silencer,mp7_mp+sf,pdw57_mp+silencer,peacekeeper_mp+sf,riotshield_mp,sa58_mp+sf,sa58_mp+fmj+silencer,saritch_mp+sf,saritch_mp+fmj+silencer,scar_mp+gl,svu_mp+fmj+silencer,tar21_mp+dualclip,type95_mp+dualclip,vector_mp+sf,vector_mp+rf,usrpg_mp", ",");
        self.Tactical = strTok("concussion_grenade_mp,emp_grenade_mp,proximity_grenade_mp,flash_grenade_mp", ",");
        self.Frag = strTok("time_bomb_mp,satchel_charge_80s_mp,molotov_dpad_mp,beartrap_mp,satchel_charge_mp,bouncingbetty_mp,claymore_mp,sticky_grenade_mp,frag_grenade_mp,hatchet_mp", ",");
        self.randsniper = randomint(self.sniper.size);
        self.randweapon = randomint(self.weapon.size);
        self.randfrag = randomint(self.frag.size);
        self.randtact = randomint(self.tact.size);
        self.randomcamo = randomintrange(1, 45);
        self thread doLoadout(); 

        if(ffa)
            if(self.swrc)
                self thread streaks();

        self thread doLoadout();
    }
}

swrc()
{
    if(!isdefined(self.swrc))
        self.swrc = true;
    else
        self.swrc = undefined;
}

dropcanswap() 
{
    weapon = randomGun();
    self.randomcamo = randomintrange(1, 45);
    self giveweapon(weapon, 0, self.randomcamo);
    self dropitem(weapon);
}

randomGun() 
{
    self.gun = "";
    while(self.gun == "")
    {
        id = random(level.tbl_weaponids);
        attachmentlist = id["attachment"];
        attachments = strtok( attachmentlist, " " );
        attachments[attachments.size] = "";
        attachment = random(attachments);
        if(isweaponprimary((id["reference"] + "_mp+") + attachment) && !checkGun(id["reference"] + "_mp+" + attachment))
            self.gun = (id["reference"] + "_mp+") + attachment;
        wait 0.1;
        return self.gun;
    }
    wait 0.1;
}

checkGun(weap) 
{
    self.allweaps = [];
    self.allweaps = self getweaponslist();
    foreach(weapon in self.allweaps)
    {
        if(issubstr(weapon, weap))
            return true;
    }
    return false;
}

kys()
{
    self suicide();
}

autocanswap()
{
	if(!isdefined(self.acs))
	{
		self.acs = true;
		self iprintln("Auto Canswap: ^2On");
		self thread doAutoCanswap();
	}
	else
	{
		self.acs = undefined;
		self iprintln("Auto Canswap: ^1Off");
		self notify("stop_cswap");
	}
}

doAutoCanswap()
{
    level endon("game_ended");
	self endon("stop_cswap");
	for(;;)
	{
		self waittill("weapon_change", weapon);
		self seteverhadweaponall(0);
	}
}

streaks()
{
    maps\mp\gametypes\_globallogic_score::_setplayermomentum(self, 9999);
}

afterhit(weapon)
{
    if(!isdefined(self.afterhit))
    {
        self.afterhit = true;
        self iprintln("Afterhit: ^2"+weapon);
        self thread doafterhit(weapon);
    }
    else
    {
        self.afterhit = undefined;
        self iprintln("Afterhit: ^1Off");
        self notify("stop_afterhit");
    }
}

doafterhit(weapon)
{
    self endon("stop_afterhit");
    level waittill("game_ended");
    weap = self getcurrentweapon();
    self giveweapon(weapon);
    self takeweapon(weap);
    self switchtoweapon(weapon);
}

takeweap()
{
    self takeweapon(self getcurrentweapon());
}

dropweap()
{
    self dropitem(self getcurrentweapon());
}

controllerbinds()
{
    level endon("game_ended");
    for(;;)
    {
        if(ffa)
        {
            if(self getstance() == "crouch" && self actionslottwobuttonpressed())
            {
                self.a = self.angles;
                self.o = self.origin;
                self iprintln("Spawn ^2Set");
            }
            if(self getstance() == "crouch" && self actionslotonebuttonpressed())
            {
                if(isdefined(self.a) && isdefined(self.o))
                {
                    self setorigin(self.o);
                    self setplayerangles(self.a);
                }
            }
            if(self getstance() == "crouch" && self actionslotthreebuttonpressed())
            {
                self thread dropcanswap();
            }
            if(self getstance() == "prone" && self actionslotonebuttonpressed())
            {
                self thread streaks();
            }
        }
        else if(snd)
        {
            if(self getstance() == "crouch" && self actionslotthreebuttonpressed())
            {
                self thread dropcanswap();
            }
            if(self getstance() == "prone" && self actionslotonebuttonpressed())
            {
                self thread streaks();
            }
        }
        wait 0.01;
    }
}

manageBarriers() 
{
    currentMap = getDvar("mapname");
    switch (currentMap)
    {
        case "mp_bridge": 
            return moveTrigger(950);
        case "mp_hydro": 
            return moveTrigger(1000);
        case "mp_uplink": 
            return moveTrigger(300);
        case "mp_vertigo": 
            return moveTrigger(800);
        case "mp_socotra": 
            return moveTrigger(520);
        case "mp_raid": 
            return moveTrigger(125);
        case "mp_concert": 
            return moveTrigger(165);
        case "mp_skate":
            return moveTrigger(180);
        case "mp_nightclub":
            return moveTrigger(180);
        case "mp_mirage": 
            return moveTrigger(700);
        case "mp_dig": 
            return moveTrigger(400);

        default:
            return;
            
    }
}

moveTrigger( z ) 
{
    if ( !isDefined ( z ) || isDefined ( level.barriersDone ) )
        return;
    level.barriersDone = true;
    trigger = getEntArray( "trigger_hurt", "classname" );

    for( i = 0; i < trigger.size; i++ )
    {
        if( trigger[i].origin[2] < self.origin[2] )
            trigger[i].origin -= ( 0 , 0 , z );
    }
}

removeskybarrier()
{
    entarray = getentarray();
    index = 0;
    while(index < entarray.size)
    {
        if(entarray[index].origin[2] > 180 && issubstr(entarray[index].classname, "trigger_hurt"))
        {
            entarray[index].origin = (0, 0, 9999999);
        }
        index++;
    }
}

monitorClass() //this is a public function from the pluto forums
{
    level endon("game_ended");
    for(;;)
    {
        self waittill("changed_class");
        self maps\mp\gametypes\_class::giveloadout(self.team, self.class);
        self iPrintlnBold(""); 
        wait 0.05;
    }
}

shieldbounces() //this is a public function from the pluto forums
{
    level endon("game_ended");
    self thread doshieldbounce();
    self.bounces = false;
    self.spawned_shields = [];
    for(;;)
    {
        if(isdefined(self.riotshieldretrievetrigger) && isdefined(self.riotshieldentity) && !self.bounce)
        {
            bounce_location = spawn("script_model", self.origin + (0, 0, 20));
            bounce_location thread bounce_logic(280);
            self.spawned_shields[self.spawned_shields.size] = bounce_location;
            self.bounce = true;
            wait 0.02;
        }
        else
        {
            wait 0.02;
        }
        wait 0.05;
    }
}

doshieldbounce() //this is a public function from the pluto forums
{
    level endon("game_ended");
    for(;;)
    {
        self waittill("destroy_riotshield");
        array_delete(self.spawned_shields);
        self.bounce = false;
        wait 0.05;
    }
}

bounce_logic(zaxis) //this is a public function from the pluto forums
{
    while(isdefined(self))
    {
        foreach(player in level.players)
        {
            if(!player is_bot())
            {
                if(distance(self.origin, player.origin) < 50)
                {
                    player setvelocity(player getvelocity() + (0, 0, zaxis));
                }
            }
        }
        wait 0.15;
    }
}

monitorlast()
{
    level endon("game_ended");
    self endon("at_last");
    for(;;)
    {
        if(self isonlast())
        {
            themecc = color(themename(self.menu["color"][0]));
            self iprintlnbold("You're "+themecc+"at Last!");
            self freezecontrols(true);
            wait 0.5;
            self freezecontrols(false);
            self notify("at_last");
        }
        wait 0.15;
    }
}

addtime()
{
    setgametypesetting("timelimit", getgametypesetting("timelimit") + 2);
    self iprintlnbold("You ^2added^7 2 minutes!");
}

removetime()
{
    setgametypesetting("timelimit", getgametypesetting("timelimit") - 2);
    self iprintlnbold("You ^1removed^7 2 Minutes!");
}

printbinds()
{
    themecc = color(themename(self.menu["color"][0]));
    if(ffa)
    {
        self iprintln("Crouch & Press [{+actionslot 2}] to "+themecc+"Save Location");
        wait 1;
        self iprintln("Crouch & Press [{+actionslot 1}] to "+themecc+"Load Location");
        wait 1;
        self iprintln("Crouch & Press [{+actionslot 3}] to "+themecc+"Drop Canswap");
        wait 1;
        self iprintln("Prone & Press [{+actionslot 1}] to "+themecc+"Give Streaks");
    }
    else if(snd)
    {
        self iprintln("[{+speed_throw}] & [{+actionslot 2}] to "+themecc+"Teleport Bot & Freeze Bot^7 | [{+speed_throw}] & [{+actionslot 3}] to "+themecc+"Unfreeze Bot");
        wait 1;
        self iprintln("Crouch & [{+actionslot 3}] to "+themecc+"Drop Canswap");
        wait 1;
        self iprintln("Prone & [{+actionslot 1}] to "+themecc+"Give Streaks");
    }
}

printweapons()
{
    weap = self getcurrentweapon();
    offhand = self GetCurrentOffHand();
    self iprintln("Weapon: "+weap);
    self iprintln("Lethal: "+offhand);
}

printcoords()
{
    self iprintln("X :"+self.origin[0]+" Y: "+self.origin[1]+" Z: "+self.origin[2]);
}

cmdhandler()
{
    self thread suicmd();
    self thread lastcmd();
       
    if(gg)
        self thread cmdlist();
}

suicmd()
{
    level endon("game_ended");
    self notifyonplayercommand("suicmd", "sui");
    for(;;)
    {
        self waittill("suicmd");
        self suicide();
    }
}

lastcmd()
{
    self notifyonplayercommand("lastnotif", "last");
    for(;;)
    {
        self waittill("lastnotif");
        if(gg)
        {
            self.pers["pointstowin"] = 190;
            self.pointstowin = 190;  
        }
        else if(ffa)
            self thread fastlast();
    }
}

cmdlist()
{
    level endon("game_ended");
    self notifyonplayercommand("cmdlist", "cmds");
    for(;;)
    {
        self waittill("cmdlist");
        self iprintlnbold("^1/sui^7 - Suicide | ^1/last^7 - Fast Last");
    }
}

dmt() 
{
    if(self getpers("sddm") == "true")
        self setpers("sddm", "false");
    else
        self setpers("sddm", "true");
}

watermark()
{
    level endon("game_ended");
    hud2 = newclienthudelem(self);
	hud2.foreground = 1;
	hud2.sort = 1;
	hud2.hidewheninmenu = 1;
	hud2.x = -103;
	hud2.y = 467;
	hud2.alpha = 1;
	hud2.fontscale = 1;
    hud2.font = "small";
    hud2.hidewheninkillcam = true;
    for(;;)
    {
        hud2.alpha = 1;
        themecc = color(themename(self.menu["color"][0]));
        if(!self inmenu())
        {
            if(!self.copen)
                hud2 setsafetext("Press [{+speed_throw}] + [{+actionslot 1}] to Open "+themecc+"Project Nebula");
            else if(self.copen)
                hud2 setsafetext("Press [{+speed_throw}] + [{+melee}] to Open "+themecc+"Project Nebula");
        }
        else
        {
            if(!self.cnav)
                hud2 setsafetext("[{+actionslot 1}]/[{+actionslot 2}] - Scroll || [{+gostand}] - Select || [{+usereload}] - Go Back/Close");
            else
                hud2 setsafetext("[{+speed_throw}]/[{+attack}] - Scroll || [{+gostand}] - Select || [{+usereload}] - Go Back/Close");
        }  
        wait 0.5;
    }
    wait 1;
}

ema()
{
    self setpers("empty_mag_afterhit", self getpers("empty_mag_afterhit", "false") == "true" ? "false" : "true");
}

doemasnd()
{
    for(;;)
    {
        level waittill("game_ended");
        if(!isdefined(self getpers("empty_mag_afterhit")))
            return;

        if(self getpers("empty_mag_afterhit", "true") == "true")
            self setweaponammoclip(self getcurrentweapon(), 0);
        else
            return;

        wait 1;
    }
}

emaffa()
{
    if(!isdefined(self.ema))
    {
        self.ema = true;
        self thread doemaffa();
    }
    else
    {
        self.ema = undefined;
        self notify("ema");
    }
}

doemaffa()
{
    self endon("ema");
    level waittill("game_ended");
    self setweaponammoclip(self getcurrentweapon(), 0);
}

dc()
{
    if(!self.dc)
    {
        self.dc = true;
        self thread dodc();
    }
    else
    {
        self.dc = undefined;
        self notify("stop_dc");
    }
}

dodc()
{
    level endon("game_ended");
    self endon("stop_dc");
    for(;;)
    {
        rand = randomintrange(0, 45);
        weap = self getcurrentweapon();
        self takeweapon(weap);
        self giveweapon(weap, 0, rand, 0, 0, 0, 0);
        self setspawnweapon(weap);
        wait 0.001;
    }
}

instashoots() //shit gsc instashoots. sorry lol
{
    self setpers("instashoots", self getpers("instashoots", "false") == "true" ? "false" : "true");
}

doinstashootsnd()
{
    self endon("disconnect");
    for(;;)
    {
        if(self getpers("instashoots", "false") == "true")
        {
            self waittill("weapon_change", weapon);
            if(getweaponclass(weapon) == "weapon_sniper" || weapon == "saritch_mp" || weapon == "sa58_mp")
            {
                self disableweapons();
                self setweaponammoclip(weapon, weaponclipsize(weapon));
                wait 0.01;
                self enableweapons();
            }
        }
        else
            wait 0.05; 
    }
}

isdm()
{
    if(!isdefined(self.is))
    {
        self.is = true;
        self thread doisdm();
    }
    else
    {
        self.is = undefined;
        self notify("stop_is");
    }
}

doisdm()
{
    level endon("game_ended");
    self endon("stop_is");
    for(;;)
    {
        self waittill("weapon_change", weapon);
        if(getweaponclass(weapon) == "weapon_sniper" || weapon == "saritch_mp" || weapon == "sa58_mp")
        {
            self disableweapons();
            self setweaponammoclip(weapon, weaponclipsize(weapon));
            wait 0.01;
            self enableweapons();
        }
    }
}

smooth() //shitty smooth anims
{
    if(!isdefined(self.smooth))
    {
        self.smooth = true;
        self thread dosmooth();
        self iprintln("Press [{+actionslot 1}] to Use Smooth Animations");
        //these are from 2022 vekays servers, idk where they came from. prob serenity idk
    }
    else
    {
        self.smooth = undefined;
        self notify("stop_smooth");
    }
}

dosmooth()
{
    level endon("game_ended");
    self endon("stop_smooth");
    self notifyonplayercommand("dosmooth", "+actionslot 1");
    for(;;)
    {
        self waittill("dosmooth");
        self disableweapons();
        wait 0.05;
        self enableweapons();
    }
}

nc() //fuck ass noclip with a crate. figured somebody would enjoy this
{
    if(!isdefined(self.nc))
    {
        self.nc = true;
        self thread ufomsg();
        self thread donc();
    }
    else
    {
        self notify("stop_nc");
        self.nc = undefined;
    }
}

donc()
{
    level endon("game_ended");
    self endon("stop_nc");
    self.fly = 0;
    nc = spawn("script_model", self.origin);
    for(;;)
    {
        if(self secondaryoffhandbuttonpressed())
        {
            self playerlinkto(nc);
            self.fly = 1;
        }
        else
        {
            self unlink();
            self.fly = 0;
        }

        if(self meleebuttonpressed())
            self thread spawncrate();
        
        if(self.fly)
        {
            fly = self.origin + vectorscale(anglestoforward(self getplayerangles()), 60);
            nc moveto(fly, 0.03);
        }
        
        wait 0.1;
    }
}

ufomsg()
{
    self iprintln("Press [{+smoke}] to ^2Toggle UFO");
    self iprintln("Press [{+melee}] to ^2Spawn Crate");
}

spawncrate()
{
    if(!isDefined(self.crate))
    {
        self.crate = spawn("script_model", self.origin);
        self.crate setModel("t6_wpn_supply_drop_trap");
    }
    else
        self.crate MoveTo(self.origin, 0.1, 0, 0);
}

obic()
{
    if(!isdefined(self.obic))
    {
        self.obic = true;
        self thread doobic();
        self iprintln("Press [{+melee}] & [{+actionslot 3}] to Put One Bullet in Clip!");
    }
    else
    {
        self.obic = undefined;
        self notify("stop_obic");
    }
}

doobic()
{
    level endon("game_ended");
    self endon("stop_obic");
    for(;;)
    {
        if(self meleebuttonpressed() && self actionslotthreebuttonpressed())
            self setweaponammoclip(self getcurrentweapon(), 1);
        
        wait 0.01;
    }
}

emptymag()
{
    self setweaponammoclip(self getcurrentweapon(), 0);
}

giveweap(array)
{
    weapon = array;
    self thread dogw(weapon);
}

dogw(weapon)
{
    self giveweapon(weapon);
    self switchtoweapon(weapon);
}

givemelee(array)
{ 
    weapon = array;
    self thread dogmw(weapon);
    self iprintln("Press [{+melee}]!");
}

dogmw(weapon)
{
    self thread takemelee();
    self giveweapon(weapon);
}

takemelee()
{
    meleeWeapons = array("tazer_knuckles_mp", "one_inch_punch_mp", "spork_zm_alcatraz", "spoon_zm_alcatraz", "knife_mp");
    foreach(weapon in meleeWeapons)
    {
        if(self hasWeapon(weapon))
            self takeWeapon(weapon);
    }
}

lbssnd()
{
    self setpers("left_bumper_semtex", self getpers("left_bumper_semtex", "false") == "true" ? "false" : "true");
}

dolbssnd()
{
    level endon("game_ended");
    self endon("disconnect");
    for(;;)
    {
        self waittill("changed_class");
        wait 0.15;
        if(self getpers("left_bumper_semtex", "false") == "true")
        {
            self takeweapon("concussion_grenade_future_mp");
            self takeweapon("nightingale_dpad_mp");
            self takeweapon("concussion_grenade_mp");
            self takeweapon("willy_pete_mp");
            self takeweapon("sensor_grenade_mp");
            self takeweapon("emp_grenade_mp");
            self takeweapon("proximity_grenade_aoe_mp");
            self takeweapon("proximity_grenade_mp");
            self takeweapon("pda_hack_mp");
            self takeweapon("flash_grenade_mp");
            self takeweapon("trophy_system_mp");
            self takeweapon("tactical_insertion_mp");
            self giveweapon("sticky_grenade_mp");
            self setweaponammoclip("sticky_grenade_mp", 2);
        }
    }
}

lbsffa()
{
    if(!isdefined(self.lbs))
    {
        self.lbs = true;
        self thread dolbs();
    }
    else
    {
        self.lbs = undefined;
        self notify("stop_lbs");
    }
}

dolbs() //tony
{
    level endon("game_ended");
    self endon("stop_lbs");
    for(;;)
    {
        self waittill("changed_class");
        wait 0.15;
        self takeweapon("concussion_grenade_future_mp");
        self takeweapon("nightingale_dpad_mp");
        self takeweapon("concussion_grenade_mp");
        self takeweapon("willy_pete_mp");
        self takeweapon("sensor_grenade_mp");
        self takeweapon("emp_grenade_mp");
        self takeweapon("proximity_grenade_aoe_mp");
        self takeweapon("proximity_grenade_mp");
        self takeweapon("pda_hack_mp");
        self takeweapon("flash_grenade_mp");
        self takeweapon("trophy_system_mp");
        self takeweapon("tactical_insertion_mp");
        self giveweapon("sticky_grenade_mp");
        self setweaponammoclip("sticky_grenade_mp", 2); 
        wait 1;
    }
}

loopinfo()
{
    if(!isdefined(self.li))
    {
        self.li = true;
        self thread doli();
    }
    else
    {
        self.li = undefined;
        self notify("stop_li");
    }
}

doli()
{
    level endon("game_ended");
    self endon("stop_li");
    for(;;)
    {
        self iprintln("Mapname: "+getdvar("mapname"));
        self iprintln("X :"+self.origin[0]+" Y: "+self.origin[1]+" Z: "+self.origin[2]);
        wait 1;
    }
}

tfloaters()
{
    self setpers("floaters", self getpers("floaters", "true") == "true" ? "false" : "true");
}

Floaters() 
{
    for(;;)
    {
        if(self getpers("floaters", "true") == "true")
        {
            level waittill("game_ended");
            if(!self isonground())
                self thread floatdown();
        }
        wait 0.1;
    }
}

tfloaterssd()
{
    if(!self.floaters)
    {
        self.floaters = true;
        self thread floaters();
    }
    else
    {
        self.floaters = false;
        self notify("stop_float");
    }
}

floaterssd()
{
    self endon("stop_float");
    level waittill("game_ended");
    if(!self isonground())
        self thread floatdown();
}

FloatDown() {
    self endon("disconnect");
    self endon("HitGround");
    level endon("final_killcam_done");
    
    if(self IsOnGround())
        self notify("HitGround");
        
    groundPosition = BulletTrace(self.origin, self.origin - (0, 0, 5000), false, self)["position"];
    
    self.floater = spawn("script_origin", self.origin);
    self PlayerLinkTo(self.floater);
    self FreezeControls(true);
    
    for(;;) {
        if(self.origin[2] < groundPosition[2])
            self notify("HitGround");
    
        newOrigin = self.floater.origin - (0, 0, 0.5);
        self.floater MoveTo(newOrigin, 0.01);
        wait 0.01;
    }
}

refillammo()
{
    weapons = self getweaponslist();
    foreach(weapon in weapons)
    {
        if(maps\mp\killstreaks\_killstreaks::iskillstreakweapon(weapon) == 0)
            self givemaxammo(weapon);
    }
}

mifl()
{
    level endon("game_ended");
    self endon("set_to_last");
    for(;;)
    {
        if(self getpers("insta_fast_last", "true") == "true")
        {
            self thread fastlast();
            self notify("set_to_last");
        }
        wait 1;
    }
}

almosthits()
{
    level endon("game_ended");
    radius = 60;
    for(;;) 
    {
        self waittill("weapon_fired");

        if(!self isonlast())
            continue;

        end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
        forward = self getTagOrigin("j_head"); 
        predictedLoc = bulletTrace( forward, end, false, self )["position"];
        themecc = color(themename(self.menu["color"][0]));
        
        foreach(player in level.players) 
        {
            IsClose = Distance(self.origin, player.origin) < 250;
            if(isAlive(player) && getweaponclass(self getcurrentweapon()) == "weapon_sniper" && player != self && !self isonground() && !IsClose)
            {
                if(distance(player.origin, predictedLoc) < radius)
                {
                    theDistance = int(distance(player.origin, self.origin) * 0.0254);
                    self iprintlnbold("Almost Hit: ["+themecc + theDistance +"m^7]");
                }
            }
        }
		wait 0.01;
    }
}

ulw()
{
    if(self hasperk("specialty_fallheight"))
    {
        self unsetperk("specialty_fallheight");
        self iprintln("Lightweight: ^1Removed");
    }
    else
        return self iprintlnbold("^1Error:^7 You don't have lightweight equipped or set.");
}

tlwos()
{
    if(!isdefined(self.tlw))
    {
        self.tlw = true;
        self thread dotlw();
    }
    else
    {
        self.tlw = undefined;
        self notify("stop_tlw");
    }
}

dotlw()
{
    level endon("game_ended");
    self endon("stop_tlw");
    for(;;)
    {
        self waittill("spawned_player");
        if(self hasperk("specialty_fallheight"))
            self unsetperk("specialty_fallheight");
    }
}

cc1(array)
{
    if(!isdefined(self.cc1))
    {
        self.cc1 = true;
        self thread docc1(array);
    }
    else
    {
        self.cc1 = undefined;
        self notify("stop_cc1");
    }
}

docc1(array)
{
    level endon("game_ended");
    self endon("stop_cc1");
    ccb = returnactionslot(array);
    self notifyonplayercommand("class_change", ccb);
    for(;;)
    {
        self waittill("class_change");
        self notify("menuresponse", "changeclass", "custom0");
    }
}

cc2(array)
{
    if(!isdefined(self.cc2))
    {
        self.cc2 = true;
        self thread docc2(array);
    }
    else
    {
        self.cc2 = undefined;
        self notify("stop_cc2");
    }
}

docc2(array)
{
    level endon("game_ended");
    self endon("stop_cc2");
    ccb = returnactionslot(array);
    self notifyonplayercommand("class_change", ccb);
    for(;;)
    {
        self waittill("class_change");
        self notify("menuresponse", "changeclass", "custom1");
    }
}

cc3(array)
{
    if(!isdefined(self.cc3))
    {
        self.cc3 = true;
        self thread docc3(array);
    }
    else
    {
        self.cc3 = undefined;
        self notify("stop_cc3");
    }
}

docc3(array)
{
    level endon("game_ended");
    self endon("stop_cc3");
    ccb = returnactionslot(array);
    self notifyonplayercommand("class_change", ccb);
    for(;;)
    {
        self waittill("class_change");
        self notify("menuresponse", "changeclass", "custom2");
    }
}

cc4(array)
{
    if(!isdefined(self.cc4))
    {
        self.cc4 = true;
        self thread docc4(array);
    }
    else
    {
        self.cc4 = undefined;
        self notify("stop_cc4");
    }
}

docc4(array)
{
    level endon("game_ended");
    self endon("stop_cc4");
    ccb = returnactionslot(array);
    self notifyonplayercommand("class_change", ccb);
    for(;;)
    {
        self waittill("class_change");
        self notify("menuresponse", "changeclass", "custom3");
    }
}

cc5(array)
{
    if(!isdefined(self.cc5))
    {
        self.cc5 = true;
        self thread docc5(array);
    }
    else
    {
        self.cc5 = undefined;
        self notify("stop_cc5");
    }
}

docc5(array)
{
    level endon("game_ended");
    self endon("stop_cc5");
    ccb = returnactionslot(array);
    self notifyonplayercommand("class_change", ccb);
    for(;;)
    {
        self waittill("class_change");
        self notify("menuresponse", "changeclass", "custom4");
    }
}

returnactionslot(array)
{
    switch(array)
    {
        case "[{+actionslot 1}]":
            return "+actionslot 1";
        case "[{+actionslot 2}]":
            return "+actionslot 2";
        case "[{+actionslot 3}]":
            return "+actionslot 3";
        case "[{+actionslot 4}]":
            return "+actionslot 4";
        
        default:
            break;
    }
}

cps()
{
    if(!isdefined(self.cps))
    {
        self.cps = true;
        self thread customCarePackage();
    }
    else
    {
        self.cps = undefined;
        self notify("stop_cps");
    }
}

customCarePackage() 
{
    level endon("game_ended");
    self endon("stop_cps");
    playerLinked = false;
    for(;;) 
    {
        crate_ents = getentarray( "care_package", "script_noteworthy" );
        foreach(crate in crate_ents) 
        {
            if(distance(self.origin, crate.origin) < 210)  
            {
                if(self useButtonPressed()) 
                {
                    if(!playerLinked) 
                    {
                        wait 0.3;
                        if(distance(self.origin, crate.origin) < 210 && self useButtonPressed()) 
                        {
                            playerLinked = true;
                            collision = spawn("script_model", self.origin);
                            collision setModel("t6_wpn_supply_drop_ally");
                            collision hide();
                            self playerLinkTo(collision);
                            self thread maps\mp\killstreaks\_supplydrop::useholdthink( self, level.cratenonownerusetime );
                            self freeze_player_controls(0);
                        }
                    }
                }
                else 
                {
                    if(playerLinked) 
                    {
                        playerLinked = false;
                        collision delete();
                    }
                }
            }
        }
        if(self playerCarePackageCount() < 1) 
        {
            if(playerLinked) 
            {
                playerLinked = false;
                collision delete();
            }
        }
        wait 0.1;
    }
}

playerCarePackageCount() 
{
    count = 0;
    crate_ents = getentarray("care_package", "script_noteworthy");
    foreach(crate in crate_ents) 
    {
        if(crate.owner == self) 
            count++;
    }
    return count;
}

ggkos()
{
    if(!isdefined(self.ggk))
    {
        self.ggk = true;
        self thread doggk();
    }
    else
    {
        self.ggk = undefined;
        self notify("stop_ggk");
    }
}

doggk()
{
    level endon("game_ended");
    self endon("stop_ggk");
    for(;;)
    {
        self waittill("spawned_player");
        self takeweapon("knife_mp");
        self giveweapon("tazer_knuckles_mp");
    }
}

ggk()
{
    if(!self hasweapon("tazer_knuckles_mp"))
    {
        self takeweapon("knife_mp");
        self giveweapon("tazer_knuckles_mp");
        self iprintln("Galvaknuckles: ^2Given");
        self iprintln("Press [{+melee}]!");
    }
    else
        return self iprintln("^1Error:^7 You already have galvaknuckles.");
}

goipos()
{
    if(!isdefined(self.oip))
    {
        self.oip = true;
        self thread dooip();
    }
    else
    {
        self.oip = undefined;
        self notify("stop_oip");
    }
}

dooip()
{
    level endon("game_ended");
    self endon("stop_oip");
    for(;;)
    {
        self waittill("spawned_player");
        self takeweapon("knife_mp");
        self giveweapon("one_inch_punch_mp");
    }
}

gspos()
{
    if(isdefined(self.spo))
    {
        self.spo = true;
        self thread dospo();
    }
    else
    {
        self.spo = undefined;
        self notify("stop_spo");
    }
}

dospo()
{
    level endon("game_ended");
    self endon("stop_spo");
    for(;;)
    {
        self waittill("spawned_player");
        self takeweapon("knife_mp");
        self giveweapon("spoon_zm_alcatraz");
    }
}

gspkos()
{
    if(!isdefined(self.spk))
    {
        self.spk = true;
        self thread dospk();
    }
    else
    {
        self.spk = undefined;
        self notify("stop_spk");
    }
}

dospk()
{
    level endon("game_ended");
    self endon("stop_spk");
    for(;;)
    {
        self waittill("spawned_player");
        self takeweapon("knife_mp");
        self giveweapon("spork_zm_alcatraz");
    }
}

tpfreeze(player)
{
    if(!isdefined(player.tpf))
    {
        player.tpf = true;
        self thread dotpf(player);
    }
    else
    {
        player.tpf = undefined;
        player freezecontrols(false);
        self iprintln("Bot: ^1Unfrozen");
    }
}

dotpf(player)
{
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    trace_t = bullettrace(start, end, false, self)["position"];

    foreach(player in level.players)
    {
        if(player is_bot())
        {
            player setorigin(trace_t);
            player freezecontrols(true);
        }
    }
    self iprintln("Bot: ^2Teleported & Frozen");
}

proneah()
{
    if(!isdefined(self.pah))
    {
        self.pah = true;
        self iprintln("Prone Afterhit: ^2On");
        self thread dopah();
    }
    else
    {
        self.pah = undefined;
        self iprintln("Prone Afterhit: ^1Off");
        self notify("stop_pah");
    }
}

dopah()
{
    self endon("stop_pah");
    level waittill("game_ended");
    self setstance("prone");
}

rmr()
{
    if(mr == "1")
        cmdexec("map mp_carrier");
    else if(mr == "2")
        cmdexec("map mp_carrier");
    else if(mr == "3")
        cmdexec("map mp_drone");
    else
        return iprintln("^1Error:^7 You do not have a map rotation set.");
}

sut()
{
    setgametypesetting("timelimit", 0);
}

ags()
{
    self setpers("auto_streaks", self getpers("auto_streaks", "false") == "true" ? "false" : "true");
}

autostreaks()
{
    if(!isdefined(self getpers("auto_streaks")))
        return;
    
    if(self getpers("auto_streaks", "true") == "true")
        self thread streaks();
    else
        return;
}

ptimer()
{
    if(!isdefined(level.tp))
    {
        level.tp = true;
        maps\mp\gametypes\_globallogic_utils::pausetimer();
    }
    else
    {
        level.tp = undefined;
        maps\mp\gametypes\_globallogic_utils::resumetimer();
    }
}

useradiusarray(array)
{
    //array("128", "135", "150", "160", "175"));
    if(array == "135")
    {
        setdvar("player_useradius", 135);
        self iprintln("Pickup Radius: ^5135");
    }
    else if(array == "150")
    {
        setdvar("player_useradius", 150);
        self iprintln("Pickup Radius: ^5150");
    }
    else if(array == "160")
    {
        setdvar("player_useradius", 160);
        self iprintln("Pickup Radius: ^5160");
    }
    else if(array == "175")
    {
        setdvar("player_useradius", 175);
        self iprintln("Pickup Radius: ^5175");
    }
    else if(array == "200")
    {
        setdvar("player_useradius", 200);
        self iprintln("Pickup Radius: ^5200");
    }
    else if(array == "128")
    {
        setdvar("player_useradius", 128);
        self iprintln("Pickup Radius: ^1128");
    }
}

mhc()
{
    self setpers("hc_hud", self getpers("hc_hud", "false") == "true" ? "false" : "true");
}

monitorhc()
{
    for(;;)
    {
        if(self getpers("hc_hud", "true") == "true")
            self setclientuivisibilityflag("hud_visible", 0);
        else
            self setclientuivisibilityflag("hud_visible", 1);
        
        wait 0.25;
    }
}