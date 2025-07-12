#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\main;
#include scripts\mp\menu;
#include scripts\mp\structure;

#define ffa getdvar("g_gametype") == "dm"
#define snd getdvar("g_gametype") == "sd"
#define gg getdvar("g_gametype") == "gun"

//fileio
setpers(key, value)
{
    if(!isdefined(self.nebula))
        self.nebula = [];
    
    self.nebula[key] = value;

    file = fs_fopen("vars.txt", "write");
    foreach(key, value in self.nebula)
        fs_writeline(file, key + ": " + value);
    
    fs_fclose(file);
}

getpers(key, value)
{
    if(!isdefined(self.nebula))
    {
        self.nebula = [];
        file = fs_fopen("vars.txt", "read");
        if(file)
        {
            while(true)
            {
                line = fs_readline(file);
                if(!isdefined(line))
                    break;
                
                data = strtok(line, ": ");
                if(data.size >= 2)
                    self.nebula[data[0]] = data[1];
            }
            fs_fclose(file);
        }
    }
    return isdefined(self.nebula[key]) ? self.nebula[key] : value;
}

resetconfig()
{
    self.nebula = [];
    file = fs_fopen("vars.txt", "write");
    if(file)
        fs_fclose(file);
    
    menuclose();
    menuopen();
    self thread applycolors("Cyan");
    self setpers("menutheme", "cyan");

    self iprintln("^1Project Nebula config reset back to default values.");
}

//other utils
IsTrue( variable )
{
    return IsDefined( variable ) && variable;
}

IsValid()
{
    if(!IsDefined(self) || !IsAlive(self) || !IsPlayer(self) || self.sessionstate == "spectator" || self.sessionstate == "intermission")
        return false;

    return true;
}

cleanName(name) 
{
    if(!isdefined(name) || name == "") 
        return;
            
    illegal = array("^A", "^B", "^F", "^H", "^I", "^0", "^1", "^2", "^3", "^4", "^5", "^6", "^7", "^8", "^9", "j=");
    new_string = "";
    for(a = 0; a < name.size; a++) 
    {
        if(a < (name.size - 1)) 
        {
            if(isinarray(illegal, (name[a] + name[(a + 1)]))) 
            {
                a += 2;
                if(a >= name.size) 
                    break;
            }
        }

        if(isdefined(name[a]) && a < name.size) 
            new_string += name[a];
    }
    return new_string;
}

getName()
{
    name = self.name;
    if( ( name[ 0 ] != "[" ) )
        return name;

    for( a = (name.size - 1); a >= 0; a-- )
    {
        if( ( name[ a ] == "]" ) )
            break;
    }

    return GetSubStr( name, ( a + 1 ) );
}

AutoArchive()
{
    if( !IsDefined( self.menu[ "element_result" ] ) )
        self.menu[ "element_result" ] = 0;

    if( !IsAlive( self ) || self.menu[ "element_result" ] < 19 )
        return false;

    return true;
}

CreateText( text, font, font_scale, alignment, relative, x, y, color, alpha, sorting, watchtext)
{
    element = self CreateFontString(font, font_scale);
    element SetPoint(alignment, relative, x, y);
    element.color = color;
    element.alpha = alpha;
    element.sort = sorting;
    element.anchor = self;
    element.hidewheninmenu = true;
    element.hidewheninkillcam = true;
    self addtostringarray(text);
    
    if(isdefined(watchtext))
        element thread watchforoverflow();
    else
        element settext(text);

    return element;
}

CreateShader( shader, alignment, relative, x, y, width, height, color, alpha, sorting )
{
    element = NewClientHudElem( self );
    element.elemtype = "icon";
    element.children = [];
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.color = color;
    element.alpha = alpha;
    element.sort = sorting;
    element.anchor = self;
    element.hidewheninmenu = true;
    element.hidewheninkillcam = true;
    element.archived = self AutoArchive();
    element SetParent(level.uiparent);
    element SetPoint(alignment, relative, x, y);
    element SetShader(shader, width, height);
    self.menu["element_result"]++;
    return element;
}

setSafeText(text)
{
	self notify("stop_TextMonitor");
	self addToStringArray(text);
	self thread watchForOverFlow(text);
}

addToStringArray(text)
{
	if(!isInArray(level.strings, text))
    {
		level.strings[level.strings.size] = text;
		level notify("CHECK_OVERFLOW");
	}
}

watchForOverFlow(text)
{
	self endon("stop_TextMonitor");

	while(isDefined(self))
	{
		if(isDefined(text.size))
			self setText(text);
		else
		{
			self setText(undefined);
			self.label = text;
		}
		level waittill("FIX_OVERFLOW");
	}
}

DestroyElement()
{
    if( !IsDefined( self ) )
        return;

    self Destroy();
    if( IsDefined( self.anchor ) )
        self.anchor.menu[ "element_result" ]--;
}

DestroyAll( array )
{
    if( !IsDefined( array ) || !IsArray( array ) )
        return;

    keys = GetArrayKeys( array );
    for( a = 0; a < keys.size; a++ )
    {
        if( IsArray( array[ keys[ a ] ] ) )
        {
            foreach( index, value in array[ keys[ a ] ] )
            {
                if( IsDefined( value ) )
                    value DestroyElement();
            }
        }
        else
        {
            if( IsDefined( array[ keys[ a ] ] ) )
                array[ keys[ a ] ] DestroyElement();
        }
    }
}

DestroyOption()
{
    if( !IsDefined( self.menu[ "hud" ][ "option" ] ) )
        self.menu[ "hud" ][ "option" ] = [];

    element = Array( "text", "submenu", "boolean", "slider", "category" );
    for( a = 0; a < element.size; a++ )
    {
        if( IsDefined( self.menu[ "hud" ][ "option" ][ element[ a ] ] ) && self.menu[ "hud" ][ "option" ][ element[ a ] ].size )
            DestroyAll( self.menu[ "hud" ][ "option" ][ element[ a ] ] );

        self.menu[ "hud" ][ "option" ][ element[ a ] ] = [];
    }
}

InArray( array, item )
{
    if( !IsDefined( array ) || !IsArray( array ) || !IsDefined( item ) )
        return;

    for( a = 0; a < array.size; a++ )
    {
        if( ( array[ a ] == item ) )
            return true;
    }

    return false;
}

ArrayRemove( array, index )
{
    if( !IsDefined( array ) || !IsArray( array ) || !IsDefined( index ) )
        return;

    new_array = [];
    for( a = 0; a < array.size; a++ )
    {
        if( ( array[ a ] != index ))
            new_array[ new_array.size ] = array[ a ];
    }

    return new_array;
}

closeondeath()
{
    level endon("game_ended");
    for(;;)
    {
        self waittill("death");
        if(self inMenu())
            self menuClose();

        wait 0.15;
    }
}

closeongameend()
{
    for(;;)
    {
        level waittill("game_ended");
        if(self inMenu())
            self menuClose();
        
        wait 0.15;
    }
}

//color stuff
rgb(r, g, b)
{
    return(r/255, g/255, b/255);
}

color(color)
{
    if(color == "Red")
        return "^1";
    else if(color == "Green")
        return "^2";
    else if(color == "Yellow")
        return "^3";
    else if(color == "Blue")
        return "^4";
    else if(color == "Cyan")
        return "^5";
    else if(color == "Purple" || color == "Pink")
        return "^6";
    else if(color == "White")
        return "^7";
    else if(color == "Grey" || color == "Gray")
        return "^8";
    else if(color == "Black")
        return "^0";
    else
        return "^5"; 
}

themename(menuColor)
{
    if(menuColor == rgb(255, 37, 37)) 
        return "Red";
    else if(menuColor == rgb(64, 255, 0))
        return "Green";
    else if(menuColor == rgb(255, 255, 90)) 
        return "Yellow";
    else if(menuColor == rgb(14, 58, 255)) 
        return "Blue";
    else if(menuColor == rgb(0, 132, 255)) 
        return "Cyan";
    else if(menuColor == rgb(162, 0, 255)) 
        return "Purple";
    else if(menuColor == (0.5, 0.5, 0.5)) 
        return "Gray";
    else if(menuColor == (0, 0, 0)) 
        return "Black";
    else
        return "Cyan"; 
}

themevector(themeName)
{
    if(themeName == "Red")
        return rgb(255, 37, 37);
    else if(themeName == "Green")
        return rgb(64, 255, 0);
    else if(themeName == "Yellow")
        return rgb(255, 255, 90);
    else if(themeName == "Blue")
        return rgb(14, 58, 255);
    else if(themeName == "Cyan")
        return rgb(0, 132, 255);
    else if(themeName == "Purple")
        return rgb(162, 0, 255);
    else if(themeName == "Gray")
        return (0.5, 0.5, 0.5);
    else if(themeName == "Black")
        return (0, 0, 0);
    else
        return rgb(0, 132, 255);
}

setthemearray(colorname)
{
    setcolors = array("Red", "Green", "Yellow", "Blue", "Cyan", "Purple", "Gray", "Black");
    if(inarray(setcolors, colorname))
        self settheme(colorname);
}

settheme(colorname)
{
    self.menu["color"][0] = themevector(colorname); 
    setpers("menutheme", colorname);
    newcolor = color(themename(self.menu["color"][0]));
    self thread applycolors(colorname);
}

applycolors(color)
{
    vectorColor = themevector(color); 
    self.menu["color"][0] = vectorColor;
    menuclose();
    menuopen();
}

setopen(open)
{
    if(open == "[{+speed_throw}] & [{+melee}]" && !self.copen)
    {
        self.copen = true;
        self menuClose();
        self iprintln("Open Menu Binds: "+open);
    }
    else if(self.copen)
    {
        self.copen = false;
        self iprintln("Open Menu Binds: ^1Reset");
    }
}

setnav(nav)
{
    if(nav == "[{+speed_throw}] & [{+attack}]" && !self.cnav)
    {
        self.cnav = true;
        self iprintln("Navigation Binds Selected: " +nav);
    }
    else if(self.cnav)
    {
        self.cnav = false;
        self iprintln("Navigation Binds: ^1Reset");
    }
}

gameDamage(einflictor, eAttacker, iDamage, idflags, sMeansOfDeath, sWeapon, vpoint, vdir, shitloc, timeoffset, boneindex) //doktorsas damage changed a wee bit
{
	if(sMeansOfDeath == "MOD_TRIGGER_HURT" || sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING")
	{
	}
	else
	{
        if(ffa)
        {
            if(eAttacker is_bot() && !self is_bot() && getDvarInt("sv_classic") == 1)
                iDamage = iDamage / 4;
            else if(!eAttacker is_bot() && (GetWeaponClass(sWeapon) == "weapon_sniper") || sweapon == "saritch_mp" || sweapon == "sa58_mp")
            {
                iDamage = 999;
                savedthemename = getpers("menutheme");
                savedthemevector = themevector(savedthemename); 
                themecolorcode = color(themename(savedthemevector)); 
                if(eattacker isonlast())
                {
                    if((distance(self.origin, eAttacker.origin) * 0.0254) < 10)
                    {
                        iDamage = 0;
                        eAttacker iprintln("Too Close: [" + themecolorcode + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                    }
                    else if(eAttacker isOnGround())
                    {
                        iDamage = 0;
                        eAttacker iprintln("You Landed: [" + themecolorcode + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                    }
                    else
                    {
                        foreach(player in level.players)
                        {
                            if(!player is_bot())
                                player iprintln("[" + themecolorcode + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                        }
                    }
                }
            }
            if(eAttacker is_bot() && self isonlast())
            {
                idamage = 0;
            }
            if(!eAttacker is_bot() && GetWeaponClass(sWeapon) != "weapon_sniper" && eAttacker isOnLast())
            {
                iDamage = 0;
            }
            if(!eAttacker is_bot() && !eAttacker isOnLast())
            {
                [[level.callbackplayerdamage_stub]] (einflictor, eAttacker, iDamage, idflags, sMeansOfDeath, sWeapon, vpoint, vdir, shitloc, timeoffset, boneindex);
            }
        }
        else if(gg)
        {
            if(sweapon == "staff_water_mp" || sweapon == "staff_fire_mp" || sweapon == "staff_air_mp" || sweapon == "electrocuted_hands_mp")
                idamage = 100;
            
            if(eattacker isonlast() && getweaponclass(sweapon) == "weapon_sniper" || sweapon == "saritch_mp" || sweapon == "sa58_mp")
            {
                idamage = 999;
                if((distance(self.origin, eAttacker.origin) * 0.0254) < 10)
                {
                    iDamage = 0;
                    eAttacker iprintln("Too Close: [^5" + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                }
                else if(eAttacker isOnGround())
                {
                    iDamage = 0;
                    eAttacker iprintln("You landed: [^5" + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                }
                else
                {
                    foreach(player in level.players)
                    {
                        if(!player is_bot())
                            player iprintln("[^5" + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                    }
                }
            }
            else if(eattacker isonlast() && getweaponclass(sweapon) != "weapon_sniper")
                idamage = 0;
        }
        else if(snd)
        {
            if(!eAttacker is_bot() && (GetWeaponClass(sWeapon) == "weapon_sniper") || sweapon == "saritch_mp" || sweapon == "sa58_mp")
            {
                iDamage = 999;
                savedthemename = getpers("menutheme");
                savedthemevector = themevector(savedthemename); 
                themecolorcode = color(themename(savedthemevector)); 
                if(eattacker isonlast())
                {
                    if((distance(self.origin, eAttacker.origin) * 0.0254) < 10)
                    {
                        iDamage = 0;
                        if(self getpers("sddm", "true") == "true")
                            eAttacker iprintln("Too Close: [" + themecolorcode + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                    }
                    else if(eattacker isonground() && getweaponclass(sweapon) != "weapon_sniper")
                        idamage = 0;
                    else
                    {
                        if(self getpers("sddm", "true") == "true")
                        {
                            foreach(player in level.players)
                            {
                                if(!player is_bot())
                                    player iprintln("[" + themecolorcode + int(distance(self.origin, eAttacker.origin) * 0.0254) + "m^7]");
                            } 
                        }
                    }
                }
            }
        }
	}
	[[level.callbackplayerdamage_stub]] (einflictor, eAttacker, iDamage, idflags, sMeansOfDeath, sWeapon, vpoint, vdir, shitloc, timeoffset, boneindex);
}

isonlast()
{
    if(ffa)
        return self.pers["pointstowin"] == (level.scorelimit - 1);
    else if(gg)
        return self.pers["pointstowin"] == 190;
}