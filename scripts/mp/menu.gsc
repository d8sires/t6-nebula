#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_hud_message;

#include scripts\mp\utils;
#include scripts\mp\structure;
#include scripts\mp\funcs;
#include scripts\mp\options;

#define menu_title "Project Nebula - [v2.0.3]"

menuinit()
{
    if(!isdefined(self.menu))
        self.menu = [];
    
    if(!isdefined(self.menu["previous"]))
        self.menu["previous"] = [];
    
    self.menu["font"] = "big";
    self.menu["font_scale"] = 1;
    self.menu["option_limit"] = 12;
    self.menu["option_spacing"] = 16;
    self.menu["x_offset"] = 120; //170
    self.menu["y_offset"] = 90;
    self.menu["interaction"] = true;
    self.menu["description"] = true;
    self.menu["scrolling_buffer"] = true;

    if(!isdefined(self.menu["color"]))
        self.menu["color"] = [];
    
    savedtheme = getpers("menutheme", "Cyan");
    themecolor = themevector(savedtheme);
    self.menu["color"][0] = themecolor;
    self.menu["color"][1] = (0.109, 0.129, 0.156); //header
    self.menu["color"][2] = (0.133, 0.152, 0.180);
    self.menu["color"][3] = (0.150, 0.170, 0.211);
    self.menu["color"][4] = (1, 1, 1); //text color

    self setmenu(menu_title);
    self settitle(self getmenu());
}

buttons()
{
    level endon("game_ended");

    if(!isdefined(self.menu))
        self.menu = []; 
    
    for(;;)
    {
        if(self isValid())
        {
            if( !self InMenu() )
            {
                if(!self.copen)
                {
                    if(self adsbuttonpressed() && self actionslotonebuttonpressed())
                    {
                        self MenuOpen();
                        while(self adsbuttonpressed() && self actionslotonebuttonpressed())
                            wait 0.18;
                    } 
                }
                else if(self.copen)
                {
                    if(self adsbuttonpressed() && self meleebuttonpressed())
                    {
                        self MenuOpen();
                        while(self adsbuttonpressed() && self meleebuttonpressed())
                            wait 0.18;
                    } 
                }
            }
            else
            {
                menu = self GetMenu();
                cursor = self GetCursor();
                if(self usebuttonpressed())
                {
                    if( IsDefined( self.menu[ "previous" ][ ( self.menu[ "previous" ].size - 1 ) ] ) )
                        self loadmenu();
                    else
                        self MenuClose();

                    while(self usebuttonpressed())
                        wait 0.10;
                }
                if(!self.cnav)
                {
                    if(self actionslotonebuttonpressed() && !self actionslottwobuttonpressed() || self actionslottwobuttonpressed() && !self actionslotonebuttonpressed() )
                    {
                        if( IsDefined( self.structure ) && self.structure.size >= 2 )
                        {
                            scrolling = self actionslottwobuttonpressed() ? 1 : -1;
                            self SetCursor( ( cursor + scrolling ) );
                            self UpdateScrolling( scrolling );
                        }
                        wait ( 0.05 * self.menu[ "scrolling_buffer" ] );
                    }
                }
                else if(self.cnav)
                {
                    if(self adsbuttonpressed() && !self attackbuttonpressed() || self attackbuttonpressed() && !self adsbuttonpressed() )
                    {
                        if( IsDefined( self.structure ) && self.structure.size >= 2 )
                        {
                            scrolling = self attackbuttonpressed() ? 1 : -1;
                            self SetCursor( ( cursor + scrolling ) );
                            self UpdateScrolling( scrolling );
                        }
                        wait ( 0.05 * self.menu[ "scrolling_buffer" ] );
                    }
                }
                if( ( self actionslotfourbuttonpressed() || self actionslotthreebuttonpressed() ) && !self actionslotfourbuttonpressed() != !self actionslotthreebuttonpressed())
                {
                    if( isOptionSlider( cursor ) )
                    {
                        scrolling = self actionslotthreebuttonpressed() ? 1 : -1;
                        self SetSliderText( scrolling );
                        self UpdateSliderProgression();
                    }
                    wait ( 0.05 * self.menu[ "scrolling_buffer" ] );
                }
                if( self jumpbuttonpressed() )
                {
                    if( IsDefined( self.structure[ cursor ] ) && IsDefined( self.structure[ cursor ].function ) )
                    {
                        if( IsOptionSlider( cursor ) )
                            self thread ExecuteFunction( self.structure[ cursor ].function, IsDefined( self.structure[ cursor ].array_list ) ? self.structure[ cursor ].array_list[ self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] ] : self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ], self.structure[ cursor ].parameter_1, self.structure[ cursor ].parameter_2, self.structure[ cursor ].parameter_3, self.structure[ cursor ].parameter_4 );
                        else
                            self thread ExecuteFunction( self.structure[ cursor ].function, self.structure[ cursor ].parameter_1, self.structure[ cursor ].parameter_2, self.structure[ cursor ].parameter_3, self.structure[ cursor ].parameter_4 );

                        if( IsDefined(self.structure[ cursor ] ) && IsOptionBoolean( cursor ) )
                            self SetMenuText();
                    }

                    while( self jumpButtonPressed() )
                        wait 0.1;
                }
            }
        }
        wait 0.05;
    }
}

MenuOpen( menu = self GetMenu() )
{
    if( !IsDefined( self.menu[ "hud" ] ) )
        self.menu[ "hud" ] = [];

    if( !IsDefined( self.menu[ "hud" ][ "background" ] ) )
        self.menu[ "hud" ][ "background" ] = [];

    if( !IsDefined( self.menu[ "hud" ][ "foreground" ] ) )
        self.menu[ "hud" ][ "foreground" ] = [];

    self.menu[ "hud" ][ "background" ][ "border" ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", self.menu[ "x_offset" ], ( self.menu[ "y_offset" ] - 1 ), 222, 34, self.menu[ "color" ][ 0 ], 1, 1 );
    self.menu[ "hud" ][ "background" ][ "primary" ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 1 ), self.menu[ "y_offset" ], 220, 32, self.menu[ "color" ][ 1 ], 1, 2 );
    self.menu[ "hud" ][ "background" ][ "secondary" ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 1 ), ( self.menu[ "y_offset" ] + 16 ), 220, 16, self.menu[ "color" ][ 2 ], 1, 3 );
    self.menu[ "hud" ][ "background" ][ "scrollbar" ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 1 ), ( self.menu[ "y_offset" ] + 16 ), 215, 16, self.menu[ "color" ][ 3 ], 1, 4 );
    self.menu[ "hud" ][ "background" ][ "web_scrollbar" ] = self CreateShader( "white", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 221 ), ( self.menu[ "y_offset" ] + 16 ), 4, 16, (0.25, 0.25, 0.25), 1, 4 );

    self SetMenu( menu );
    self SetMenuText();
    self UpdateScrollbars();

    self.menu[ "in_menu" ] = true;
}

MenuClose()
{
    self notify( "menu_closed" );
    self DestroyOption();
    self DestroyAll( self.menu[ "hud" ][ "background" ] );
    self DestroyAll( self.menu[ "hud" ][ "foreground" ] );
    
    self.menu[ "in_menu" ] = false;
}

SetMenuTitle( title = self GetTitle() )
{
    if( !IsDefined( self.menu[ "hud" ][ "foreground" ][ "title" ] ) )
        self.menu[ "hud" ][ "foreground" ][ "title" ] = self CreateText( title, self.menu[ "font" ], self.menu[ "font_scale" ], "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 4 ), ( self.menu[ "y_offset" ] + 2 ), self.menu[ "color" ][ 4 ], 1, 10 );

    self.menu[ "hud" ][ "foreground" ][ "title" ] SetSafeText( title );
}

SetMenuDescription( description = self GetDescription() )
{
    if( IsDefined( self.menu[ "hud" ][ "foreground" ][ "description" ] ) && !IsTrue( self.menu[ "description" ] ) || IsDefined( self.menu[ "hud" ][ "foreground" ][ "description" ] ) && !IsDefined( description ) )
        self.menu[ "hud" ][ "foreground" ][ "description" ] DestroyElement();

    if( IsDefined( description ) && IsTrue( self.menu[ "description" ] ) )
    {
        if( !IsDefined( self.menu[ "hud" ][ "foreground" ][ "description" ] ) )
            self.menu[ "hud" ][ "foreground" ][ "description" ] = self CreateText( description, self.menu[ "font" ], self.menu[ "font_scale" ], "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 4 ), ( self.menu[ "y_offset" ] + 34 ), self.menu[ "color" ][ 4 ], 1, 10 );

        self.menu[ "hud" ][ "foreground" ][ "description" ] SetSafeText( description );
    }
}

SetMenuText()
{
    self MenuOption();
    self DestroyOption();

    if(!isdefined(self.structure) || !self.structure.size)
        self add_option("Nothing to see here...");

    self SetMenuTitle();
    self SetMenuDescription();
    if( IsDefined( self.structure ) && self.structure.size )
    {
        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "text" ][ 0 ] ) )
            self.menu[ "hud" ][ "option" ][ "text" ][ 0 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "text" ][ 1 ] ) )
            self.menu[ "hud" ][ "option" ][ "text" ][ 1 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "boolean" ][ 0 ] ) )
            self.menu[ "hud" ][ "option" ][ "boolean" ][ 0 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "boolean" ][ 1 ] ) )
            self.menu[ "hud" ][ "option" ][ "boolean" ][ 1 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "slider" ][ 0 ] ) )
            self.menu[ "hud" ][ "option" ][ "slider" ][ 0 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ] ) )
            self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ] = [];

        if( !IsDefined( self.menu[ "hud" ][ "option" ][ "category" ][ 0 ] ) )
            self.menu[ "hud" ][ "option" ][ "category" ][ 0 ] = [];

        menu         = self GetMenu();
        cursor       = self GetCursor();
        option_limit = Min( self.structure.size, self.menu[ "option_limit" ] );
        for( a = 0; a < option_limit; a++ )
        {
            start = ( self GetCursor() >= Int( ( self.menu[ "option_limit" ] / 2 ) ) ) && ( self.structure.size > self.menu[ "option_limit" ] ) ? ( ( self GetCursor() + Int( ( self.menu[ "option_limit" ] / 2 ) ) ) >= ( self.structure.size - 1 ) ) ? ( self.structure.size - self.menu[ "option_limit" ] ) : ( self GetCursor() - Int( ( self.menu[ "option_limit" ] / 2 ) ) ) : 0;
            index = ( a + start );
            if( IsOptionSubMenu( index ) )
                self.menu[ "hud" ][ "option" ][ "submenu" ][ index ] = self CreateShader( "ui_arrow_right", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 214 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 22 ) ), 4, 4, ( cursor == index ) ? self.menu[ "color" ][ 0 ] : self.menu[ "color" ][ 4 ], 1, 10 );

            if( IsOptionBoolean( index ) )
            {
                self.menu[ "hud" ][ "option" ][ "boolean" ][ 0 ][ index ] = self CreateShader( "white", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 14 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 19 ) ), 10, 10, ( cursor == index ) ? self.menu[ "color" ][ 2 ] : self.menu[ "color" ][ 1 ], 1, 9 );
                if( IsOptionBooleanTrue( index ) )
                    self.menu[ "hud" ][ "option" ][ "boolean" ][ 1 ][ index ] = self CreateShader( "white", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 13 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 20 ) ), 8, 8, self.menu[ "color" ][ 0 ], 1, 10 ); // Changed to always use light green
            }

            if( IsOptionSlider( index ) )
            {
                self SetSliderText( 0, index );
                if( IsDefined( self.structure[ index ].array_list ) )
                    self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ index ] = self CreateText( self.structure[ index ].array_list[ self.menu[ ( "slider_" + ( menu + "_" + index ) ) ] ], self.menu[ "font" ], self.menu[ "font_scale" ], "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 213 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 18 ) ), self.menu[ "color" ][ 4 ], 1, 10 ); // Changed to always use light green
                else
                {
                    if( ( cursor == index ) )
                        self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ index ] = self CreateText( self.menu[ ( "slider_" + ( menu + "_" + index ) ) ], self.menu[ "font" ], self.menu[ "font_scale" ], "TOPCENTER", "TOPCENTER", ( self.menu[ "x_offset" ] + 192 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 18 ) ), self.menu[ "color" ][ 4 ], 1, 10 ); // Changed to use light green

                    self.menu[ "hud" ][ "option" ][ "slider" ][ 0 ][ index ] = self CreateShader( "white", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 213 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 19 ) ), 42, 10, ( cursor == index ) ? self.menu[ "color" ][ 2 ] : self.menu[ "color" ][ 1 ], 1, 8 );
                    self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ][ index ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 172 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 20 ) ), 1, 8, ( cursor == index ) ? self.menu[ "color" ][ 0 ] : self.menu[ "color" ][ 4 ], 1, 9 );
                }
                self UpdateSliderProgression( index );
            }

            if( IsOptionCategory( index ) )
            {
                self.menu[ "hud" ][ "option" ][ "category" ][ 0 ][ index ] = self CreateShader( "white", "TOP_LEFT", "TOPCENTER", ( self.menu[ "x_offset" ] + 4 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 24 ) ), 30, 1, self.menu[ "color" ][ 0 ], 1, 10 );
                self.menu[ "hud" ][ "option" ][ "category" ][ 1 ][ index ] = self CreateShader( "white", "TOP_RIGHT", "TOPCENTER", ( self.menu[ "x_offset" ] + 214 ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 24 ) ), 30, 1, self.menu[ "color" ][ 0 ], 1, 10 );
            }
            self.menu[ "hud" ][ "option" ][ "text" ][ 0 ][ index ] = self CreateText( IsOptionSlider( index ) ? ( self.structure[ index ].text + ":" ) : self.structure[ index ].text, self.menu[ "font" ], self.menu[ "font_scale" ], IsOptionCategory( index ) ? "TOPCENTER" : "TOP_LEFT", "TOPCENTER", IsOptionBoolean( index ) ? ( self.menu[ "x_offset" ] + 16 ) : ( IsOptionCategory( index ) ? ( self.menu[ "x_offset"] + 109 ) : ( self.menu[ "x_offset" ] + 4 ) ), ( self.menu[ "y_offset" ] + ( ( a * self.menu[ "option_spacing" ] ) + 18 ) ), IsOptionCategory( index ) ? self.menu[ "color" ][ 0 ] : ( ( cursor == index ) ? self.menu[ "color" ][ 0 ] : self.menu[ "color" ][ 4 ] ), 1, 10 );
        }
    }
    self UpdateScaleResize();
}

SetSliderText( scrolling, cursor = self GetCursor() )
{
    menu = self GetMenu();
    if( !IsDefined( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] ) )
        self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] = IsDefined( self.structure[ cursor ].array_list ) ? 0 : self.structure[ cursor ].start;

    if( IsDefined( self.structure[ cursor ].array_list ) )
    {
        if( ( scrolling == -1 ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ]++;

        if( ( scrolling == 1 ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ]--;

        if( ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] > ( self.structure[ cursor ].array_list.size - 1 ) ) || ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] < 0 ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] = ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] > ( self.structure[ cursor ].array_list.size - 1 ) ) ? 0 : ( self.structure[ cursor ].array_list.size - 1 );

        if( IsDefined( self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ cursor ] ) )
            self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ cursor ] SetSafeText( self.structure[ cursor ].array_list[ self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] ] );
    }
    else
    {
        if( ( scrolling == -1 ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] += self.structure[ cursor ].increment;

        if( ( scrolling == 1 ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] -= self.structure[ cursor ].increment;

        if( ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] > self.structure[ cursor ].maximum ) || ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] < self.structure[ cursor ].minimum ) )
            self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] = ( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] > self.structure[ cursor ].maximum ) ? self.structure[ cursor ].minimum : self.structure[ cursor ].maximum;

        if( IsDefined( self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ cursor ] ) )
            self.menu[ "hud" ][ "option" ][ "text" ][ 1 ][ cursor ] SetValue( self.menu[ ( "slider_" + ( menu + "_" + cursor ) ) ] );
    }
}

updateSliderProgression(cursor = self getCursor())
{
    menu = self getMenu();
    if(isdefined(self.menu["hud"]["option"]["slider"][1][cursor]))
    {
        adjustment = (abs((self.structure[cursor].minimum - self.structure[cursor].maximum)) / (self.menu["hud"]["option"]["slider"][0][cursor].width - 2));
        width = int((abs((self.menu[("slider_" + (menu + "_" + cursor))] - self.structure[cursor].minimum)) / adjustment));

        self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ][ cursor ].alpha = ( width != 0 ) ? 1 : 0;
        self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ][ cursor ] SetShader( self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ][ cursor ].shader, ( width == 0 ) ? 1 : width, self.menu[ "hud" ][ "option" ][ "slider" ][ 1 ][ cursor ].height );
    }
}

UpdateScrolling( scrolling )
{
    if( IsDefined( self.structure[ self GetCursor() ] ) && IsOptionCategory() )
    {
        self SetCursor( ( self GetCursor() + scrolling ) );
        return self UpdateScrolling( scrolling );
    }

    if( ( self GetCursor() >= self.structure.size ) || ( self GetCursor() < 0 ) )
        self SetCursor( ( self GetCursor() >= self.structure.size ) ? 0 : ( self.structure.size - 1 ) );

    self SetMenuText();
    self UpdateScrollbars();
}

UpdateScrollbars()
{
    option_limit = Min( self.structure.size, self.menu[ "option_limit" ] );
    height       = Int( ( self.menu[ "option_spacing" ] * option_limit ) );
    adjustment   = ( self.structure.size > self.menu[ "option_limit" ] ) ? ( ( 180 / self.structure.size ) * option_limit ) : height;
    position     = ( self.structure.size > self.menu[ "option_limit" ] ) ? ( ( self.structure.size - 1 ) / ( height - adjustment ) ) : 0;
    if(IsDefined( self.menu[ "hud" ][ "background" ][ "scrollbar" ] ) )
        self.menu[ "hud" ][ "background" ][ "scrollbar" ].y = ( self.menu[ "hud" ][ "option" ][ "text" ][ 0 ][ self GetCursor() ].y - 2 );

    if(IsDefined(self.menu[ "hud" ][ "background" ][ "web_scrollbar" ]))
    {
        self.menu[ "hud" ][ "background" ][ "web_scrollbar" ].y = ( self.menu[ "y_offset" ] + 16 );
        if( ( self.structure.size > self.menu[ "option_limit" ] ) )
            self.menu[ "hud" ][ "background" ][ "web_scrollbar" ].y += ( self GetCursor() / position );
    }

    self.menu[ "hud" ][ "background" ][ "web_scrollbar" ] SetShader( self.menu[ "hud" ][ "background" ][ "web_scrollbar" ].shader, self.menu[ "hud" ][ "background" ][ "web_scrollbar" ].width, Int( adjustment ) );
}

UpdateScaleResize()
{
    option_limit = Min( self.structure.size, self.menu[ "option_limit" ] );
    height       = Int( ( self.menu[ "option_spacing" ] * option_limit ) );
    if( IsDefined( self.menu[ "hud" ][ "foreground" ][ "description" ] ) )
        self.menu[ "hud" ][ "foreground" ][ "description" ].y = ( self.menu[ "y_offset" ] + ( height + 18 ) );

    self.menu[ "hud" ][ "background" ][ "border" ] SetShader( self.menu[ "hud" ][ "background" ][ "border" ].shader, self.menu[ "hud" ][ "background" ][ "border" ].width, IsDefined( self GetDescription() ) && IsTrue( self.menu[ "description" ] ) ? ( height + 34 ) : ( height + 18 ) );
    self.menu[ "hud" ][ "background" ][ "primary" ] SetShader( self.menu[ "hud" ][ "background" ][ "primary" ].shader, self.menu[ "hud" ][ "background" ][ "primary" ].width, IsDefined( self GetDescription() ) && IsTrue( self.menu[ "description" ] ) ? ( height + 32 ) : ( height + 16 ) );
    self.menu[ "hud" ][ "background" ][ "secondary" ] SetShader( self.menu[ "hud" ][ "background" ][ "secondary" ].shader, self.menu[ "hud" ][ "background" ][ "secondary" ].width, height );
}