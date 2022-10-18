///////////////////////////////////////////////////////////////////////////////////
// A4 chopper level
//
// Please note:
// - needs the next A4 update to run (I used it for testing the new java syntax)
// - thanks to Marty Bee who donated the chopper model
// - despite it's a chopper, the flying behaviour is that of a plane
// - start the engine and control the throttle by [Home], [End]
// - control rudder and elevator by cursor keys / joystick
// - try to fly through the arcs (don't try this with a real plane)
// - script is quick and dirty, real flight sim needs 10 times the code.
//
////////////////////////////////////////////////////////////////////////////
// The PATH keyword gives directories where game files can be found,
// relative to the level directory
PATH	"..\\template";	// Path to WDL templates subdirectory

////////////////////////////////////////////////////////////////////////////
// The INCLUDE keyword can be used to include further WDL files,
// like those in the TEMPLATE subdirectory, with prefabricated actions
INCLUDE <movement.wdl>;
INCLUDE <messages.wdl>;
INCLUDE <particle.wdl>;
INCLUDE <doors.wdl>;
INCLUDE <actors.wdl>;
INCLUDE <weapons.wdl>;
INCLUDE <war.wdl>;
INCLUDE <menu.wdl>;

////////////////////////////////////////////////////////////////////////////
// The engine starts in the resolution given by the follwing skills.
IFDEF LORES;
var video_mode = 4;		// 320x240
IFELSE;
var video_mode = 6;		// 640x480
ENDIF;
var video_depth = 16;	// D3D, 16 bit resolution
var fps_max = 40;			// 40 fps max
var floor_range = 200;	// prevent sudden brightness changes on aircraft
/////////////////////////////////////////////////////////////////
// The MAIN action is called at game start

bmap mountains = <mount16.pcx>;

function main()
{
	scene_map = mountains;
	scene_field = 180;
	scene_angle.tilt = -4;

	LOAD_LEVEL <flylevel.WMB>;
	load_status();	// restore global skills
}

DEFINE _MODE_PLANE,16;
DEFINE _MODE_CHOPPER,17;	// not yet implemented
DEFINE _RPM,skill31;			// motor speed

var stallspeed = 8;	// plane stalls below this speed
var climbrate = 1.5;		// maximum climb rate
var climbfactor = 0.1;	// wing profile
var height_max = 750;	// maximum height
var speed_max = 25;		// max airspeed
var person_3rd	= 0.5;   // start in 3rd person mode

var enghandle = 0;
SOUND engsound = <jet.wav>;	// engine sound

string anim_fly_str = "fly";

action beeptest { beep; }
ON_APO = beeptest;

var dist[3];
var absdist[3];

var camera_dist[3] = 350,20,-150;


ACTION player_aircraft
{
	if (MY.client == 0) { player = MY; } // created on the server?

	MY._TYPE = _TYPE_PLAYER;
	MY.enable_scan = on;	// so that enemies can detect me

	if (MY._FORCE == 0) {  MY._FORCE = 1.5; }
	if (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_PLANE; }
	drop_shadow(); // needs _movemode to be set

// while we are in a valid movemode
	while (MY._MOVEMODE == _MODE_PLANE
		|| MY._MOVEMODE == _MODE_CHOPPER
		|| MY._MOVEMODE == _MODE_DRIVING)
	{

// Get the angular and translation forces
		_player_force();
// find ground below
		scan_floor();

// accelerate motor with [HOME], [END]
// MY._RPM = rpm / 1000
		MY._RPM += 0.05*force.z*0.1*TIME;
// limit _RPM between 0 and 7000 rpm max
		MY._RPM = max(0,min(7,MY._RPM));

// start, stop or tune the engine sound
		if (MY == player)
		{
			if (MY._RPM > 0)
			{
				if (enghandle == 0) {
					PLAY_LOOP engsound,25;
					enghandle = RESULT;
				}
// tune the sound depending on speed_ahead
				temp = (MY._RPM + MY._SPEED_X * 0.2) * 60;
				TUNE_SOUND enghandle,25,temp;
			}
			else {
				if (enghandle != 0) {
					STOP_SOUND enghandle;
					enghandle = 0;
				}
			}
		}

// calculate lift force, dependent on speed, tilt and roll angle
		force.z = climbfactor*MY._SPEED_X*0.05*(90+ang(MY.tilt)-0.5*abs(ang(MY.roll)));
		if (MY._SPEED_X < stallspeed) { force.z = 0; } 	// stall
		force.z -= gravity;
// limit the lift force
		force.z = min(force.z,climbrate);

// if on the ground, drive around
		IF (my_height < 5)
		{
			MY._MOVEMODE = _MODE_DRIVING;
// the ahead force depends on the motor speed (always positive through max)
			force.X = max(0,0.5*(MY._RPM - 1));
// steer with both stick and pedals [<] [>]
			if (aforce.pan == 0) {
				aforce.pan = force.Y;
			}
// If the roll angle was not zero,
// apply a roll force to set the angle back
			aforce.roll = -0.2*ang(MY.roll);

// Now accelerate the angular speed, and set the angles
			friction = min(1,TIME*ang_fric);
			MY._ASPEED_PAN += TIME*0.3*aforce.pan - friction*MY._ASPEED_PAN;
			MY._ASPEED_ROLL += TIME*aforce.roll - friction*MY._ASPEED_ROLL;
			MY.pan += TIME * MY._ASPEED_PAN * MY._SPEED_X * 0.025;
			MY.roll += TIME * MY._ASPEED_ROLL;
			MY.tilt = 0;

			friction = min(1,TIME*gnd_fric*0.3);
// accelerate the entity relative speed by the force
			MY._SPEED_X += TIME*force.X - friction*MY._SPEED_X;
			dist.X = TIME * MY._SPEED_X;
			dist.Y = 0;
			dist.Z = 0;

			MY._SPEED_Z += TIME*force.z - friction*MY._SPEED_Z;
			absdist.X = 0;
			absdist.Y = 0;
			absdist.Z = TIME * MY._SPEED_Z;

// Add the speed given by the ground elasticity
			absdist.Z = max(0,absdist.Z) - min(0,max(my_height,-10));

// If the actor is standing on a moving platform, add it's horizontal speed
			absdist.X += my_floorspeed.X;
			absdist.Y += my_floorspeed.Y;
		}
		ELSE // airborne
		{
			MY._MOVEMODE = _MODE_PLANE;

// tilting is done by the up/down keys, and swings back after releasing
			aforce.tilt = -0.1*force.X - 0.01*ang(MY.tilt);
// rolling is done by the left/right keys, and swings back after releasing
			aforce.roll = -0.1*aforce.pan - 0.02*ang(MY.roll);
// the pan force depends on the rudder padals and the roll angle
			aforce.pan = 0.01*force.Y - 0.03*ang(MY.roll);
// the ahead force depends on the motor speed and the tilt and roll angle
			force.X = 0.5*MY._RPM - 0.01*ang(MY.tilt) - 0.005*abs(ang(MY.roll));

// Now accelerate the angular speed, and change the angles
			friction = min(1,TIME*ang_fric);
			MY._ASPEED_PAN += TIME*aforce.pan - friction*MY._ASPEED_PAN;
			MY._ASPEED_TILT += TIME*aforce.tilt - friction*MY._ASPEED_TILT;
			MY._ASPEED_ROLL += TIME*aforce.roll - friction*MY._ASPEED_ROLL;

			MY.pan += TIME * MY._ASPEED_PAN;
			MY.roll += TIME * MY._ASPEED_ROLL;
			MY.tilt += TIME * MY._ASPEED_TILT;

// prevent climbing out of the world
			force.Z -= max(0, 0.01*(my_height - height_max));
// prevent overspeed
			force.X -= max(0, 0.1*(MY._SPEED_X - speed_max));

			friction = min(1,TIME*gnd_fric*0.2);
// accelerate the entity relative speed by the force
			MY._SPEED_X += TIME*force.X - friction*MY._SPEED_X;
			dist.X = TIME * MY._SPEED_X;
			dist.Y = 0;
			dist.Z = 0;	// lift force controls absolute speed only

// Add the lift and gravity force
			MY._SPEED_Z += TIME*force.z - friction*MY._SPEED_Z;
			absdist.X = 0;
			absdist.Y = 0;
			absdist.Z = TIME * MY._SPEED_Z;
		}

// Now move ME by the relative and the absolute speed
		YOU = NULL;	// YOU entity is considered passable by MOVE
		MOVE ME,dist,absdist;

		aircraft_anim();

// If I'm the only player, draw the camera and weapon with ME
		if (client_moving == 0) { move_view(); }

// Wait one tick, then repeat
		wait(1);
		compass_move();	//$$$
	}
}

// play the prop anim
function aircraft_anim()
{
 	MY._ANIMDIST += MY._RPM * TIME;
// wrap animation TIME to a value between zero and 100 percent
	if (MY._ANIMDIST > 100) { MY._ANIMDIST -= 100; }
// set the frame from the percentage
	SET_CYCLE MY,anim_fly_str,MY._ANIMDIST;

//$$$	ent_vertex(temp,248);
//$$$	EMIT 1,temp,particle_x;
}

action particle_x {
	MY_SIZE = 500;
	IF (MY_AGE > 16) { MY_ACTION = NULL; }
}

// this replaces the move_view_3rd from the movement.wdl
function move_view_3rd()
{
	if (_camera == 0 && player != NULL)
	{
		CAMERA.genius = player;
		CAMERA.pan += 0.2 * ang(player.pan-CAMERA.pan);
		if (player._MOVEMODE == _MODE_PLANE
			|| player._MOVEMODE == _MODE_CHOPPER)
		{
			CAMERA.tilt += 0.2 * ang(player.tilt-CAMERA.tilt);
		} else {  // walking, swimming etc.
			CAMERA.tilt = head_angle.tilt-5;
		}

		vec_set(temp,temp_cdist);
		VECROTATE temp,player.PAN;
      CAMERA.X += 0.3*(player.X - temp.X - CAMERA.X);
      CAMERA.Y += 0.3*(player.Y - temp.Y - CAMERA.Y);
      CAMERA.Z += 0.3*(player.Z - temp.Z - CAMERA.Z);

// test if camera is IN_PASSABLE or IN_SOLID
		temp = ent_content(NULL,CAMERA.x);
		if (temp == CONTENT_SOLID) { 			// if camera moved into a wall,
			temp_cdist.X *= 0.9;	// place it closer to the player
			temp_cdist.Y *= 0.9;
			temp_cdist.Z *= 0.9;
		} else {
			temp_cdist.X += 0.2*(player.MAX_X + camera_dist.X - temp_cdist.X);
			temp_cdist.Y += 0.2*(player.MAX_Y + camera_dist.Y - temp_cdist.Y);
			temp_cdist.Z += 0.2*(player.MAX_Z + camera_dist.Z - temp_cdist.Z);
		}
// if the camera is IN_PASSABLE assume it is underwater
		if (temp == CONTENT_PASSABLE) {
		 	FOG_COLOR = _FOG_UNDERWATER;  // set fog color to underwater
		} else {
// else restore the current_fog_color
			FOG_COLOR = current_fog_index;
		}
		person_3rd = 1;
	}

}

var compass_pos[2] = 0,0;

function compass_move()
{
	while(1) {
		compass_pos.X = 120 - (CAMERA.PAN % 360)*0.333;
		wait(1);
	}
}


bmap compass_map = <compass.pcx>;	// 160 x 20;

panel aircraft_panel
{
	pos_X	 =	4;
	pos_y	 =	4;
	digits =	0,0,4,digit_font,1000,player._RPM;
	digits =	60,0,4,digit_font,1,player._SPEED_X;
	digits =	120,0,4,digit_font,1,my_height;
	window = 200,0,40,20,compass_map,compass_pos.x,compass_pos.y;

	flags = REFRESH,VISIBLE;
}

/////////////////////////////////////////////////////////////////
//INCLUDE <debug.wdl>;