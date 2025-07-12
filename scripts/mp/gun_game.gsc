#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\utils;
#include scripts\mp\funcs;

#define gg getdvar("g_gametype") == "gun"
#define gl getdvar("weapon_ladder")

main()
{
    if(gg)
    {
        replacefunc(maps\mp\gametypes\gun::main, ::ggmain);
        replacefunc(maps\mp\gametypes\gun::onplayerkilled, ::onplayerkilled);
    }
}

ggmain()
{
    maps\mp\gametypes\_globallogic::init();
    maps\mp\gametypes\_callbacksetup::setupcallbacks();
    maps\mp\gametypes\_globallogic::setupcallbacks();
    level.onstartgametype = ::onstartgametype;
    level.onspawnplayer = ::onspawnplayer;
    level.onspawnplayerunified = ::onspawnplayerunified;
    level.onplayerkilled = ::onplayerkilled;
    level.onwagerawards = ::onwagerawards;
    level.onendgame = ::onendgame;
    game["dialog"]["gametype"] = "gg_start";
    game["dialog"]["wm_promoted"] = "gg_promote";
    game["dialog"]["wm_humiliation"] = "mpl_wager_humiliate";
    game["dialog"]["wm_humiliated"] = "sns_hum";
    level.givecustomloadout = ::givecustomloadout;
    precachestring( &"MPUI_PLAYER_KILLED" );
    precachestring( &"MP_GUN_NEXT_LEVEL" );
    precachestring( &"MP_GUN_PREV_LEVEL" );
    precachestring( &"MP_GUN_PREV_LEVEL_OTHER" );
    precachestring( &"MP_HUMILIATION" );
    precachestring( &"MP_HUMILIATED" );
    precacheitem( "minigun_wager_mp" );
    precacheitem( "m32_wager_mp" );
    level.setbacksperdemotion = getgametypesetting( "setbacks" );

    normal = true;
    custom = false;
    random = false;

    if(gl == "0") //normal ladder
    {
        addguntoprogression( "dsr50_mp" );
        addguntoprogression( "mp40_mp" );
        addguntoprogression( "uzi_mp" );
        addguntoprogression( "usrpg_mp" );
        addguntoprogression( "svu_mp+ir" );
        addguntoprogression( "blundergat_mp" );
        addguntoprogression( "staff_water_mp" );
        addguntoprogression( "fnfal_mp" );
        addguntoprogression( "crossbow_mp" );
        addguntoprogression( "dsr50_mp+ir" );
        addguntoprogression( "spas_mp" );
        addguntoprogression( "qbb95_mp+rangefinder" );
        addguntoprogression( "m1911_mp" );
        addguntoprogression( "ballista_mp+ir" );
        addguntoprogression( "kard_dw_mp" );
        addguntoprogression( "ksg_mp" );
        addguntoprogression( "knife_ballistic_mp" );
        addguntoprogression( "peacekeeper_mp" );
        addguntoprogression( "hk416_mp+acog" );
        addguntoprogression( "rnma_mp" ); //this will be replaced by a trickshot class 
    }
    else if(gl == "1") //custom weapons only
    {
        addguntoprogression( "mp40_mp" );
        addguntoprogression( "staff_fire_mp" );
        addguntoprogression( "c96_mp" );
        addguntoprogression( "thompson_mp" );
        addguntoprogression( "dragunov_mp" );
        addguntoprogression( "m60_mp" );
        addguntoprogression( "barretm82_mp" );
        addguntoprogression( "blundergat_mp" );
        addguntoprogression( "rpg_player_mp" );
        addguntoprogression( "m1911_mp" );
        addguntoprogression( "m16_mp" );
        addguntoprogression( "galil_mp" );
        addguntoprogression( "makarov_mp" );
        addguntoprogression( "ak47_mp" );
        addguntoprogression( "rpd_mp" );
        addguntoprogression( "rottweil72" );
        addguntoprogression( "staff_water_mp" );
        addguntoprogression( "mgl_mp" );
        addguntoprogression( "staff_air_mp" );
        addguntoprogression( "dsr50_mp" ); //this will be replaced by a trickshot class
    }
    else if(gl == "2") //random weapons
    {
        weapon = [];
        weapons = strTok("kard_mp,fnp45_mp,beretta93r_mp,judge_mp,fiveseven_mp,rnma_mp,browninghp_mp,m1911_mp,kard_dw_mp,fnp45_dw_mp,fiveseven_dw_mp,judge_dw_mp,beretta93r_dw_mp,makarov_mp,c96_mp,mp7_mp,evoskorpion_mp,pdw57_mp,qcw05_mp,insas_mp,vector_mp,peacekeeper_mp,mp40_mp,uzi_mp,ak74u_mp,mp5k_mp,thompson_mp,xm8_mp,scar_mp,an94_mp,sig556_mp,type95_mp,hk416_mp,tar21_mp,galil_mp,m16_mp,fnfal_mp,ak47_mp,mk48_mp,qbb95_mp,lsat_mp,hamr_mp,rpd_mp,m60_mp,mg08_mp,dragunov_mp,ballista_mp,svu_mp,dsr50_mp,as50_mp,barretm82_mp,870mcs_mp,srm1216_mp,saiga12_mp,ksg_mp,blundergat_mp,spas_mp,rottweil72_mp,smaw_mp,usrpg_mp,m220_tow_mp,stinger_mp,rpg_player_mp,electrocuted_hands_mp,mgl_mp,staff_water_mp,crossbow_mp,knife_ballistic_mp,staff_fire_mp,staff_air_mp", ",");
        for(i = 0; i < 19; i++)
        {
            rand_weapon = randomint(weapons.size);
            while(isinarray(weapon, rand_weapon))
                rand_weapon = randomint(weapons.size);
            
            weapon[weapon.size] = rand_weapon;
            addguntoprogression(weapons[rand_weapon]);
        }
        addguntoprogression("dsr50_mp"); //this will be replaced by a trickshot class
    }

    registertimelimit( 0, 1440 );
    registerroundlimit( 0, 10 );
    registerroundwinlimit( 0, 10 );
    registernumlives( 0, 100 );
    setscoreboardcolumns( "pointstowin", "kills", "deaths", "stabs", "humiliated" );
}

onplayerkilled( einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration )
{
    if ( isdefined( attacker ) && isplayer( attacker ) )
    {
        if ( isdefined( attacker.lastpromotiontime ) && attacker.lastpromotiontime + 3000 > gettime() )
            maps\mp\_scoreevents::processscoreevent( "kill_in_3_seconds_gun", attacker, self, sweapon );
        
        if(attacker isonlast() && getweaponclass(sweapon) == "weapon_sniper")
        {
            attacker.pers["pointstowin"] = 200;
            attacker.pointstowin = 200;
        }

        if ( smeansofdeath == "MOD_MELEE" )
        {
            if ( maps\mp\gametypes\_globallogic::istopscoringplayer( self ) )
                maps\mp\_scoreevents::processscoreevent( "knife_leader_gun", attacker, self, sweapon );
            else
                maps\mp\_scoreevents::processscoreevent( "humiliation_gun", attacker, self, sweapon );

            attacker playlocalsound( game["dialog"]["wm_humiliation"] );

            if(!self isonlast())
                self thread demoteplayer();
        }
        else
            attacker thread promoteplayer( sweapon );
    }
}

monitorscore()
{
    level endon("game_ended");
    for(;;)
    {
        if(self.pers["pointstowin"] == 200)
        {
            thread maps\mp\gametypes\_globallogic::endgame(self, game["strings"]["score_limit_reached"]);
            break;
        }
        wait 0.1;
    }
}

monitorrco()
{
    level endon("game_ended");
    self endon("class_given");
    for(;;)
    {
        if(self.pers["pointstowin"] == 190)
        {
            wait 0.4;
            self thread dorandomclass();
            self notify("class_given");
        }
        wait 0.1;
    }
}