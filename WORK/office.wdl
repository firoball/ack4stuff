///////////////////////////////////////////////////////////////////////////////////
// Gamestudio test level
///////////////////////////////////////////////////////////////////////////////////
path "..\\template";	// Path to templates subdirectory

include <movement.wdl>;	// libraries of WDL functions
include <messages.wdl>;
include <menu.wdl>;		// menu must be included BEFORE doors and weapons
include <particle.wdl>; // remove when you need no particles
include <doors.wdl>;		// remove when you need no doors
include <actors.wdl>;   // remove when you need no actors
include <weapons.wdl>;  // remove when you need no weapons
include <war.wdl>;      // remove when you need no fighting
ifdef CAPS_FLARE;
include <lflare.wdl>;   // remove when you need no lens flares
endif;
//include <venture.wdl>;

///////////////////////////////////////////////////////////////////////////////////
// define all file names in angular brackets
string office_wmb = <office.wmb>;
string fish_mdl = <fish.mdl>;
string shield_mdl = <shield.mdl>;
string mace_mdl = <mace.mdl>;
string warlock_mdl = <warlock.mdl>;
string staff_mdl = <staff.mdl>;
string blitz_pcx = <blitz.pcx>;

///////////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the variable
// VIDEO_MODE. It is possible to switch the resolution during
// gameplay using the SWITCH_VIDEO instruction.

var video_mode = 6; 		// 640x480;
var video_depth = 16;	// D3D mode
var d3d_texmemmin = 2000;	// fall back to 8 bit mode when less than 2000 KB is free
//var d3d_mipmapping = 1; // old method
//var d3d_texreserved = 0; // use external memory manager

/////////////////////////////////////////////////////////////////
// define a splash screen with the required A4/A5 logo
bmap splashmap = <logodark.pcx>; // the default A5 logo in templates
panel splashscreen { bmap = splashmap; flags = refresh,d3d; }

////////////////////////////////////////////////////////////////////////////
// function prototypes
function player_client();
function init_environment();

////////////////////////////////////////////////////////////////////////////
// After engine start, the MAIN function is executed, so the 2-D engine
// can display pictures, logos, or AVI animations. To load
// a level, perform a LEVEL_LOAD instruction.

function main()
{
// set some global values for the test level, like the walking
// animation adaption
	anim_walk_dist = 2; // for the new guards
	anim_run_dist = 3;
	walk_or_run = 8;
	camera_dist.z = -50;

	fps_max = 80;
	warn_level = 2;	// announce bad texture sizes and bad wdl code
	tex_share = on;	// map entities share their textures

// center the splash screen for non-640x480 resolutions
	splashscreen.pos_x = (screen_size.x - bmap_width(splashmap))/2;
	splashscreen.pos_y = (screen_size.y - bmap_height(splashmap))/2;
// set it visible
	splashscreen.visible = on;
// wait 3(!) frames for triple buffering, until it is flipped to the foreground
	wait(3);

// now load the level
	level_load(office_wmb);
// wait the required second, then switch the splashscreen off.
	sleep(1);

  	splashscreen.visible = off;
	bmap_purge(splashmap);	// remove logo bitmap from video memory

// load some global variables, like sound volume or changed strings
	load_status();
// initalize the sky and background
	init_environment();

// initialize lens flares in D3D mode (only if edition supports flares)
ifdef CAPS_FLARE;
	if (video_depth > 8) { lensflare_start(); }
endif;

// comment this in if you really want to play a midi file
//	start_song();

// create the player entity on the client
ifdef CLIENT;
	client_move();	// enable multiuser mode

// wait until the level is loaded, and the connection is established
	while (connection == 0) { wait(1); }

// create a client entity at a random place
	temp.X = 300 + 2*sys_seconds;
	temp.Y = -400;
	temp.Z = 50;
	player = ent_create(warlock_mdl,temp,player_client);
// the guard is created, and its action is running on the server.
// Therefore we have to initialize him on the client separately -
// the following flags are required for the camera
	player._MOVEMODE = _MODE_WALKING;
	player.__BOB = ON;
endif;
// display the server's IP address
ifdef SERVER;
	while (connection == 0) { wait(1); }
	str_cpy(temp_str,server_name);
	str_cat(temp_str," ");
	str_cat(temp_str,server_IP);
	scroll_message(temp_str);
endif;
}


MUSIC testsong = <ribanna.mid>;

// play a song if volume was set at beginning
function start_song()
{
	wait(4);	// wait until LOAD_INFO has loaded the last volume setting
	if (midi_vol > 0) {
		play_song_once(testsong,25);
	}
}

////////////////////////////////////////////////////////////////////////

function zoom_in() {
	camera.arc = max(camera.arc-5,10);
}

function zoom_out() {
	camera.arc = min(camera.arc+5,120);
}

VIEW mirror { };

// Code to simulate a floor mirror by generating
// a vertically flipped camera view from below through the floor
action mirror_vertical
{
// initialize camera portal for realtime reflections
ifdef CAPS_MIRROR;
	camera.portal = mirror;
//	camera.alpha = 25;
	mirror.noshadow = on;	// suppress shadows in the mirror
	mirror.portalclip = on;	// clip at portal plane
	while (1) {
		proc_late();	// place it at the end of the function list - the camera must be moved before
		mirror.genius = camera.genius;
		mirror.aspect = -camera.aspect;	// flip the image upside down
		mirror.arc = camera.arc;
		mirror.fog = camera.fog;
		mirror.fog_start = camera.fog_start;
		mirror.fog_end = camera.fog_end;
		mirror.x = camera.x;
		mirror.y = camera.y;
		mirror.z = 2*camera.portal_z-camera.z;	// move the camera at its mirror position
		mirror.pan = camera.pan;
		mirror.tilt = -camera.tilt;	// flip the vertical camera angle
		mirror.roll = -camera.roll;
		wait(1);
	}
endif;
	return;
}

////////////////////////////////////////////////////////////////////////////
// Everything that moves is an ENTITY. Entities may be placed
// into the level, or may be created at runtime. There will be
// 3 types of entities supported:
//
// - Model Entities (MDL files) for animated actors or objects
// - Sprite Entities (PCX files) for animated actors, objects, or explosions
// - Block Entities (WMB files) for doors, platforms, buildings and the like
//
// Each entity has two functions: The main AI action, which initializes it and controls
// its behaviour, and a separate EVENT function, which is triggered on
// certain events, like being hit or being touched.

entity* guard;	// define a pointer, thus the guard can be accessed from outside


action patrol_prog
{
	guard = me;
// first, set the entity properties
	my.fat = off;
	my.narrow = on;
	my._walkframes = 1;
	my._movemode = _mode_walking;
	my._force = 1.5;

// then, call all standard tasks the entity shall perform
	patrol_path();
	if (my.shadow == off) { drop_shadow(); }

// add an event: touching it with the mouse
	my.string1 = "walking\nguard";
	my.enable_touch = on;
	my.event = handle_touch;

//	my.enable_click = on;
//	my.event = _save;

// attach other entities - AFTER setting the patrol movement action
	ent_create(shield_mdl,nullvector,attach_entity);
	ent_create(mace_mdl,nullvector,attach_entity);

// a non-standard entity function - like disappering
// on pressing the [R] key - may be directly scripted here, like this:
	while (1) {
		if (KEY_R) { remove(ME); }
		WAIT 1;
	}
}

// place a bright flare at the vertex number given by my.x
function attach_flare(name,vertex)
{
	you = my;	// store the parent entity
	my = ent_create(name,nullvector,null);
	my.passable = on;
	my.flare = on;
	my.unlit = on;
	my.bright = on;
	my.facing = on;
   while (you)	// prevent empty pointer error if parent entity was removed
   {
		my.invisible = (you.invisible == on);
   	vec_for_vertex(my.x,you,vertex);
   	wait(1);
   }
	remove(my);
}

action staff_prog
{
	attach_entity();
// create a flare sprite at top of the staff
	attach_flare(blitz_pcx,26);
}

function player_client()
{
	my.fat = off;
	my.narrow = on;		// set narrow hull
	my._force = 0.5;		// he should be not too fast
	my._movemode = _mode_walking;
	my._banking = -0.1;
	my.__jump = on;
	my.__duck = on;
	my.__strafe = on;
	my.__bob = on;
	my.__trigger = on;
	my._health = 100;
 	my._runthreshold = 7;

	my.enable_disconnect = on;
	my.event = _actor_connect;

 	player_anim_pack();
 	player_move2();		// new move function with animation blending
	if (my.shadow == off) { drop_shadow(); }

	ent_create(staff_mdl,nullvector,staff_prog);
}

//resource "warlock.wrs";	// a possible resource
//include "warlock.wdl";

action player_prog
{
ifdef client;
	remove(me);	// each client generates his own player
ifelse;
	player_client();
endif;
//	warlocktest();
	return;
}

entity* water_wmb;

action waterblock {
	water_wmb = my;
}



// Use the ent_create instruction to create an entity at a given
// position, running a given action:

var drop_dist = 0;
var max_lights = 3;

function fly_ahead();

function emit_fish()
{
// wait until the previous fish is far enough
	while (drop_dist != 0) { wait(1); }
	drop_dist = 60;
	p = drop_dist;
	set_pos_ahead();
// place an entity 60 quants ahead of player position
	ent_create(fish_mdl,my_pos,fly_ahead);
	waitt(8);
	drop_dist = 0;
}

// This is the entity's action. An entity can change its type,
// (so a model can become a sprite), can be attached to another
// entity, and can perform some move or AI instructions.

var tumblespeed[3] = 5,0,0;

SOUND bumm = <bumm.wav>;

// sets the vector to a random direction and length (max. range)
function vec_randomize(&vec,range)
{
	vec[0] = random(1) - 0.5;
	vec[1] = random(1) - 0.5;
	vec[2] = random(1) - 0.5;
	vec_normalize(vec,random(range));
}

// fades out a particle
function part_alphafade()
{
	my.alpha -= time+time;
	if (my.alpha <= 0) { my.lifespan = 0; }
}


function effect_explo()
{
	vec_randomize(temp,10);
	vec_add(my.vel_x,temp);

	my.lifespan = 100;
	my.gravity = 1;
	my.bmap = scatter_map;
	my.flare = on;
	my.bright = on;
	my.streak = on;
//	my.beam = on;
	my.move = on;
	my.lifespan = 48;
//	my.function = NULL;
	my.function = part_alphafade;
}

function event_ricochet()
{
	ent_playsound(my,bumm,100);
// bounce off the wall
	vec_to_angle(my.pan,bounce);
// emit particles into normal direction
	vec_scale(normal,5);
	effect(effect_explo,1000,my.x,normal);
}

sound whosh = <noise.wav>;

function fly_ahead()
{
	my.pan = camera.pan;	// let it fly in view direction, like a bullet
	my.roll = camera.roll;
	my.tilt = camera.tilt;
	my.event = event_ricochet;
	my.enable_block = on;
	my.enable_entity = on;

	if	((video_depth >= 16) || (max_lights > 0)) {
		my.red = 50;
		my.green = 50;
		my.blue = 200;
		my.lightrange = 200;
		max_lights -= 1;
	}

	var whosh_handle;
	whosh_handle = ent_playloop(my,whosh,100);

	while (1) {
		move_mode = ignore_you;
		ent_move(tumblespeed,nullvector);
// tune the entity sound
ifndef SERVER;	// snd_tune does not work on the server because sounds play on the client
//		snd_tune(whosh_handle,(10*total_ticks) % 100,0,0);
endif;
// use the modulo function to cycle colors from 0..255
		my.red = (4*total_ticks) % 256;
		my.green = (3*total_ticks) % 256;
		my.blue = total_ticks % 256;

		wait(1);
	}
}

/////////////////////////////////////////////////////////////////////////
// The following definitions control the sky

sky sky_purple {
	type = <sky_purple.pcx>;
	speed_u = 1;
	speed_v = 1.5;
	scale_x = 0.5;
	flags = dome,visible;
	layer = 1;
}

sky cloud_purple {
	type = <cloud_purple.pcx>;
	speed_u = 3;
	speed_v = 4.5;
	flags = dome,overlay,visible;
	layer = 2;
}

sky mountain {
// A backdrop texture's horizontal size must be a power of 2;
// the vertical size does not matter
	type = <zionlow.pcx>;
	scale_x = 0.25;	// gives a field of 90 degrees per texture
	tilt = -10;
	flags = scene,overlay,visible;
	layer = 3;
}
/*
sky spaceball {
	type = <stars.mdl>;
//	scale_x = 0.1;
//	scale_y = 0.1;
//	scale_z = 0.1;
	flags = scene,visible;
	layer=10;
//	x = 2000;
//	z = 2000;
}
*/
function init_environment()
{
	camera.fog = 70;	// rather thick fog in the fog room
	sun_angle.tilt = 20;
}

/////////////////////////////////////////////////////////////////
// The following definitions are for the WDFC window composer
// (available only with the professional edition)
// to define the start and exit window of the application.
WINDOW WINSTART
{
	TITLE			"Office";
	SIZE			480,320;
	MODE			IMAGE;		// STANDARD;
	BG_COLOR		RGB(0,0,0);	// black
	FRAME			FTYP1,0,0,480,320;
//	BUTTON		BUTTON_START,SYS_DEFAULT,"Start",400,288,72,24;
	BUTTON		BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
	TEXT_STDOUT	"Arial",RGB(255,0,0),10,10,460,280;
}

// no exit window at all..
/*WINDOW WINEND
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
include <debug.wdl>;

on_3 = zoom_in;
on_4 = zoom_out;
on_6 = snowfall;
on_7 = emit_fish;