///////////////////////////////////////////////////////////////////////////////////
// Main wdl file
////////////////////////////////////////////////////////////////////////////
// The PATH keyword gives directories where game files can be found,
// relative to the level directory
Path "..\\template";	// Path to WDL templates subdirectory

////////////////////////////////////////////////////////////////////////////
// The INCLUDE keyword can be used to include further WDL files,
// like those in the TEMPLATE subdirectory, with prefabricated actions
include <movement.wdl>;
include <messages.wdl>;
include <particle.wdl>; // remove when you need no particles
include <doors.wdl>;
include <actors.wdl>;   // remove when you need no actors
include <weapons.wdl>;  // remove when you need no weapons
include <war.wdl>;      // remove when you need no fighting
include <menu.wdl>;

////////////////////////////////////////////////////////////////////////////
// variable redefinitions
var video_mode = 6;	 // screen size 640x480
var video_depth = 16; // 16 bit colour D3D mode
var warn_level = 2;

/////////////////////////////////////////////////////////////////
// define a splash screen with the required A4/A5 logo
bmap splashmap = <logolite.pcx>; // the default logo in templates
panel splashscreen { bmap = splashmap; flags = refresh,d3d; }

/////////////////////////////////////////////////////////////////
// The main() function is started at game start
string warlock_mdl = <warlock.mdl>;
string terrain_wmb = <terrain.wmb>;
//bmap mountains = <mount16.pcx>;
bmap mountains = <mountain.tga>;

//function move_me();

function main()
{
// center the splash screen for non-640x480 resolutions
	splashscreen.pos_x = (screen_size.x - bmap_width(splashmap))/2;
	splashscreen.pos_y = (screen_size.y - bmap_height(splashmap))/2;
// set it visible
	splashscreen.visible = on;
// wait 3 frames (triple buffering) until it is rendered and flipped to the foreground
	wait(3);

// now load the level
	level_load(terrain_wmb);
// wait the required second, then switch the splashscreen off.
	sleep(1);
  	splashscreen.visible = off;

// load some global variables, like sound volume
	load_status();

// set some global values for the test level, like the walking
// animation width
	movement_scale = 0.5;
	anim_walk_dist = 2; // for the new guards
	anim_run_dist = 3;
	walk_or_run = 12;
	camera_dist.Z = -65;
	slopefac = 0.5;	// prevent shaking in ravines
	sky_clip = -15;
// call further functions here...
}

sky mountain_scene {
	type = <mountain.tga>;
//	type = <mount16.pcx>;
	scale_x = 0.333;	// 120 degrees
	tilt = -2;
	flags = overlay,scene,visible;
}

// function to test the dynamic light on terrain
function glowred()
{
	while (key_6 != 0) {
		player.lightrange = 200;
		player.lightred = 200;
		temp = time;
		wait(1);
	}
	player.LIGHTRANGE = 0;
}

on_6 = glowred;

entity* tsyn;

action terrain
{
	tsyn = my;
}

/////////////////////////////////////////////////////////////////
// The following definitions are for the pro edition window composer
// to define the start and exit window of the application.
WINDOW WINSTART
{
	TITLE			"Terrain Demo";
	SIZE			480,320;
	MODE			IMAGE;	//STANDARD;
	BG_COLOR		RGB(240,240,240);
	FRAME			FTYP1,0,0,480,320;
//	BUTTON		BUTTON_START,SYS_DEFAULT,"Start",400,288,72,24;
	BUTTON		BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
	TEXT_STDOUT	"Arial",RGB(0,0,0),10,10,460,280;
}

/* no exit window at all..
WINDOW WINEND
{
	TITLE			"Finished";
	SIZE			540,320;
	MODE	 		STANDARD;
	BG_COLOR		RGB(0,0,0);
	TEXT_STDOUT	"",RGB(255,40,40),10,20,520,270;

	SET FONT		"",RGB(0,255,255);
	TEXT			"Any key to exit",10,270;
}*/

/////////////////////////////////////////////////////////////////
//INCLUDE <debug.wdl>;

print "finished";