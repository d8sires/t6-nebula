#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\menu;
#include scripts\mp\utils;
#include scripts\mp\structure;
#include scripts\mp\funcs;

#define menu_title "Project Nebula - [v2.0.3]"
#define ffa getdvar("g_gametype") == "dm"
#define snd getdvar("g_gametype") == "sd"

MenuOption(menu = getMenu())
{
    switch(menu)
    {
        case menu_title:
            self addmenu(menu_title);
            self add_option("Self Menu", undefined, ::loadmenu, "Self Menu");
            self add_option("Afterhit Menu", undefined, ::loadmenu, "Afterhit Menu");
            self add_option("Weapons Menu", undefined, ::loadmenu, "Weapons Menu");
            self add_option("Menu Customization", undefined, ::loadmenu, "Menu Customization");
            self add_option("Game Settings", undefined, ::loadmenu, "Game Settings");
            if(snd)
                self add_option("Players Menu", undefined, ::loadmenu, "Players Menu");
            //self add_option("Developer Menu", undefined, ::loadmenu, "Developer Menu");
            break;

        case "Self Menu":
            self addmenu(menu);
            if(ffa)
            {
                self addoptionboolean("Insta Fast Last", "Get set to last automatically at the start of each game.", ::fl, self getpers("insta_fast_last", "true") == "true");
                self add_option("Fast Last", undefined, ::fastlast);
                self add_option("Fast Last 2 Piece", undefined, ::fastlast2piece);
                self add_option("Reset Last", undefined, ::resetlast);
                self add_option("Unset Spawn", undefined, ::unsetspawn);
                self add_option("Give Care Package", undefined, ::givecarepack);
                self add_option("Give Streaks", undefined, ::streaks);
                self addoptionboolean("Give Streaks on Spawn", undefined, ::ags, self getpers("auto_streaks", "false") == "true");
                self addoptionboolean("Care Package Stalls", undefined, ::cps, self.cps);
                self addoptionboolean("Noclip", undefined, ::nc, self.nc);
                self addoptionboolean("Disco Camo", undefined, ::dc, self.dc);
                self addoptionboolean("Instashoots", undefined, ::isdm, self.is);
                self addoptionboolean("Smooth Anims", undefined, ::smooth, self.smooth);
                self addoptionboolean("Floaters", undefined, ::tfloaters, self getpers("floaters", "true") == "true");
                self addoptionboolean("Take Lightweight on Spawn", "Take lightweight on spawn.", ::tlwos, self.tlw);
                self add_option("Take Lightweight", "Take lightweight off to take fall damage.", ::ulw);
                self add_option("Suicide", undefined, ::kys);
                self add_option("Reset Config", "Reset player config back to default settings.", ::resetconfig);
            }
            if(snd)
            {
                self addoptionboolean("Distance Meter", undefined, ::dmt, self getpers("sddm", "false") == "true"); 
                self addoptionboolean("Hardcore Hud", undefined, ::mhc, self getpers("hc_hud", "false") == "true");
                self addoptionboolean("Floaters", undefined, ::tfloaterssd, self.floaters);
                self addoptionboolean("Care Package Stalls", undefined, ::cps, self.cps);
                self addoptionarray("Pickup Radius", undefined, ::useradiusarray, array("128", "135", "150", "160", "175", "200"));
                self add_option("Give Care Package", undefined, ::givecarepack);
                self add_option("Give Streaks", undefined, ::streaks);
                self add_option("Drop Canswap", undefined, ::dropcanswap);
                self add_option("Refill Ammo", undefined, ::refillammo);
                self add_option("Suicide", undefined, ::kys);
                self add_option("Reset Config", "Reset player config back to default settings.", ::resetconfig);
            }
            break;

        case "Weapons Menu":
            self addmenu(menu);
            if(ffa)
            {
                self add_option("Random Class Menu", undefined, ::loadmenu, "Random Class Menu");
                self add_option("Melee Weapons Menu", undefined, ::loadmenu, "Melee Weapons Menu");
                self add_option("Mala Menu", undefined, ::loadmenu, "Mala Menu");
                self addoptionboolean("Empty Mag Afterhit", undefined, ::emaffa, self.ema); 
                self addoptionboolean("One Bullet in Clip Bind: [{+melee}] & [{+actionslot 3}]", undefined, ::obic, self.obic);
                self addoptionboolean("LB Semtex", undefined, ::lbsffa, self.lbs);
                self addoptionboolean("Auto Canswap", undefined, ::autocanswap, self.acs);
            }
            else if(snd)
            {
                self add_option("Give Random Class", undefined, ::dorandomclass);
                self add_option("Mala Menu", undefined, ::loadmenu, "Mala Menu");
                self addoptionboolean("Empty Mag Afterhit", undefined, ::ema, self getpers("empty_mag_afterhit", "false") == "true"); 
                self addoptionboolean("Disco Camo", undefined, ::dc, self.dc);
                self addoptionboolean("Instashoots", undefined, ::instashoots, self getpers("instashoots", "false") == "true");
                self addoptionboolean("Smooth Anims", undefined, ::smooth, self.smooth);
                self addoptionboolean("One Bullet in Clip Bind: [{+melee}] & [{+actionslot 1}]", undefined, ::obic, self.obic);
                self addoptionboolean("LB Semtex", undefined, ::lbssnd, self getpers("left_bumper_semtex", "false") == "true"); 
                self addoptionboolean("Auto Canswap", undefined, ::autocanswap, self.acs);
                self add_option("Drop Canswap", undefined, ::dropcanswap);
                self add_option("Refill Ammo", undefined, ::refillammo);
            }            
            break;
        
        case "Random Class Menu":
            self addmenu(menu);
            self add_option("Give Random Class", undefined, ::dorandomclass);
            self addoptionboolean("Give Random Class on Spawn", undefined, ::dorandomclasstoggle, self.randomclass);
            self addoptionboolean("Streaks w/ Random Class on Spawn", undefined, ::swrc, self.swrc);
            break;

        case "Melee Weapons Menu":
            self addmenu(menu);
            if(ffa)
            {
                self addoptionboolean("Give Galvaknuckles on Spawn", undefined, ::ggkos, self.ggk);
                self addoptionboolean("Give One Inch Punch on Spawn", undefined, ::goipos, self.oip);
                self addoptionboolean("Give Spoon on Spawn", undefined, ::gspos, self.spo);
                self addoptionboolean("Give Spork on Spawn", undefined, ::gspkos, self.spk);
            }
            self add_option("Give Galvaknuckles", undefined, ::givemelee, "tazer_knuckles_mp");
            self add_option("Give One Inch Punch", undefined, ::givemelee, "one_inch_punch_mp");
            self add_option("Give Mob Spoon", undefined, ::givemelee, "spoon_zm_alcatraz");
            self add_option("Give Mob Gold Spork", undefined, ::givemelee, "spork_zm_alcatraz");
            break;
        
        case "Mala Menu":
            self addmenu(menu);
            self add_option("Give Bomb", undefined, ::giveweap, "briefcase_bomb_defuse_mp");
            self add_option("Give iPad", undefined, ::giveweap, "killstreak_remote_turret_mp");
            self add_option("Give Claymore", undefined, ::giveweap, "claymore_mp");
            self add_option("Give Blackhat", undefined, ::giveweap, "pda_hack_mp");
            self add_option("Give Zombie Head", undefined, ::giveweap, "item_head_mp");
            break;
        
        case "Afterhit Menu":
            self addmenu(menu);
            self add_option("Main Afterhits", undefined, ::loadmenu, "Main Afterhits");
            self add_option("Misc Afterhits", undefined, ::loadmenu, "Misc Afterhits");
            self add_option("Prone Afterhit", undefined, ::proneah);
            break;

        case "Main Afterhits":
            self addmenu(menu);
            self add_option("DSR-50", undefined, ::afterhit, "dsr50_mp");
            self add_option("Ballista", undefined, ::afterhit, "ballista_mp");
            self add_option("Barrett M82A1", undefined, ::afterhit, "barretm82_mp");
            self add_option("Colt M16A1", undefined, ::afterhit, "m16_mp");
            self add_option("Uzi", undefined, ::afterhit, "uzi_mp");
            self add_option("AK74u", undefined, ::afterhit, "ak74u_mp");
            self add_option("MP5", undefined, ::afterhit, "mp5k_mp");
            self add_option("M1927", undefined, ::afterhit, "thompson_mp");
            self add_option("Olympia", undefined, ::afterhit, "rottweil72_mp");
            self add_option("Remington New Model Army", undefined, ::afterhit, "rnma_mp");
            self add_option("M1911", undefined, ::afterhit, "m1911_mp");
            self add_option("Mauser C96", undefined, ::afterhit, "c96_mp");
            break;
        
        case "Misc Afterhits":
            self addmenu(menu);
            self add_option("Zombie Head", undefined, ::afterhit, "item_head_mp");
            self add_option("Mob Shield", undefined, ::afterhit, "alcatraz_shield_mp");
            self add_option("Ice Staff", undefined, ::afterhit, "staff_water_mp");
            self add_option("Fire Staff", undefined, ::afterhit, "staff_fire_mp");
            self add_option("Wind Staff", undefined, ::afterhit, "staff_air_mp");
            self add_option("Ballistic Knife", undefined, ::afterhit, "knife_ballistic_mp");
            self add_option("Hunter Killer", undefined, ::afterhit, "missile_drone_mp");
            self add_option("Death Machine", undefined, ::afterhit, "minigun_mp");
            self add_option("iPad", undefined, ::afterhit, "killstreak_remote_turret_mp");
            self add_option("Bomb", undefined, ::afterhit, "briefcase_bomb_mp");
            break;
        
        case "Menu Customization":
            self addmenu(menu);
            self addoptionarray("Set Project Theme", "Set distance meter and menu color.", ::settheme, array("Red", "Blue", "Green", "Yellow", "Blue", "Cyan", "Purple", "Gray", "Black"));
            self addoptionarray("Open Menu Binds", undefined, ::setopen, array("[{+speed_throw}] & [{+melee}]"));
            self addoptionarray("Menu Navigation Binds", undefined, ::setnav, array("[{+speed_throw}] & [{+attack}]"));
            break;

        case "Game Settings":
            self addmenu(menu);
            if(ffa)
            {
                self add_option("Add 2 Minutes", undefined, ::addtime);
                self add_option("Remove 2 Minutes", undefined, ::removetime);
                self add_option("Set Unlimited Time", undefined, ::sut);
                self add_option("Restart Map Rotation", undefined, ::rmr);
            }
            else if(snd)
            {
                self addoptionboolean("Pause Timer", "Pause the game timer. This stops auto plant/defuse.", ::ptimer, level.tp);
                self add_option("Restart Map Rotation", undefined, ::rmr);
            }
            break;
        
        case "Developer Menu":
            self addmenu(menu);
            self add_option("Overflow Test", undefined, ::loadmenu, "Overflow Menu");
            break;
        
        case "Overflow Menu":
            self addmenu(menu);
            for(i = 0; i < 100; i++) self add_option("Overflow: "+i, "Current Overflow Test: "+i);
            break;
        
        case "Players Menu":
            self addmenu(menu);
            foreach(player in level.players)
            {
                if(player is_bot())
                    self add_option(cleanname(player getname()), undefined, ::loadmenu, "Player Options");
            }
            break;
            
        default:
            if(!isdefined(self.selected_player))
                self.selected_player = self;

            self playersmenu(menu, self.selected_player);
            break;
    }
}

playersmenu(menu, player)
{
    switch(menu)
    {
        case "Player Options":
            self addmenu(cleanname(player getname()));
            self add_option("Teleport & Freeze Bot (To Crosshair)", undefined, ::tpfreeze, player);
            break;

        default:
            break;
    }
}