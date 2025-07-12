#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\menu;
#include scripts\mp\utils;
#include scripts\mp\funcs;
#include scripts\mp\overflow;
#include scripts\mp\gun_game;

#define ffa getdvar("g_gametype") == "dm"
#define snd getdvar("g_gametype") == "sd"
#define gg getdvar("g_gametype") == "gun"

init()
{
    //melee weapons
    precacheitem("tazer_knuckles_mp");
    precacheitem("one_inch_punch_mp");
    precacheitem("spoon_zm_alcatraz");
    precacheitem("spork_zm_alcatraz");
    precacheitem("item_head_mp");

    precacheshader("ui_arrow_right");
    
    level.strings = [];
    level thread gamelogic();
    level thread removeskybarrier(); 
    level thread managebarriers();
    level thread onplayerconnect();
}

onplayerconnect()
{
    level endon("game_ended");
    for(;;)
    {
        level waittill("connected", player);
        if(!player is_bot()) 
        {
            player thread onplayerspawned();
            player thread cmdhandler();

            if(ffa || snd)
                player thread menuinit();
            
            if(ffa)
            {
                if(!isdefined(self getpers("insta_fast_last", "true")))
                    self setpers("insta_fast_last", "true");
                
                if(!isdefined(self getpers("auto_streaks", "false")))
                    self setpers("auto_streaks", "false");
                
                player.matchbonus = randomintrange(2500, 4050);
            }

            if(ffa || gg)
                if(!isdefined(self getpers("floaters", "true")))
                    self setpers("floaters", "true");
            
            if(snd)
            {
                if(!isdefined(self getpers("sddm", "false")))
                    self setpers("sddm", "false");
                
                if(!isdefined(self getpers("empty_mag_afterhit", "false")))
                    self setpers("empty_mag_afterhit", "false");
                
                if(!isdefined(self getpers("left_bumper_semtex", "false")))
                    self setpers("left_bumper_semtex", "false");
                
                if(!isdefined(self getpers("instashoots", "false")))
                    self setpers("instashoots", "false");
                
                if(!isdefined(self getpers("hc_hud", "false")))
                    self setpers("hc_hud", "false");
                
                player.matchbonus = randomintrange(0, 619);
            }
        }
        else if(player is_bot())
            player thread onbotspawned();
    }
}

onplayerspawned()
{
    level endon("game_ended");
    self.fspawn = true;
    if(ffa)
    {
        self.copen = false;
        self.cnav = false;
        self thread buttons();
        self thread closeondeath();
        self thread closeongameend();
        self thread controllerbinds();
        self thread monitorclass();
        self.menu["has_menu"] = true;
        thread fixoverflow(); //overflow
        self thread monitorlast();
        self thread shieldbounces();
        self thread floaters();
        self thread mifl(); //monitor insta fast last, just once.
        self thread almosthits();
    }
    else if(gg)
    {
        self thread monitorscore(); //monitor score to force end once player kills on last
        self thread monitorrco(); //monitor random class to give once on last
    }
    else if(snd)
    {
        self.copen = false;
        self.cnav = false;
        self.dc = false;
        self.floaters = false;
        self thread buttons();
        self thread closeondeath();
        self thread closeongameend();
        self.menu["has_menu"] = true;
        thread fixoverflow(); //overflow
        self thread controllerbinds();
        self thread monitorclass(); //mid-game class change

        //persistent variables
        self thread floaterssd(); //floaters
        self thread doemasnd(); //empty mag afterhits
        self thread doinstashootsnd(); //instashoots
        self thread dolbssnd(); //lb semtex
    }
    for(;;)
    {
        self waittill("spawned_player");
        if(ffa)
        {
            if(self isonlast())
            {
                self thread refillammo();
                self thread autostreaks();
            }

            if(self.fspawn)
            {
                if(level.inprematchperiod)
                    self freezecontrols(false);

                self thread welcome();
                self.fspawn = false;
            }
            
            if(isdefined(self.o) && isdefined(self.a))
            {
                self setorigin(self.o);
                self setplayerangles(self.a);
            }
        }
        else if(gg)
        {
            if(self isonlast())
                self thread dorandomclass();

            if(self.fspawn)
            {
                if(level.inprematchperiod)
                    self freezecontrols(false);
                
                self thread welcome();
                self.fspawn = false;
            }
        }
        else if(snd)
        {
            self freezecontrols(false);
            self thread watermark(); 
            self thread monitorhc();
            if(game["roundsplayed"] == 0)
                self thread welcome();
        }
    }
}

welcome()
{
    themecc = color(themename(self.menu["color"][0]));
    self thread scripts\mp\map_rotation::maprotate();
    if(ffa)
    {
        self iprintlnbold("Welcome " + themecc + self.name + "^7 to: " + themecc + "Project Nebula [FFA]!");
        wait 2;
        self iprintlnbold("[{+speed_throw}] + [{+actionslot 1}] to " + themecc + "Open Menu!");    
        wait 3;
        self iprintlnbold("Follow " +themecc+ "@d8sires^7 to Stay Updated!");
    }
    else if(gg)
    {
        self iprintlnbold("Welcome ^1"+self.name+"^7 to: ^1Project Nebula [Gun Game][No Menu]");
        wait 3;
        self iprintlnbold("Follow ^1@d8sires^7 to Stay Updated!");
        wait 2;
        self iprintlnbold("^1/cmds^7 in Console to View Commands!");
    }
    else if(snd)
    {
        self iprintln("Welcome " + themecc + self.name + "^7 to: " + themecc + "Project Nebula [S&D]!");
        self iprintln("[{+speed_throw}] + [{+actionslot 1}] to " + themecc + "Open Menu!"); 
        self iprintln("Follow " +themecc+ "@d8sires^7 to Stay Updated!");
    }
}

onbotspawned()
{
    level endon("game_ended");
    if(ffa || gg)
        self thread botswontwin();
        
    for(;;)
    {
        self waittill("spawned_player");
        if(ffa || snd)
            self thread ifriot();
    }
}