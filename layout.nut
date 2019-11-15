////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////   

class UserConfig {
</ label="--------  Main theme layout  --------", help="Show or hide additional images", order=1 /> uct1="select below";
   </ label="Select wheel style", help="Select wheel style", options="straight,curved", order=4 /> enable_list_type="curved";
   </ label="Select spinwheel art", help="The artwork to spin", options="wheel", order=5 /> orbit_art="wheel";
   </ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=6 /> transition_ms="25";  
   </ label="Wheel fade time", help="Time in milliseconds to fade the wheel.", options="Off,2500,5000,7500,10000", order=7 /> wheel_fade_ms="5000";
   </ label="Enable wheel pointer", help="Select wheel pointer", options="DisplayName,None", order=10 /> enable_pointer="DisplayName";
</ label=" ", help=" ", options=" ", order=8 /> divider1="";
</ label="--------    Extra images     --------", help="Show or hide additional images", order=9 /> uct2="select below";
   </ label="Enable box art", help="Select box art", options="Yes,No", order=10 /> enable_gboxart="Yes";
   </ label="Enable cartridge art", help="Select cartridge art", options="Yes,No", order=11 /> enable_gcartart="Yes";
   </ label="Game media style", help="Select game media style", options="Animated,Static", order=12 /> enable_mediastyle="Static"   
</ label=" ", help=" ", options=" ", order=12 /> divider2="";
</ label="--------    Game info box    --------", help="Show or hide game info box", order=13 /> uct5="select below";
   </ label="Enable game information", help="Show game information", options="Yes,No", order=14 /> enable_ginfo="Yes";
   </ label="Enable text frame", help="Show text frame", options="Yes,No", order=15 /> enable_frame="Yes"; 
</ label=" ", help=" ", options=" ", order=16 /> divider5="";
</ label="--------    Miscellaneous    --------", help="Miscellaneous options", order=17 /> uct6="select below";
   </ label="Enable random text colors", help=" Select random text colors.", options="Yes,No", order=18 /> enable_colors="Yes";
   </ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=19 /> enable_static="No"; 
   </ label="Random Wheel Sounds", help="Play random sounds when navigating games wheel", options="Yes,No", order=25 /> enable_random_sound="Yes";
}

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
//fe.layout.font="Roboto";

//for fading of the wheel
first_tick <- 0;
stop_fading <- true;
wheel_fade_ms <- 0;
try {	wheel_fade_ms = my_config["wheel_fade_ms"].tointeger(); } catch ( e ) { }

// modules
fe.load_module("fade");
fe.load_module( "animate" );


//////////////////////////////////////////////////////////////////////////////////
// Load the background layer using the DisplayName for matching 
local b_art = fe.add_image("backgrounds/[DisplayName]", 0, 0, flw, flh );
b_art.alpha=255;

local w_art = fe.add_image("wheels/[DisplayName]", 0, 0, flw, flh );
w_art.alpha=255;

//////////////////////////////////////////////////////////////////////////////////
// Video Preview or static video if none available
// remember to make both sections the same dimensions and size
if ( my_config["enable_static"] == "Yes" )
{
//adjust the values below for the static preview video snap
   const SNAPBG_ALPHA = 200;
   local snapbg=null;
   snapbg = fe.add_image( "static.mp4", flx*0.0775, fly*0.29, flw*0.405, flh*0.55 );
   snapbg.trigger = Transition.EndNavigation;
   snapbg.skew_y = 0;
   snapbg.skew_x = 0;
   snapbg.pinch_y = 0;
   snapbg.pinch_x = 0;
   snapbg.rotation = 0;
   snapbg.set_rgb( 155, 155, 155 );
   snapbg.alpha = SNAPBG_ALPHA;
}
 else
 {
 local temp = fe.add_image( "static.png", flx*0.0775, fly*0.29, flw*0.405, flh*0.55 );
 }

//create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = true;

//now position and pinch surface of snap
//adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.0775, fly*0.29, flw*0.405, flh*0.55);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;

//////////////////////////////////////////////////////////////////////////////////
// Load the cabinet layer using the DisplayName for matching 
local c_art = fe.add_image("cabinets/[DisplayName]", 0, 0, flw, flh );
c_art.alpha=255;

//////////////////////////////////////////////////////////////////////////////////
// The following section sets up what type and wheel and displays the users choice

// The following sets up which pointer to show on the wheel
//property animation - wheel pointers
if ( my_config["enable_pointer"] == "DisplayName") 
{
local point = fe.add_image("pointers/[DisplayName]", flx*0.95, fly*0.4, flw*0.05, flh*0.2);

local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 110,
    end = 255,
    time = 300
}
animation.add( PropertyAnimation( point, alpha_cfg ) );

local movey_cfg = {
    when = Transition.ToNewSelection,
    property = "y",
    start = point.y,
    end = point.y,
    time = 200
}
animation.add( PropertyAnimation( point, movey_cfg ) );

local movex_cfg = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*0.83,
    end = point.x,
    time = 200	
}	
animation.add( PropertyAnimation( point, movex_cfg ) );
}

if ( my_config["enable_pointer"] == "none") 
{
 local point = fe.add_image( "", 0, 0, 0, 0 );
}

//vertical wheel straight
if ( my_config["enable_list_type"] == "straight" )
{
fe.load_module( "conveyor" );

local wheel_x = [ flx*0.84, flx* 0.84, flx* 0.84, flx* 0.84, flx* 0.84, flx* 0.84, flx* 0.8, flx* 0.84, flx* 0.84, flx* 0.84, flx* 0.84, flx* 0.84, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.430, fly*0.580, fly*0.700 fly*0.795, fly*0.910, fly*0.99, ];
local wheel_w = [ flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.18, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, ];
local wheel_a = [  255,  255,  255,  255,  255,  255, 255,  255,  255,  255,  255,  255, ];
local wheel_h = [  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102, flh*0.150,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102, ];
local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 8;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
                preserve_aspect_ratio = true;
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
	}
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

conveyor <- Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 50;
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}

//vertical wheel curved
if ( my_config["enable_list_type"] == "curved" )
{
fe.load_module( "conveyor" );

local wheel_x = [ flx*0.94, flx* 0.94, flx* 0.85, flx* 0.83, flx* 0.81, flx* 0.79, flx* 0.77, flx* 0.79, flx* 0.81, flx* 0.83, flx* 0.85, flx* 0.94, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.430, fly*0.580, fly*0.700 fly*0.795, fly*0.910, fly*0.99, ];
local wheel_w = [ flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.18, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, ];
local wheel_a = [  255,  255,  255,  255,  255,  255, 255,  255,  255,  255,  255,  255, ];
local wheel_h = [  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102, flh*0.150,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102,  flh*0.102, ];
local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 8;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
                preserve_aspect_ratio = true;
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
	}
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

conveyor <- Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 50;
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}

// Play random sound when transitioning to next / previous game on wheel
function sound_transitions(ttype, var, ttime) 
{
	if (my_config["enable_random_sound"] == "Yes")
	{
		local random_num = floor(((rand() % 1000 ) / 1000.0) * (124 - (1 - 1)) + 1);
		local sound_name = "sounds/GS"+random_num+".mp3";
		switch(ttype) 
		{
		case Transition.EndNavigation:		
			local Wheelclick = fe.add_sound(sound_name);
			Wheelclick.playing=true;
			break;
		}
		return false;
	}
}
fe.add_transition_callback("sound_transitions")

//////////////////////////////////////////////////////////////////////////////////
// Game information to show inside text box frame
if ( my_config["enable_ginfo"] == "Yes" )
{

//add frame to make text standout 
if ( my_config["enable_frame"] == "Yes" )
{
local frame = fe.add_image( "frame.png", 0, fly*0.94, flw, flh*0.06 );
frame.alpha = 255;
}

//Year text info
local texty = fe.add_text("[Year]", flx*0.18, fly*0.937, flw*0.13, flh*0.055 );
texty.set_rgb( 255, 255, 255 );
//texty.style = Style.Bold;
//texty.align = Align.Left;

//Title text info
local textt = fe.add_text( "[Title]", flx*0.315, fly*0.942, flw*0.6, flh*0.025  );
textt.set_rgb( 225, 255, 255 );
//textt.style = Style.Bold;
textt.align = Align.Left;
textt.rotation = 0;
textt.word_wrap = false;

//Emulator text info
local textemu = fe.add_text( "[Emulator]", flx* 0.315, fly*0.967, flw*0.6, flh*0.025  );
textemu.set_rgb( 225, 255, 255 );
//textemu.style = Style.Bold;
textemu.align = Align.Left;
textemu.rotation = 0;
textemu.word_wrap = false;

//display filter info
local filter = fe.add_text( "[ListFilterName]: [ListEntry]-[ListSize]  [PlayedCount]", flx*0.7, fly*0.962, flw*0.3, flh*0.02 );
filter.set_rgb( 255, 255, 255 );
//filter.style = Style.Italic;
filter.align = Align.Right;
filter.rotation = 0;

//category icons 
local glogo1 = fe.add_image("glogos/unknown1.png", flx*0.155, fly*0.945, flw*0.045, flh*0.05);
glogo1.trigger = Transition.EndNavigation;

class GenreImage1
{
    mode = 2;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "action": [ "action","gun", "climbing" ],
        "adventure": [ "adventure" ],
        "arcade": [ "arcade" ],
        "casino": [ "casino" ],
        "computer": [ "computer" ],
        "console": [ "console" ],
        "collection": [ "collection" ],
        "fighter": [ "fighting", "fighter", "beat-'em-up" ],
        "handheld": [ "handheld" ],
		"jukebox": [ "jukebox" ],
        "platformer": [ "platformer", "platform" ],
        "mahjong": [ "mahjong" ],
        "maze": [ "maze" ],
        "paddle": [ "breakout", "paddle" ],
        "puzzle": [ "puzzle" ],
	"pinball": [ "pinball" ],
	"quiz": [ "quiz" ],
	"racing": [ "racing", "driving","motorcycle" ],
        "rpg": [ "rpg", "role playing", "role-playing" ],
	"rhythm": [ "rhythm" ],
        "shooter": [ "shooter", "shmup", "shoot-'em-up" ],
	"simulation": [ "simulation" ],
        "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer", "tennis", "hockey" ],
        "strategy": [ "strategy"],
        "utility": [ "utility" ]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "glogos/" + matches[0] + "1.png";
                        break;
                    case 1:
                        ref.file_name = "glogos/" + matches[matches.len() - 1] + "1.png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "glogos/" + matches[random_num] + "1.png";
                        break;
                }
            } else
            {
                ref.file_name = "glogos/unknown1.png";
            }
        }
    }
}
GenreImage1(glogo1);


// random number for the RGB levels
if ( my_config["enable_colors"] == "Yes" )
{
function brightrand() {
 return 255-(rand()/255);
}

local red = brightrand();
local green = brightrand();
local blue = brightrand();

// Color Transitions
fe.add_transition_callback( "color_transitions" );
function color_transitions( ttype, var, ttime ) {
 switch ( ttype )
 {
  case Transition.StartLayout:
  case Transition.ToNewSelection:
  red = brightrand();
  green = brightrand();
  blue = brightrand();
  //listbox.set_rgb(red,green,blue);
  texty.set_rgb (red,green,blue);
  textt.set_rgb (red,green,blue);
  textemu.set_rgb (red,green,blue);
  break;
 }
 return false;
 }
}}

//////////////////////////////////////////////////////////////////////////////////
// Box art/Cart art to display, uses the emulator.cfg path for image location

// Static media style
if ( my_config["enable_gboxart"] == "Yes" && my_config["enable_mediastyle"] == "Static" )
{
local boxartstatic = fe.add_artwork("boxart", flx*0.5, fly*0.4, flw*0.25, flh*0.45 );
boxartstatic.preserve_aspect_ratio = true;
}

if ( my_config["enable_gcartart"] == "Yes" && my_config["enable_mediastyle"] == "Static" )
{
local cartartstatic = fe.add_artwork("cartart", flx*0.625, fly*0.675, flw*0.2, flh*0.2 );
cartartstatic.preserve_aspect_ratio = true;
}

// Animated media style
if ( my_config["enable_gboxart"] == "Yes" && my_config["enable_mediastyle"] == "Animated" )
::OBJECTS <- {
 boxart = fe.add_artwork("boxart", flx*0.5, fly*-2, flw*0.25, flh*0.45 ),
}



if ( my_config["enable_gboxart"] == "Yes" && my_config["enable_mediastyle"] == "Animated" )
{
//Animation for Global & Expert Mode
local move_transition1 = {
  when = Transition.EndNavigation ,property = "y", start = fly*-2, end = fly*0.4, time = 750, tween = Tween.Back
}
OBJECTS.boxart.preserve_aspect_ratio = true;
OBJECTS.boxart.trigger = Transition.EndNavigation;
//Animation
animation.add( PropertyAnimation( OBJECTS.boxart, move_transition1 ) );
}

if ( my_config["enable_gcartart"] == "Yes" && my_config["enable_mediastyle"] == "Animated" )
::OBJECTS <- {
 cartart = fe.add_artwork("cartart", flx*2, fly*0.675, flw*0.2, flh*0.2 ),
}



if ( my_config["enable_gcartart"] == "Yes" && my_config["enable_mediastyle"] == "Animated" )
{
//Animation for Global & Expert Mode
local move_transition1 = {
  when = Transition.EndNavigation ,property = "x", start = flx*2, end = flx*0.625, time = 750, tween = Tween.Back
}
OBJECTS.cartart.preserve_aspect_ratio = true;
OBJECTS.cartart.trigger = Transition.EndNavigation;
//Animation
animation.add( PropertyAnimation( OBJECTS.cartart, move_transition1 ) );
}

