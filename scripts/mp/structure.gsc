#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\menu;
#include scripts\mp\utils;

SetMenu( menu )
{
    if( !IsDefined( menu ) )
        return;

    self.menu[ "menu" ] = menu;
}

GetMenu()
{
    if( !IsDefined( self.menu[ "menu" ] ) )
        return;

    return self.menu[ "menu" ];
}

SetTitle( title )
{
    if( !IsDefined( title ) )
        return;

    self.menu[ "title" ] = title;
}

GetTitle()
{
    if( !IsDefined( self.menu[ "title" ] ) )
        return;

    return self.menu[ "title" ];
}

SetCursor( cursor )
{
    if( !IsDefined( cursor ) )
        return;

    self.menu[ ( "cursor_" + self GetMenu() ) ] = cursor;
}

GetCursor()
{
    if( !IsDefined( self.menu[ ( "cursor_" + self GetMenu() ) ] ) )
        return;

    return self.menu[ ( "cursor_" + self GetMenu() ) ];
}

GetDescription( cursor = self GetCursor() )
{
    return self.structure[ cursor ].description;
}

HasMenu()
{
    return IsTrue( self.menu[ "has_menu" ] );
}

InMenu()
{
    if(!isdefined(self.menu["in_menu"]))
        self.menu["in_menu"] = false;
        
    return IsTrue( self.menu[ "in_menu" ] );
}

IsLocked()
{
    return IsTrue( self.menu[ "is_locked" ] );
}

IsOptionSubMenu( cursor = self GetCursor() )
{
    if( IsDefined( self.structure[ cursor ].function ) && self.structure[ cursor ].function == ::loadmenu )
        return true;

    return false;
}

IsOptionBoolean( cursor = self GetCursor() )
{
    if( IsDefined( self.structure[ cursor ].boolean ) )
        return true;

    return false;
}

IsOptionBooleanTrue( cursor = self GetCursor() )
{
    return IsTrue( self.structure[ cursor ].boolean );
}

IsOptionSlider(cursor = self GetCursor())
{
    if( IsDefined( self.structure[ cursor ].array_list ) || IsDefined( self.structure[ cursor ].start ) )
        return true;

    return false;
}

IsOptionCategory( cursor = self GetCursor() )
{
    if( IsDefined( self.structure[ cursor ].text ) && !IsDefined( self.structure[ cursor ].function ) )
        return true;

    return false;
}

EmptyFunction()
{
    self IPrintLn( "Empty Function" );
}

ExecuteFunction( function, parameter_1, parameter_2, parameter_3, parameter_4, parameter_5 )
{
    self endon( "disconnect" );
    if( !IsDefined( function ) )
        return;

    if( IsDefined( parameter_5 ) )
        return self thread [[ function ]]( parameter_1, parameter_2, parameter_3, parameter_4, parameter_5 );

    if( IsDefined( parameter_4 ) )
        return self thread [[ function ]]( parameter_1, parameter_2, parameter_3, parameter_4 );

    if( IsDefined( parameter_3 ) )
        return self thread [[ function ]]( parameter_1, parameter_2, parameter_3 );

    if( IsDefined( parameter_2 ) )
        return self thread [[ function ]]( parameter_1, parameter_2 );

    if( IsDefined( parameter_1 ) )
        return self thread [[ function ]]( parameter_1 );

    return self thread [[ function ]]();
}

addmenu(title)
{
    self.structure = [];
    if( !IsDefined( self GetCursor() ) )
        self SetCursor( 0 );

    self SetTitle( title );
}

add_option( text, description = undefined, function = ::EmptyFunction, parameter_1, parameter_2, parameter_3, parameter_4 )
{
    option             = SpawnStruct();
    option.text        = text;
    option.description = description;
    option.function    = function;
    option.parameter_1 = parameter_1;
    option.parameter_2 = parameter_2;
    option.parameter_3 = parameter_3;
    option.parameter_4 = parameter_4;

    self.structure[ self.structure.size ] = option;
}

AddOptionBoolean( text, description = undefined, function = ::EmptyFunction, variable, array = undefined, parameter_1, parameter_2, parameter_3, parameter_4 )
{
    option             = SpawnStruct();
    option.text        = text;
    option.description = description;
    option.function    = function;
    option.boolean     = IsTrue( variable );
    if( IsDefined( array ) && IsArray( array ) )
        option.array_list = array;

    option.parameter_1 = parameter_1;
    option.parameter_2 = parameter_2;
    option.parameter_3 = parameter_3;
    option.parameter_4 = parameter_4;

    self.structure[ self.structure.size ] = option;
}

AddOptionArray( text, description = undefined, function = ::EmptyFunction, array = undefined, parameter_1, parameter_2, parameter_3, parameter_4 )
{
    option             = SpawnStruct();
    option.text        = text;
    option.description = description;
    option.function    = function;
    option.array_list  = array;
    option.parameter_1 = parameter_1;
    option.parameter_2 = parameter_2;
    option.parameter_3 = parameter_3;
    option.parameter_4 = parameter_4;

    self.structure[ self.structure.size ] = option;
}

AddOptionIncrement( text, description = undefined, function = ::EmptyFunction, start = 0, minimum = 0, maximum = 10, increment = 1, parameter_1, parameter_2, parameter_3, parameter_4 )
{
    option             = SpawnStruct();
    option.text        = text;
    option.description = description;
    option.function    = function;
    option.start       = start;
    option.minimum     = minimum;
    option.maximum     = maximum;
    option.increment   = increment;
    option.parameter_1 = parameter_1;
    option.parameter_2 = parameter_2;
    option.parameter_3 = parameter_3;
    option.parameter_4 = parameter_4;

    self.structure[ self.structure.size ] = option;
}

loadmenu(menu)
{
    self notify("new_menu");
    if(!isdefined(menu))
    {
        menu = self.menu[ "previous" ][ ( self.menu["previous"].size - 1 ) ];
        self.menu[ "previous" ][ ( self.menu["previous"].size - 1 ) ] = undefined;
    }
    else
    {
        if(self getmenu() == "Players Menu")
        {
            player = level.players[self getcursor()];
            self.selected_player = player;
        }
        self.menu[ "previous" ][ self.menu[ "previous" ].size ] = self GetMenu();
    }
    
    self SetMenu( menu );
    self SetMenuText();
    self UpdateScrollbars();
}