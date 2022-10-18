///////////////////////////////////////////////////////////////////////////////////
// WDL prefabs for entity movement
//
// Modified (6/5/00)
// Added code to handle new animation
// Player can now stand, walk, run, duck, jump, crawl, swim, and wade
//
// Modified (6/8/00)
// Converted code to 4.187 format (removed SETs and CALLs)
//
// Modified (6/19/00)
// Added __FALL (FLAG1) and _FALLTIME (SKILL31)
// If __FALL is ON, player takes damage from falls
// _FALLTIME contains the amount of time spent falling (calculated in move_gravity)
///////////////////////////////////////////////////////////////////////////////////
// Some definitions
// Change them by re-defining them in your main wdl script
// BEFORE the include, and adding DEFINE MOVE_DEFS;
IFNDEF MOVE_DEFS;
 SOUND  thud,<tap.wav>;
 SOUND  robo_thud,<gate.wav>;
 SOUND  splash,<splash.wav>;
 DEFINE shadowsprite,<shadow.pcx>;
 DEFINE shadowflat,<shadflat.pcx>;
 DEFINE DEFAULT_WALK,13.040;
 DEFINE DEFAULT_RUN,5.060;
ENDIF;

///////////////////////////////////////////////////////////////////////////////////
// Some global skill definitions
// Duplicate them in your wdl script AFTER the include
// to give them new values
VAR gnd_fric = 0.5;		// ground friction
VAR air_fric = 0.03; 	// air friction
VAR water_fric = 0.75;	// water friction
VAR ang_fric = 0.6;		// angular friction
VAR gravity = 6; 			// gravity force
VAR elasticity = 0.1; 	// of the floor
SKILL strength  { X 5; Y 4; Z 25; }	// default ahead, side, jump strength
SKILL astrength { PAN 7; TILT 5; ROLL 2; }	// default pan, tilt, roll strength

VAR eye_height_up = 0.8;	// eye position factor for walking, driving
VAR eye_height_down = 0.7;	// for swimming
VAR eye_height_duck = 0.3;	// for ducking

VAR walk_rate = 3; 	// for head wave, 360 / step width
VAR wave_rate = 25; 	// same for swimming, 360 / wave time
VAR walk_ampl = 4;	// walking head wave amplitude
VAR wave_ampl = 2; 	// swimming head wave amplitude

VAR anim_attack_ticks = 16;// time for one attack animation cycle

VAR anim_stand_ticks = 16;	// time for one standing anim cycle
VAR anim_jump_ticks = 6; 	// time for one jump animation cycle
VAR anim_duck_ticks = 8; 	// time for one duck animation cycle

VAR anim_walk_dist = 1; 	// dist per model width per walk cycle
VAR anim_run_dist = 1.5;	// dist per model width per run cycle
VAR anim_crawl_dist = 0.8; // dist per model width per crawl cycle
VAR anim_wade_dist = 0.8;	// dist per model width per crawl cycle
VAR anim_swim_dist = 1; 	// dist per model width per swim cycle

VAR person_3rd	= 0;		// 0: 1st person mode; 0.5: 3rd person mode
VAR camera_dist = 90;   // camera distance to entity in 3rd person view
VAR mouseview = 1;  		// mouse factor, set 0 to disable mouse
VAR client_moving = 0; 	// multiplayer mode

VAR jump_height = 100; 	// maximum jump height above ground
VAR walk_or_run = 12; 	// max quants per tick to switch from walk to run animation

VAR power_max = 1; 		// maximum engine power for aircraft



// strings for defining the animation frames
STRING anim_stand_str,"stand";
STRING anim_walk_str,"walk";
STRING anim_run_str,"run";
STRING anim_duck_str,"duck";
STRING anim_swim_str,"swim";
STRING anim_dive_str,"dive";
STRING anim_jump_str,"jump";
STRING anim_crawl_str,"crawl";
STRING anim_wade_str,"wade";

// string synonyms for defining the animation frames (and their default values)
STRING anim_default_death_str,"death";
STRING anim_default_attack_str,"attack";
SYNONYM anim_attack_str { TYPE STRING; DEFAULT anim_default_attack_str;}
SYNONYM anim_death_str { TYPE STRING; DEFAULT anim_default_death_str;}

///////////////////////////////////////////////////////////////////////
// Entity skill & flag definitions
// some definitions here are also needed for ACTORS.WDL and WAR.WDL
DEFINE _WALKFRAMES,SKILL1;	// non-zero for old style animation
DEFINE _RUNFRAMES,SKILL2;
DEFINE _ATTACKFRAMES,SKILL3;
DEFINE _DIEFRAMES,SKILL4;

DEFINE _FORCE,SKILL5;		// determines speed
DEFINE _ENTFORCE,SKILL5;
DEFINE _BANKING,SKILL6;		// banking - for player only
DEFINE _PENDOLINO,SKILL6;	// banking - for player only
DEFINE _HITMODE,SKILL6;		// for actors
DEFINE _MOVEMODE,SKILL7;
DEFINE _FIREMODE,SKILL8;	// for actors



DEFINE __FALL,FLAG1;		// take damage from falls

DEFINE __WHEELS,FLAG2;	// block turns without moving
DEFINE __SLOPES,FLAG3;	// adapt the tilt and roll angle to slopes
DEFINE __JUMP,FLAG4;		// be able to jump
DEFINE __BOB,FLAG5;   	// head wave
DEFINE __STRAFE,FLAG6;	// be able to move sidewards
DEFINE __TRIGGER,FLAG7;	// be able to trigger doors automatically

DEFINE __SOUND,FLAG8;	// internal flag

///////////////////////////////////////////////////////////////////////
DEFINE _HEALTH,SKILL9;
DEFINE _ARMOR,SKILL10;

DEFINE _SPEED,SKILL11;		// speed
DEFINE _SPEED_X,SKILL11;
DEFINE _SPEED_Y,SKILL12;
DEFINE _POWER,SKILL12;		// engine power for aircraft models
DEFINE _SPEED_Z,SKILL13;
DEFINE _ASPEED,SKILL14;		// angular speed
DEFINE _ASPEED_PAN,SKILL14;
DEFINE _ASPEED_TILT,SKILL15;
DEFINE _ASPEED_ROLL,SKILL16;

// for actor entities, and for doors and platforms
DEFINE _TARGET_X,SKILL17;
DEFINE _TARGET_Y,SKILL18;
DEFINE _TARGET_Z,SKILL19;
DEFINE _TARGET_PAN,SKILL20;
DEFINE _TARGET_TILT,SKILL21;
DEFINE _TARGET_ROLL,SKILL22;

// for player entities
DEFINE _FORCE_X,SKILL17;
DEFINE _FORCE_Y,SKILL18;
DEFINE _FORCE_Z,SKILL19;
DEFINE _AFORCE_PAN,SKILL20;
DEFINE _AFORCE_TILT,SKILL21;
DEFINE _AFORCE_ROLL,SKILL22;

DEFINE _WALKSOUND,SKILL23;	// walking sound
DEFINE _SIGNAL,SKILL24;		// communication for actions or client->server
DEFINE _COUNTER,SKILL25;	// internal counter
DEFINE _STATE,SKILL26;		// the state it is in (walk, attack, escape etc.)

DEFINE _WALKDIST,SKILL27;	// distance per walk cycle
DEFINE _RUNDIST,SKILL28;	// distance per run cycle
DEFINE _ANIMDIST,SKILL28;	// time for standing, jumping, and ducking animations
DEFINE _TYPE,SKILL30;		// the type of the entity - door, key, etc.

DEFINE _FALLTIME,SKILL31;	// amount of time spent falling

// Skills up to 32 are reserved for future template actions
// Skills 33-40 can be used freely

///////////////////////////////////////////////////////////////////////
VAR force[3];		// cartesian force, entity coordinates
VAR absforce[3];	// cartesian force, world coordinates
VAR aforce[3];		// angular force
VAR speed[3] = 0, 0, 0;		// cartesian speed, entity coordinates
VAR abspeed[3] = 0, 0, 0;	// cartesian speed, world coordinates
VAR aspeed[3];		// angular speed
VAR p;
VAR friction;
VAR limit[3];
VAR covered_dist;
VAR anim_dist;

SKILL head_angle	{ PAN 0; TILT 0; ROLL 0; }	// separated from other values
VAR headwave = 0;
VAR walkwave = 0;
VAR my_dist;			// distance for actor anim
VAR player_dist;		// distance for head bobbing
VAR scan_sector;
VAR my_height;
VAR my_floornormal[3];
VAR my_floorspeed[3];
VAR temp_cdist = 120;   // current camera distance in 3rd p view
//-VAR debugskill;

VAR	current_fog_index	= 0;	// the current fog color index

SYNONYM player { TYPE ENTITY; }
SYNONYM temp_ent { TYPE ENTITY; }
SYNONYM carry { TYPE ACTION; }
SYNONYM anim_str { TYPE STRING; }

DEFINE _MODE_WALKING,1;
DEFINE _MODE_DRIVING,2;
DEFINE _MODE_SWIMMING,3;
DEFINE _MODE_DIVING,4;
DEFINE _MODE_WADING,5;
DEFINE _MODE_HELICOPTER,6;	// very primitive helicopter mode
DEFINE _MODE_ROCKETEER,7;
DEFINE _MODE_DUCKING,8;		// ducking
DEFINE _MODE_JUMPING,9;		// jumping
DEFINE _MODE_CRAWLING,10;	// crawling
DEFINE _MODE_STILL,15;
// modes above 10 are handled by a different wdl
DEFINE _MODE_ATTACK,20;

DEFINE _SOUND_WALKER,1;
DEFINE _SOUND_ROBOT,2;

DEFINE _TYPE_PLAYER,1;
DEFINE _TYPE_ACTOR,2;
DEFINE _TYPE_FOE,3;
DEFINE _TYPE_DOOR,10;
DEFINE _TYPE_GATE,11;
DEFINE _TYPE_ELEVATOR,12;
DEFINE _TYPE_GUN,20;
DEFINE _TYPE_AMMO,21;
DEFINE _TYPE_ARMOR,22;
DEFINE _TYPE_HEALTH,23;

DEFINE _FOG_UNDERWATER,2;	// fog color 2 is used for underwater fog

///////////////////////////////////////////////////////////////////////
//-DEFINE RETURN,END;	// I prefer RETURN to END

SOUND beep_sound,<beep.wav>;
//SYNONYM debugsyn { TYPE ENTITY; }

///////////////////////////////////////////////////////////////////////

ACTION player_heli {
// HOME/END control the throttle
	MY._MOVEMODE = _MODE_HELICOPTER;
	MY._FORCE = 1.5;
	MY._BANKING = -0.5;
	MY.__SLOPES = ON;
	MY.__WHEELS = OFF;
	MY.__TRIGGER = OFF;
	player_fly();
}

ACTION player_drive {
	MY._MOVEMODE = _MODE_DRIVING;
	MY._FORCE = 1.5;
	MY._BANKING = 0.5;
	MY.__SLOPES = ON;
	MY.__TRIGGER = ON;
	player_move();
}

ACTION player_walk {
	MY._MOVEMODE = _MODE_WALKING;
	MY._FORCE = 0.75;
	MY._BANKING = -0.1;
	MY.__JUMP = ON;
	MY.__STRAFE = ON;
	MY.__BOB = ON;
	MY.__TRIGGER = ON;

	player_move();
}

ACTION player_swim {
	MY._MOVEMODE = _MODE_SWIMMING;
	MY._FORCE = 0.75;
	MY._BANKING = 0;
	MY.__JUMP = ON;
	MY.__STRAFE = OFF;
	MY.__BOB = ON;

	player_move();
}

///////////////////////////////////////////////////////////////////////
// Shakes the player, used for hits and death
ACTION player_shake
{
	IF (RANDOM(1) > 0.5)
	{
		MY.ROLL += 8;
		MY.TILT += 8;
		WAITT 2;
		MY.TILT -= 5;
		WAITT 2;
		MY.ROLL -= 8;
		MY.TILT -= 3;
	} ELSE {
		MY.ROLL -= 8;
		MY.TILT += 8;
		WAITT 2;
		MY.TILT -= 5;
		WAITT 2;
		MY.ROLL += 8;
		MY.TILT -= 3;
	}
}

// player tips over, can be used for death
ACTION player_tip
{
	MY._MOVEMODE = 0;	// suspend normal movement action
	eye_height_up.Z = eye_height_up;	// store original eye height
	WHILE (MY.ROLL < 80)
	{
		MY.ROLL += 8 * TIME;
		MY.TILT += 2 * TIME;
		IF (eye_height_up > 0.15) {
			eye_height_up -= 0.1 * TIME; }

		IF (client_moving==0) { move_view(); }
		WAIT 1;
	}

	MY.ROLL = 80;
	MY.TILT = 20;
	eye_height_up = eye_height_up.Z;	// restore original eye height
}



///////////////////////////////////////////////////////////////////////
// Desc: main player movement action
//			called from 'player_walk', 'player_drive', & 'player_swim'
//
// Mod Date: 5/10/00 @ 973 Doug Poston
//           Added code to handle swimming
// Mod Date: 5/11/00 @ 097 Doug Poston
//           Added code to handle ducking and crawling
// Mod Date: 5/16/00  Doug Poston
//				 Modified underwater fog code
//				 Modified player MIN_Z (when getting in & out of water)
//				 Fixed so you can no longer crawl over water
// Mod Date: 5/16/00 Doug Poston
//				 Returned fog control back to the camera views
// Mod Date: 5/18/00 Doug Poston
//				 Removed MIN_Z modifications (too easy to get stuck in objects)
// Mod Date: 5/25/00 Doug Poston
//				 Using an 'offset sonar' (7 units) while swimming to check if
//				the player is ON_PASSABLE
// Mod Date: 5/29/00 Doug Poston
//				 Change 'offset sonar' from 7 to 16 units
// Mod Date: 6/5/00 Doug Poston
//				 Removed Sets
// Mod Date: 6/27/00 Doug Poston
//				 Replaced ACCEL
// Mod Date: 6/29/00 Doug Poston
//				Remove IN_PASSABLE check for wading (fixed in v4.193)
ACTION player_move
{
IFDEF ACKNEX_VERSION414;
	IF (MY.CLIENT == 0) { player = ME; } // created on the server?
IFELSE;
	player = ME; // to be accessible by a synonym
ENDIF;

	MY._TYPE = _TYPE_PLAYER;
	MY.ENABLE_SCAN = ON;	// so that enemies can detect me
	IF ((MY.TRIGGER_RANGE == 0) && (MY.__TRIGGER == ON)) { MY.TRIGGER_RANGE = 32; }

	IF (MY._FORCE == 0) {  MY._FORCE = 1.5; }
	IF (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	IF (MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }

	anim_init();      // init old style animation
	perform_handle();	// react on pressing the handle key


	// while we are in a valid movemode
	WHILE ((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		// if we are not in 'still' mode
		IF (MY._MOVEMODE != _MODE_STILL)
		{
			// Get the angular and translation forces (set aforce & force values)
			_player_force();

			// find ground below (set my_height, my_floornormal, & my_floorspeed)
			scan_floor();

			// if they are on or in a passable block...
			IF ( ((my_height < 5) && (ON_PASSABLE != 0)) || (IN_PASSABLE != 0) )
			{
				// if not already swimming or wading...
				IF ((MY._MOVEMODE != _MODE_SWIMMING) && (MY._MOVEMODE != _MODE_WADING))
				{
  					PLAY_SOUND splash,50;
  					MY._MOVEMODE = _MODE_SWIMMING;
  				}

				// if swimming...
  				IF (MY._MOVEMODE == _MODE_SWIMMING) // swimming on/in a passable block
				{
					// use a 16 unit 'buffer' to test if we are above the water
					// (SONAR goes to next surface when the origin is within 7 units of the surface)
					MY.Z += 16;
					SONAR	MY,4000;
					MY.Z -= 16;
					IF (ON_PASSABLE == ON) // && (IN_PASSABLE != ON)) -> Not need with version 4.193+
					{
						// check for wading
						temp.X = MY.X;
    					temp.Y = MY.Y;
    		  			temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?
						SHOOT MY.POS,temp;   // NOTE: SHOOT ignores passable blocks
						IF (RESULT > 0)
						{
							// switch to wading
							MY._MOVEMODE = _MODE_WADING;
 				 			MY.TILT = 0;       // stop tilting
							my_height = RESULT + MY.MIN_Z;	// calculate wading height
						}

						// check for edge (for 'jumping' out of water)
						// +++This code can be added here+++

					}

				}// END swimming on/in a passable block

				// if wading...
 				IF (MY._MOVEMODE == _MODE_WADING) // wading on/in a passable block
				{
  					// check for swimming
					temp.X = MY.X;
    				temp.Y = MY.Y;
    				temp.Z = MY.Z + MY.MIN_Z;	// can my feet touch?

    				SHOOT MY.POS,temp;  // NOTE: ignore passable blocks
					IF (RESULT == 0)
					{
						// switch to swimming
						MY._MOVEMODE = _MODE_SWIMMING;
					}
					ELSE	// use SOLID surface for height (can't walk on water)
					{
	 					my_height = RESULT + MY.MIN_Z;    // calculate wading height
 					}
				} // END wading on/in a passable block
	 		} // END if they are on or in a passable block...
			ELSE  // not in or on a passable block
			{
				// if wading or swimming while *not* on/in a passable block...
				IF ((MY._MOVEMODE == _MODE_SWIMMING) || (MY._MOVEMODE == _MODE_WADING))
				{
					// get out of the water (go to walk mode)
					MY._MOVEMODE = _MODE_WALKING;
					MY.TILT = 0;       // stop tilting
				}
 			} // END not in or above water


  			// if he is on a slope, change his angles, and maybe let him slide down
			IF (MY.__SLOPES == ON)
			{
				// Adapt the player angle to the floor slope
				MY_ANGLE.TILT = 0;
				MY_ANGLE.ROLL = 0;
				IF ((my_height < 10) && ((my_floornormal.X != 0) || (my_floornormal.Y != 0) ))
				{	// on a slope?
					// rotate the floor normal relative to the player
					MY_ANGLE.PAN = -MY.PAN;
					VECROTATE my_floornormal,MY_ANGLE;
					// calculate the destination tilt and roll angles
					MY_ANGLE.TILT = -ASIN(my_floornormal.X);
					MY_ANGLE.ROLL = -ASIN(my_floornormal.Y);
				}
				// change the player angles towards the destination angles
				MY.TILT += 0.2 * ANG(MY_ANGLE.TILT-MY.TILT);
				MY.ROLL += 0.2 * ANG(MY_ANGLE.ROLL-MY.ROLL);
			}
			ELSE
			{
				// If the ROLL angle was not equal to zero,
				// apply a ROLL force to set the angle back
				aforce.ROLL = -0.2*ANG(MY.ROLL);
			}

			// Now accelerate the angular speed, and change his angles
			// -old method- ACCEL	MY._ASPEED,aforce,ang_fric;
			temp = min(TIME*ang_fric,1);
			MY._ASPEED_PAN  += (TIME * aforce.pan)  - (temp * MY._ASPEED_PAN);
			MY._ASPEED_TILT += (TIME * aforce.tilt) - (temp * MY._ASPEED_TILT);
			MY._ASPEED_ROLL += (TIME * aforce.roll) - (temp * MY._ASPEED_ROLL);


			temp = MY._ASPEED_PAN * MY._SPEED_X * 0.05;
			IF (MY.__WHEELS)
			{	// Turn only if moving ahead
				MY.PAN += temp;
			}
			ELSE
			{
				MY.PAN += MY._ASPEED_PAN;
			}
			MY.ROLL += temp * MY._BANKING + MY._ASPEED_ROLL;

			// the head angle is only set on the player in a single player system.
			if (ME == player)
			{
				head_angle.TILT += MY._ASPEED_TILT;
				// Limit the TILT value
				head_angle.TILT = ANG(head_angle.TILT);
				IF (head_angle.TILT > 80) { head_angle.TILT = 80; }
				IF (head_angle.TILT < -80) { head_angle.TILT = -80; }
			}

			// disable strafing
			IF (MY.__STRAFE == OFF)
			{
				force.Y = 0;	// no strafe
			}


			// if swimming...
			IF (MY._MOVEMODE == _MODE_SWIMMING)
			{
 				// move in water
  				swim_gravity();
			}
			ELSE // not swimming
			{
				// if wading...
				IF (MY._MOVEMODE == _MODE_WADING)
				{
					wade_gravity();
				}
				ELSE // not swimming or wading (not in water)
				{

					// Ducking or crawling...
					IF ((MY._MOVEMODE == _MODE_DUCKING) || (MY._MOVEMODE == _MODE_CRAWLING))
					{
						IF (force.Z >= 0)
						{
							MY._MOVEMODE = _MODE_WALKING;
						}
					}
					ELSE  // not ducking or crawling
					{
						// if we have a ducking force and are not already ducking or crawling...
						IF (force.Z < 0)
						{
							// ...switch to ducking mode
							MY._MOVEMODE = _MODE_DUCKING;
							MY._ANIMDIST = 0;
							force.Z = 0;
						}
					}

					// Decide whether the actor can jump or not. He can't if he is in the air
					IF ((jump_height <= 0)
						|| (MY.__JUMP == OFF)
						|| (my_height > 4)
						|| (force.Z <= 0))
					{
						force.Z = 0;
					}

					// move on land
					move_gravity();
				}  // END (not in water)
			}// END not swimming
		} // END not in 'still' mode

		// animate the actor
		actor_anim();

		// If I'm the only player, draw the camera and weapon with ME
		IF (client_moving == 0) { move_view(); }

		carry();		// action synonym used to carry items with the player (eg. a gun or sword)

		// Wait one tick, then repeat
		WAIT	1;
	}  // END WHILE ((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
}


// Mod Date: 6/27/00 Doug Poston
//				Replaced ACCEL
ACTION player_fly
{
	IF (MY.CLIENT == 0) { player = ME; } // created on the server?

	MY._TYPE = _TYPE_PLAYER;
	MY.ENABLE_SCAN = ON;	// so that enemies can detect me
	IF ((MY.TRIGGER_RANGE == 0) && (MY.__TRIGGER == ON)) { MY.TRIGGER_RANGE = 32; }

	IF (MY._FORCE == 0) {  MY._FORCE = 1.5; }
	IF (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_HELICOPTER; }

	WHILE ((MY._MOVEMODE > 0)&&(MY._MOVEMODE <= _MODE_STILL))
	{
		IF (MY._MOVEMODE == _MODE_STILL) {	// do nothing at all
			WAIT 1;
			CONTINUE;
		}

// Get the angular and translation forces
		_player_force();
// find ground below
		scan_floor();

// if he is on a slope, change his angles, and maybe let him slide down
		IF (MY.__SLOPES == ON) {
// Adapt the player angle to the floor slope
			MY_ANGLE.TILT = 0;
			MY_ANGLE.ROLL = 0;
			IF ((my_height < 10) && ((my_floornormal.X != 0) || (my_floornormal.Y != 0) ))
			{	// on a slope?
// rotate the floor normal relative to the player
				MY_ANGLE.PAN = -MY.PAN;
				VECROTATE my_floornormal,MY_ANGLE;
// calculate the destination tilt and roll angles
				MY_ANGLE.TILT = -ASIN(my_floornormal.X);
				MY_ANGLE.ROLL = -ASIN(my_floornormal.Y);
			}
// change the player angles towards the destination angles
			MY.TILT += 0.2 * ANG(MY_ANGLE.TILT-MY.TILT);
			MY.ROLL += 0.2 * ANG(MY_ANGLE.ROLL-MY.ROLL);
		} ELSE {
// If the ROLL angle was not equal to zero,
// apply a ROLL force to set the angle back
			aforce.ROLL = -0.2*ANG(MY.ROLL);
		}

		// Now accelerate the angular speed, and change his angles
 		// -old method- ACCEL	MY._ASPEED,aforce,ang_fric;
		temp = min(TIME*ang_fric,1);
		MY._ASPEED_PAN  += (TIME * aforce.pan)  - (temp * MY._ASPEED_PAN);
		MY._ASPEED_TILT += (TIME * aforce.tilt) - (temp * MY._ASPEED_TILT);
		MY._ASPEED_ROLL += (TIME * aforce.roll) - (temp * MY._ASPEED_ROLL);

		temp = MY._ASPEED_PAN * MY._SPEED_X * 0.05;
		IF (MY.__WHEELS) {	// Turn only if moving ahead
			MY.PAN += temp;
		} ELSE {
			MY.PAN += MY._ASPEED_PAN;
		}
		MY.ROLL += temp * MY._BANKING + MY._ASPEED_ROLL;
		head_angle.TILT += MY._ASPEED_TILT;

// now move him
		move_airborne();
		anim_airborne();

// If I'm the only player, draw the camera and weapon with ME
		IF (client_moving == 0) { move_view(); }

// Wait one tick, then repeat
		WAIT	1;
	}
}

// this is the main movement action for the camera
//
// Mod Date: 6/27/00 Doug Poston
//				Replaced ACCEL (x2)
ACTION camera_move
{
	_camera = 1;
	WHILE (_camera == 1)
	{
		_player_intentions();

 		// -old method- ACCEL	aspeed,aforce,0.9;
		aspeed.pan  += (TIME * aforce.pan)  - (0.9 * aspeed.pan);
		aspeed.tilt += (TIME * aforce.tilt) - (0.9 * aspeed.tilt);
		aspeed.roll += (TIME * aforce.roll) - (0.9 * aspeed.roll);

		CAMERA.PAN += aspeed.PAN;
		CAMERA.TILT += aspeed.TILT;
		CAMERA.ROLL += aspeed.ROLL;

 		// -old method- ACCEL	speed,force,0.9;
		speed.x += (TIME * force.x) - (0.9 * speed.x);
		speed.y += (TIME * force.y) - (0.9 * speed.y);
		speed.z += (TIME * force.z) - (0.9 * speed.z);

		MOVE_VIEW CAMERA,speed,NULLSKILL;
		WAIT	1;
	}
}

/////////////////////////////////////////////////////////////////////
// Core part of move action, common for actors and players
ACTION move_airborne
{
	MY._POWER += 0.1*force.Z;
	IF (MY._POWER < 0) { MY._POWER = 0; }
	IF (MY._POWER > power_max) { MY._POWER = power_max; }
	absforce.X = 0;
	absforce.Y = 0;
	absforce.Z = 0;

	friction = air_fric;
	force.X = 0;
	force.Y = 0;
	force.Z = 0;
}

ACTION anim_airborne
{
IFDEF ACKNEX_VERSION418;
// standing animation
	IF (MY._POWER > 0)	// engine running
	{
		MY._ANIMDIST += TIME * MY._POWER;
// wrap animation time to a value between zero and anim_stand_ticks
		IF (MY._ANIMDIST > anim_stand_ticks) {
			MY._ANIMDIST -= anim_stand_ticks;
		}
// calculate a percentage out of the animation time
		temp =  100 * MY._ANIMDIST / anim_stand_ticks;
// set the frame from the percentage
		SET_CYCLE ME,anim_stand_str,temp;
		RETURN;
	}
ENDIF;
	RETURN;
}


////////////////////////////////////////////////////////////////////////
// Desc: gravity / buoyancy effect on the player in water (IN_PASSABLE)
//       this action should be called when the player is swimming (_MODE_SWIMMING)
//
// Created: 05/9/00 @ 863 by Doug Poston
//
// Mod Date: 5/10/00 @ 913 by Doug Poston
//				Added code to TILT the player (allowing them to dive and rise in water)
// Mod Date: 5/18/00 by Doug Poston
//				Added code to drop player to the surface of the water
// Mod Data: 5/24/00 Doug Poston
//				 Using an 'offset sonar' (7 units) to check if the player is ON_PASSABLE
// Mod Date: 5/29/00 Doug Poston
//				 Change 'offset sonar' from 7 to 16 units
// Mod Date: 6/19/00 Doug Poston
//				 Reset _FALLTIME (no falling damage is you land in water)
// Mod Date: 6/27/00 Doug Poston
//				Replaced ACCEL
// Mod Date: 6/28/00 Doug Poston
//				Modified gravity check to handle ON_PASSABLE while IN_PASSABLE
// Mod Date: 6/29/00 Doug Poston
//				Remove IN_PASSABLE check while ON_PASSABLE (6/28/00 mod) (fixed in v4.193)
ACTION swim_gravity
{
	friction = water_fric;     // set friction to water friction

	MY._FALLTIME = 0;	// no falling damage in water

   // TILT the player if diving
  	IF (force.Z > 0)
	{
		MY.TILT += 3;
	}
  	IF (force.Z < 0)
	{
		MY.TILT -= 3;
	}
	MY.TILT = ANG (MY.TILT);	// make sure angle stays between -180 and +180

	// Swimming - rhythmic acceleration
	force.X *= 0.5 + 0.25*walkwave;
	force.Y *= 0.5;
	force.Z = 0;      // up and down handled by entity's tilt in water


	// accelerate the entity relative speed by the force
	// -old method- ACCEL	MY._SPEED_X,force,friction;
	temp = min(TIME*friction,1);
	MY._SPEED_X += (TIME * force.x) - (temp * MY._SPEED_X);
	MY._SPEED_Y += (TIME * force.y) - (temp * MY._SPEED_Y);
	MY._SPEED_Z += (TIME * force.z) - (temp * MY._SPEED_Z);



	absforce.X = 0;
	absforce.Y = 0;
	absforce.Z = 0;


	// use a 16 unit 'offset buffer' to test if we are still above the water
	// (SONAR)
	MY.Z += 16;
	SONAR	MY,4000;
	MY.Z -= 16;
	// on the surface (and not in another surface)...
	IF ((ON_PASSABLE == ON) && (RESULT > MY.MIN_Z)) //&&  (IN_PASSABLE ==0)) -> check not need in v4.193+
	{
		// if MY center is greater than the surface level...
		IF (((RESULT - MY.MIN_Z) > 5))//??16)))     // 5 = "float value"
		{
			// pull down to the surface of the water
			//absforce.Z -= gravity;
			//if(absforce.Z
			temp = (RESULT - MY.MIN_Z) - 5; // difference between surface
			IF (temp > gravity)  { temp = gravity; }
			absforce.Z -= temp;
		}


		// restrict driving and climbing motion on surface...
		IF (MY.TILT > 5)
		{
			MY.TILT = 5;   // shallow climb
		}
		IF (MY.TILT < -45)
		{
			MY.TILT = -45;   	// shallow dive only from surface
		}
	}

	// NOTE: this is where we would add buoyancy (using absforce)
	// right now we are assuming zero buoyancy

	// NOTE: this is where we could add the effect of currents (using absforce)

	// Now move ME by the relative and the absolute speed
	YOU = NULL;	// YOU entity is considered passable by MOVE
	MOVE ME,MY._SPEED_X,absforce;



	// Store the distance covered, for animation
	my_dist = RESULT;
	// Store the distance for player 1st person head bobbing
	// (only for single player system)
	IF (ME == player)
	{
		player_dist += MY._SPEED_X;//SQRT(speed.X*speed.X + speed.Y*speed.Y);
	}
}


// Desc: wading movement action
//       this action should be called when the player is wading (_MODE_WADING)
//
// Mod Date: 5/18/00 by Doug Poston
//				Created
// Mod Date: 5/25/00 by Doug Poston
//				Adjusted ground elasticity (so it doesn't force player to swim)
// Mod Date: 5/25/00 by Doug Poston
//				Adjust player force by water depth (slower the deeper the player is wading)
// Mod Date: 5/29/00 Doug Poston
//				 Change 'offset sonar' from 7 to 16 units
// Mod Date: 6/19/00 Doug Poston
//				 Reset _FALLTIME (no falling damage is you land in water)
// Mod Date: 6/27/00 Doug Poston
//				Replaced ACCEL (x2)
ACTION wade_gravity
{
	// basic friction
	friction = gnd_fric;

	MY._FALLTIME = 0;	// no falling damage in water

	//adjust player force depending on depth of water
	MY.Z += 16;
	SONAR	MY,4000;
	MY.Z -= 16;
	temp = 1.0 - (RESULT / MY.MIN_Z);
	IF (temp < 0.1)	// minimum speed
	{
		temp = 0.1;
	}
	force.X *= temp;
	force.Y *= temp;
	force.Z *= temp;


	// reset absforce
	absforce.X = 0;
	absforce.Y = 0;
	absforce.Z = 0;

	// If on a slope, apply gravity to draw him downwards:
	IF (my_floornormal.Z < 0.85)
	{
		// force is less in water than on land
		absforce.X = my_floornormal.X * gravity * 0.25;
		absforce.Y = my_floornormal.Y * gravity * 0.25;
		// If slope too steep, really push him back
		temp = 0.66 - my_floornormal.Z;
		IF (temp > 0)
		{
			absforce.X *= 1.5;
			absforce.Y *= 1.5;
		}
	}

	// accelerate the entity relative speed by the force
	speed.X = MY._SPEED_X;
	speed.Y = MY._SPEED_Y;

	// -old method- ACCEL	speed,force,friction;
	temp = min(TIME*friction,1);
	speed.x += (TIME * force.x) - (temp * speed.x);
	speed.y += (TIME * force.y) - (temp * speed.y);
	speed.Z = 0;	// jumping force controls absolute speed only

	MY._SPEED_X = speed.X;
	MY._SPEED_Y = speed.Y;

	// Add the world gravity force
	abspeed.X = 0;
	abspeed.Y = 0;
	abspeed.Z = MY._SPEED_Z;

	// -old method- ACCEL	abspeed,absforce,friction;
	// *** NOTE: ONLY WORKS IF 'temp', friction, and TIME remain unchanged from before!!!*** temp = min(TIME*friction,1);
	abspeed.x += (TIME * absforce.x) - (temp * abspeed.x);
	abspeed.y += (TIME * absforce.y) - (temp * abspeed.y);
	abspeed.z += (TIME * absforce.y) - (temp * abspeed.z);


	// Add the speed given by the ground elasticity
 	IF (my_height < -5)
	{
		temp = my_height;
		IF (temp < -10)  { temp = -10; }
 		abspeed.Z -= temp;
	}

	// Pull back down to the underwater surface
	// NOTE: this is taken care of by the player switching to swimming, then back to wading

	// NO JUMPING WHILE WADING
	MY._SPEED_Z = abspeed.Z;

	// Now move ME by the relative and the absolute speed
	YOU = NULL;	// YOU entity is considered passable by MOVE
	MOVE ME,speed,abspeed;

	// Store the distance covered, for animation
	my_dist = RESULT;
	// Store the distance for player 1st person head bobbing
	// (only for single player system)
	IF (ME == player) {
		player_dist += SQRT(speed.X*speed.X + speed.Y*speed.Y);
	}
}


// Desc: on ground movement action
//			use when player is not swimming or wading
//
// Mod Date: 5/10/00 @ 942 by Doug Poston
//				Added code to switch to jumping mode when needed
// Mod Date: 5/25/00 by Doug Poston
//				Split MOVE into two, so my_dist is now a function of player
//			  movement only (ie. not effected by elevators or platforms)
// Mod Date: 6/19/00 by Doug Poston
//          Added falling damage.
//				_FALLTIME keeps track of the time spent falling
//				if __FALL is set, damage is taken when landing
// Mod Date: 6/27/00 Doug Poston
//				Replace ACCEL (x2)
ACTION move_gravity
{
	// Filter the forces and frictions dependent on the state of the actor,
	// and then apply them, and move him

	// First, decide whether the actor is standing on the floor or not
	IF (my_height < 5)
	{

		// Calculate falling damage
 		IF ((MY.__FALL == ON) && (MY._FALLTIME > 5))
  		{
			// NOTE!!!+++ Just a placeholder formula, replace with fall_damage(time) function when parameters become avalible
			MY._HEALTH -= 10 + INT((MY._FALLTIME - 5) * 1.75);  // take damage depending on _FALLTIME
 		}
		MY._FALLTIME = 0; 	// reset falltime

		friction = gnd_fric;
		IF (MY._MOVEMODE == _MODE_DRIVING)
		{
			// Driving - less friction, less force
			friction *= 0.3;
			force.X *= 0.3;
		}
/* Use swim_gravity action instead
		IF (MY._MOVEMODE == _MODE_SWIMMING)
		{
			// Swimming - rhythmic acceleration
			force.X *= 0.5 + 0.25*walkwave;
			force.Y *= 0.5;
		}
*/
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = 0;

		// If on a slope, apply gravity to draw him downwards:
		IF (my_floornormal.Z < 0.85)
		{
			absforce.X = my_floornormal.X * gravity * 2;
			absforce.Y = my_floornormal.Y * gravity * 2;
			// If slope too steep, really push him back
			temp = 0.66 - my_floornormal.Z;
			IF (temp > 0)
			{
				absforce.X *= 3;
				absforce.Y *= 3;
			}
		}
	}
	ELSE	// (my_height >= 5)
	{
		// airborne - set all relative forces to 0
		// to prevent him from jumping or further moving in the air
		friction = air_fric;
		force.X = 0;
		force.Y = 0;
		force.Z = 0;
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = -gravity;

		// only falling if moving downward
		IF (MY._SPEED_Z <= 0)
		{
			MY._FALLTIME += TIME;   // add falling time
		}
	}

	// accelerate the entity relative speed by the force
	speed.X = MY._SPEED_X;
	speed.Y = MY._SPEED_Y;

	// -old method- ACCEL	speed,force,friction;
	temp = min(TIME*friction,1);
	speed.x += (TIME * force.x) - (temp * speed.x);
	speed.y += (TIME * force.y) - (temp * speed.y);
	speed.z += (TIME * force.z) - (temp * speed.z);


	speed.Z = 0;	// jumping force controls absolute speed only
	MY._SPEED_X = speed.X;
	MY._SPEED_Y = speed.Y;

	// Add the world gravity force
	abspeed.X = 0;
	abspeed.Y = 0;
	abspeed.Z = MY._SPEED_Z;

	// -old method- ACCEL	abspeed,absforce,friction;
	// *** NOTE: only works if temp, TIME, and friction are unchanged!!! *** temp = min(TIME*friction,1);
	abspeed.x += (TIME * absforce.x) - (temp * abspeed.x);
	abspeed.y += (TIME * absforce.y) - (temp * abspeed.y);
	abspeed.z += (TIME * absforce.z) - (temp * abspeed.z);

	// Add the speed given by the ground elasticity and the jumping force
	IF (my_height < 5)
	{
		temp = my_height;
		IF (temp < -10)  { temp = -10; }
		abspeed.Z = force.Z-temp;

		// if we have a jumping force...
		IF (force.Z > 0)
		{
			// ...switch to jumping mode
			MY._MOVEMODE = _MODE_JUMPING;
			MY._ANIMDIST = 0;
		}
	}

	// Restrict the speed to the maximum jumping height
	IF ((MY.__JUMP == ON) && (abspeed.Z > 0) && (abspeed.Z + my_height > jump_height))
	{
		abspeed.Z = jump_height - my_height;
		if (abspeed.Z < 0) { abspeed.Z = 0; }
	}

	// If the actor is standing on a moving platform, add it's horizontal speed
	IF (my_height < 5)
	{
		abspeed.X += my_floorspeed.X;
		abspeed.Y += my_floorspeed.Y;
	}

	MY._SPEED_Z = abspeed.Z;

	// Now move ME by the relative and the absolute speed
	YOU = NULL;	// YOU entity is considered passable by MOVE

	// NOTE: split move into two sections, so that movement from platforms does not effect move distance
	//      (this is for animation reasons. ie. so model does not 'walk' on elevators)
//	MOVE ME,speed,abspeed;
	MOVE ME,speed,NULLSKILL;
	// Store the distance covered, for animation
	my_dist = RESULT;
	MOVE ME,NULLSKILL,abspeed;

	// Store the distance for player 1st person head bobbing
	// (only for single player system)
	IF (ME == player)
	{
		player_dist += SQRT(speed.X*speed.X + speed.Y*speed.Y);
	}
}

// old style animation: split the integer and fractional parts
// of the animation frame numbers, and store distance factors
ACTION anim_init
{
	temp = FRC(MY._WALKFRAMES) * 1000;
	IF (temp != 0) { // old style animation
		MY._WALKFRAMES = INT(MY._WALKFRAMES);
		IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = 13; }
		MY._WALKDIST = MY._WALKFRAMES / temp;

		temp = FRC(MY._RUNFRAMES) * 1000;
		MY._RUNFRAMES = INT(MY._RUNFRAMES);
		IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = 5; }
		MY._RUNDIST = MY._RUNFRAMES / temp;
	}
}

// Desc: play some kinds of foot sound
//
// Mod Date: 6/9/00 Doug Poston
//				changed to function
FUNCTION _play_walksound()
{
	IF ((ME == player) && (person_3rd == 0)) { RETURN; }	// don't play entity sounds for 1st person player
	IF (MY._WALKSOUND == _SOUND_WALKER) { PLAY_ENTSOUND ME,thud,60; }
	IF (MY._WALKSOUND == _SOUND_ROBOT) { PLAY_ENTSOUND ME,robo_thud,60; }
}

////////////////////////////////////////////////////////////////////
// Main action to animate a walking actor, depending on dist covered (my_dist)
//
// Mod Date: 5/9/00 @ 812 Doug Poston
//				Added swimming animation
// Mod Date: 5/10/00 @ 970 Doug Poston
//				Added jumping animation
// Mod Date: 5/11/00 @ 795 by Doug Poston
//				Added ducking and crawling animations
// Mod Date: 5/23/00 Doug Poston
// 			Added code to check for backwards motion (using force.X)
// Mod Date: 6/23/00 Doug Poston
// 			Added code for attack animations
// Mod Date: 6/27/00 Doug Poston
//				Modified attack animation code to only work for player animation
ACTION actor_anim
{
IFDEF ACKNEX_VERSION418;
	// decide whether it's a frame number (old) or frame name (new) animation
	IF (FRC(MY._WALKFRAMES) > 0) { goto old_style_anim; }

	// START NEW STYLE ANIMATIONS (frame names)

	// Check to see if player is attacking
	IF (( ME == PLAYER) && (MY._FIREMODE != 0))
	{
		// if you have more than one attacking animation, here's where you would test for it...

		// calculate a percentage out of the animation time
		temp =  100 * MY._ANIMDIST / anim_attack_ticks;
		// set the frame from the percentage
		SET_FRAME ME,anim_attack_str,temp;
		// increment _ANIMDIST by elapsed time
		MY._ANIMDIST += TIME;
		// check to see if we finished jump animation
		IF (MY._ANIMDIST > anim_attack_ticks)
		{
			MY._ANIMDIST = 0; // reset animation distance
			MY._FIREMODE = 0;	// reset firemode
		}
 		RETURN;
	}
	ELSE // not firing
	{
		/////////////////////////////////////////////////////////////////////
		// Animations that can take place standing still (jumping, ducking, etc.)
		/////////////////////////////////////////////////////////////////////
   	// the jumping animation
		IF (MY._MOVEMODE == _MODE_JUMPING)
		{
			// calculate a percentage out of the animation time
			temp =  100 * MY._ANIMDIST / anim_jump_ticks;
			// set the frame from the percentage
			SET_FRAME ME,anim_jump_str,temp;
			// increment _ANIMDIST by elapsed time
			MY._ANIMDIST += TIME;
			// check to see if we finished jump animation
			IF (MY._ANIMDIST > anim_jump_ticks)
			{
				MY._ANIMDIST = 0;
				MY._MOVEMODE = _MODE_WALKING;
			}
 			RETURN;
		}

   	// the ducking animation
		IF (MY._MOVEMODE == _MODE_DUCKING)
		{
   		// you can only duck at walking speeds or below.
			IF (my_dist >= walk_or_run*TIME)	// to fast to duck?
			{
				MY._MOVEMODE = _MODE_WALKING; // catch the walking mode below this one
 			}
			ELSE
			{ // ducking
				// calculate a percentage out of the animation time
				temp =  100 * MY._ANIMDIST / anim_duck_ticks;
				// set the frame from the percentage
				SET_FRAME ME,anim_duck_str,temp;
				// increment _ANIMDIST by elapsed time
				MY._ANIMDIST += TIME;
				// check to see if we finished ducking
				IF (MY._ANIMDIST > anim_duck_ticks)
				{
					MY._ANIMDIST = 0;
					MY._MOVEMODE = _MODE_CRAWLING;
				}
 				RETURN;
			}
		}

		// the crawling animation
		IF (MY._MOVEMODE == _MODE_CRAWLING)
		{

			// you can only crawl at walking speeds or below.
			IF (my_dist >= walk_or_run*TIME)	// to fast to crawl?
			{
				MY._MOVEMODE = _MODE_WALKING; // catch the walking mode below this one
 			}
			ELSE
			{ // crawling
 				// set the distance covered, in percent of the model width
				covered_dist = MY._WALKDIST + my_dist / (MY.MAX_X-MY.MIN_X);
 				// calculate the real cycle distance from the model size
				WHILE (covered_dist > anim_crawl_dist)
				{
					covered_dist -= anim_crawl_dist;
				}

				IF (force.X < 0)	// moving backwards?
				{
					temp = 100 - temp;
				}
				temp = 100 * covered_dist / anim_crawl_dist;
				SET_CYCLE ME,anim_crawl_str,temp;
				MY._WALKDIST = covered_dist;     // save for next 'frame' of animation
				RETURN;
			}

		}

		// the swimming animation
		IF (MY._MOVEMODE == _MODE_SWIMMING)
		{
 			// set the distance covered, in percent of the model width
			covered_dist = MY._WALKDIST + my_dist / (MY.MAX_X-MY.MIN_X);
 			// calculate the real cycle distance from the model size
			WHILE (covered_dist > anim_swim_dist)
			{
				covered_dist -= anim_swim_dist;
			}

			IF (force.X < 0)	// moving backwards?
			{
				temp = 100 - temp;
			}
			temp = 100 * covered_dist / anim_swim_dist;
			SET_CYCLE ME,anim_swim_str,temp;
			MY._WALKDIST = covered_dist;     // save for next 'frame' of animation
			RETURN;
		}


		// the wading animation
		IF (MY._MOVEMODE == _MODE_WADING)
		{
 			// set the distance covered, in percent of the model width
			covered_dist = MY._WALKDIST + my_dist / (MY.MAX_X-MY.MIN_X);
 			// calculate the real cycle distance from the model size
			WHILE (covered_dist > anim_wade_dist)
			{
				covered_dist -= anim_wade_dist;
			}

			IF (force.X < 0)	// moving backwards?
			{
				temp = 100 - temp;
			}

			temp = 100 * covered_dist / anim_wade_dist;
			SET_CYCLE ME,anim_wade_str,temp;
			MY._WALKDIST = covered_dist;     // save for next 'frame' of animation
			RETURN;
		}

		// the standing still animation
		// NOTE: the must be *before* _MODE_WALKING but after any other mode
		//      that can animate while the player is not moving (swimming,
		//		  ducking, jumping, etc.)
		IF ((my_dist < 0.01) || (MY._MOVEMODE == _MODE_STILL))
		{
 			MY._ANIMDIST += TIME;
			// wrap animation time to a value between zero and anim_stand_ticks
			IF (MY._ANIMDIST > anim_stand_ticks)
			{
				MY._ANIMDIST -= anim_stand_ticks;
			}
			// calculate a percentage out of the animation time
			temp =  100 * MY._ANIMDIST / anim_stand_ticks;
			// set the frame from the percentage
			SET_CYCLE ME,anim_stand_str,temp;
 			RETURN;
 		}


		// walking animation
		IF (MY._MOVEMODE == _MODE_WALKING)
		{
			// set the distance covered, in percent of the model width
			covered_dist = MY._WALKDIST + my_dist / (MY.MAX_X-MY.MIN_X);

			// decide whether to play the walk or run animation
			IF (my_dist < walk_or_run*TIME)	// Walking
			{
				anim_dist = anim_walk_dist;
				anim_str = anim_walk_str;
			}
			ELSE
			{ // running
				anim_dist = anim_run_dist;
				anim_str = anim_run_str;
			}

			// calculate the real cycle distance from the model size
			IF (covered_dist > anim_dist)
			{
				covered_dist -= anim_dist;
			}


			temp = 100 * covered_dist / anim_dist;
			IF (force.X < 0)	// moving backwards?
			{
				temp = 100 - temp;
			}

			SET_CYCLE ME,anim_str,temp;

			if (covered_dist < MY._WALKDIST)
			{
				_play_walksound();	// sound for right foot
			}
			if ((covered_dist > anim_dist*0.5) && (MY._WALKDIST < anim_dist*0.5))
			{
				_play_walksound();	// sound for left foot
			}
			MY._WALKDIST = covered_dist;
			RETURN;
		}
		RETURN;
		// END OF NEW STYLE ANIMATIONS (frame names)
	}


ENDIF;

	IF ((MY._MOVEMODE == _MODE_STILL) || (my_dist < 0.01))
	{
// if the entity has a standing animation, instead of just one frame,
// place it here. Otherwise...
		MY.FRAME = 1;	// standing
		RETURN;
	}


old_style_anim:
	IF (MY._MOVEMODE == _MODE_WALKING)
	{
// decide whether to play the walk or run animation
		IF ((MY._RUNFRAMES <= 0) || (my_dist < walk_or_run*TIME))	// Walking
		{
			IF (MY.FRAME < 2) { MY.FRAME = 2; }

			MY.FRAME += MY._WALKDIST*my_dist;

// this is one of the expert exceptions where you can use WHILE without WAIT!
			WHILE (MY.FRAME >= 2 + MY._WALKFRAMES) {
// sound for right foot
				IF (MY.__SOUND == ON) { _play_walksound(); MY.__SOUND = OFF; }
// cycle the animation
				MY.FRAME -= MY._WALKFRAMES;
			}

			IF (MY.FRAME > 1 + MY._WALKFRAMES*0.5) {
// sound for left foot
				IF (MY.__SOUND == OFF) { _play_walksound(); MY.__SOUND = ON; }
			}

			IF (MY.FRAME > 1 + MY._WALKFRAMES) {
				MY.NEXT_FRAME = 2;	// inbetween to the first walking frame
			} ELSE {
				MY.NEXT_FRAME = 0;	// inbetween to the real next frame
			}
			RETURN;
		}
		ELSE {	// Running
			IF (MY.FRAME < 2 + MY._WALKFRAMES) { MY.FRAME = 2 + MY._WALKFRAMES; }

			MY.FRAME += MY._RUNDIST*my_dist;

			WHILE (MY.FRAME >= 2 + MY._WALKFRAMES + MY._RUNFRAMES) {
				IF (MY.__SOUND == ON) { _play_walksound(); MY.__SOUND = OFF; }
				MY.FRAME -= MY._RUNFRAMES;
			}

			IF (MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES*0.5) {
				IF (MY.__SOUND == OFF) { _play_walksound(); MY.__SOUND = ON; }
			}

			IF (MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES) {
				MY.NEXT_FRAME = 2 + MY._WALKFRAMES;
			} ELSE {
				MY.NEXT_FRAME = 0;
			}

			RETURN;
		}
	}
}

///////////////////////////////////////////////////////////////////////
// First person camera view
// This should be a client-only action!!
//
// Mod Date: 5/10/00 @ 954 Doug Poston
//           Added code to create 'under water' fog
// Mod Date: 5/15/00 @ 947 Doug Poston
//				 Added eye_height adjustment for ducking and crawling
// Mod Date: 5/22/00 Doug Poston
//				 Added TOUCH for underwater fog
// Mod Date: 6/5/00 Doug Poston
//				 Replaced TOUCH with ent_content() function
// Mod Date: 6/26/00 Doug Poston
//				 Modifed IF to accept Swimming at any height
ACTION move_view_1st
{
	IF (_camera == 0) {		// If the camera does not move itself
		IF (my_height < 5 || (player._MOVEMODE == _MODE_SWIMMING) )
		{
			// use
			headwave = SIN(player_dist*walk_rate);

			IF ((player._MOVEMODE == 0)	// moving on client?
				|| (player._MOVEMODE == _MODE_WALKING))
			{
				// Play the right and left foot sound
				IF (((headwave > 0) && (walkwave <= 0))
					|| ((headwave <= 0) && (walkwave > 0)))
				{
					PLAY_SOUND thud,30;
				}
				// head bobbing
				walkwave = headwave;
				headwave = walk_ampl*(ABS(headwave)-0.5);
			}
			IF (player._MOVEMODE == _MODE_SWIMMING)
			{
				IF ((headwave > 0) && (walkwave <= 0))
				{
					PLAY_SOUND splash,30;
				}
				// in-water wave movement
				walkwave = headwave;
				headwave = wave_ampl*SIN(TOTAL_TICKS*wave_rate);
				head_angle.TILT += 0.1*wave_ampl*SIN(TOTAL_TICKS*wave_rate - 60);
			}
		}

		CAMERA.DIAMETER = 0;		// make the camera passable
		CAMERA.GENIUS = player;	// don't display parts of ME
		CAMERA.X = player.X;
		CAMERA.Y = player.Y;
		CAMERA.Z = player.Z + player.MIN_Z;
		IF (player.__BOB == ON) { CAMERA.Z += headwave;	}

		IF (player._MOVEMODE == _MODE_SWIMMING)
		{
			// adjust eye height for swimming
			CAMERA.Z += (player.MAX_Z-player.MIN_Z)*eye_height_down;
		}
		ELSE
		{
			IF ((player._MOVEMODE == _MODE_DUCKING) || (player._MOVEMODE == _MODE_CRAWLING))
			{
				// adjust eye height for ducking and crawling
				CAMERA.Z += (player.MAX_Z-player.MIN_Z)*eye_height_duck;
			}
			ELSE
			{
				// adjust eye height for 'normal' modes
				CAMERA.Z += (player.MAX_Z-player.MIN_Z)*eye_height_up;
			}
		}

		CAMERA.PAN = player.PAN;
		CAMERA.TILT = player.TILT + head_angle.TILT;
		CAMERA.ROLL = player.ROLL;

		// check to see if camera is located in a passable block
		IF (ent_content(NULL, CAMERA.POS) == 2)
		{
		 	FOG_COLOR = _FOG_UNDERWATER;	// set fog color to underwater fog
		}
		ELSE
		{
			// else restore current_fog_index
			FOG_COLOR = current_fog_index;
		}

		person_3rd = 0;
	}
}

// Third person camera view
//
// Mod Data: 5/10/00 @ 948 Doug Poston
//           Added code to create 'under water' fog
// Mod Date: 5/22/00 Doug Poston
//				 Added TOUCH for underwater fog
// Mod Date: 6/5/00 Doug Poston
//				 Replaced TOUCH with ent_content() function
ACTION move_view_3rd
{
	IF (_camera == 0)
	{		// If the camera does not move itself
		CAMERA.DIAMETER = 0;		// make the camera passable
		CAMERA.GENIUS = player;
		CAMERA.PAN += 0.2 * ANG(player.PAN-CAMERA.PAN);
		CAMERA.TILT = head_angle.TILT-5;
      MY_SPEED.X = 0.3*(player.X - temp_cdist * COS(player.PAN) - CAMERA.X);
      MY_SPEED.Y = 0.3*(player.Y - temp_cdist * SIN(player.PAN) - CAMERA.Y);
      MY_SPEED.Z = 0.5*(player.Z + player.MAX_Z - CAMERA.Z);
		IF (person_3rd < 1) {			// not yet fully set?
			CAMERA.X += 3*MY_SPEED.X;	// displace the camera directly
			CAMERA.Y += 3*MY_SPEED.Y;	// otherwise it's stuck in the player
			CAMERA.Z += 2*MY_SPEED.Z;
//      	CAMERA.DIAMETER = 8;		// now make the camera impassable
		} ELSE {
			MOVE_VIEW CAMERA,NULLSKILL,MY_SPEED;
		}
		IF (IN_SOLID) { 			// if camera moved into a wall,
			temp_cdist *= 0.7;	// place it closer to the player
		} ELSE {
			temp_cdist += 0.2*(player.MAX_Y + camera_dist - temp_cdist);
		}

		// check to see if camera is located in a passable block
		IF (ent_content(NULL, CAMERA.POS) == 2)
		{
		 	FOG_COLOR = _FOG_UNDERWATER;  // set fog color to underwater
		}
		ELSE
		{
			// else restore the current_fog_index
			FOG_COLOR = current_fog_index;
		}

		person_3rd = 1;
	}
/* IFDEF FACE_THE_PLAYER;
   ELSE {
	   temp.X = player.X - camera.X;
	   temp.Y = player.Y - camera.Y;
	   temp.Z = 0;
		VEC2ANGLE temp,temp;
		camera.pan = temp.pan;
	}
ENDIF; */
}

ACTION move_view
{
	IF (player == NULL) { player = ME; }	// this action needs the player synonym
	IF (player == NULL) { RETURN; }			// still no player -> can't work
	IF (person_3rd > 0) {	// This skill should be local
		move_view_3rd();
	} ELSE {
		move_view_1st();
	}
}

// create a shadow below the entity
ACTION drop_shadow
{
	IF (VIDEO_DEPTH >= 16) {
		CREATE SHADOWSPRITE,MY.POS,move_shadow;
	} ELSE {
		CREATE SHADOWFLAT,MY.POS,move_shadow;
	}
}

// Mod Date: 05/29/00
//				 Added check for swimming or wading (no shadow)
ACTION move_shadow
{
	MY.TRANSPARENT = ON;
	MY.FLARE = ON;	// inverse alpha
	MY.PASSABLE = ON;
	MY.ORIENTED = ON;
	MY.AMBIENT = 0;
	MY.SCALE_X = (YOUR.MAX_X - YOUR.MIN_X)/(MY.MAX_X - MY.MIN_X);
	MY.SCALE_Y = MY.SCALE_X * 0.7;
	MY.SCALE_Z = 1.0;
	MY.TILT = 90;	// set it flat onto the floor
	WHILE ((YOU != NULL)&&(YOUR._MOVEMODE > 0))
	{
		IF ((YOUR.INVISIBLE == ON)
			 || (YOUR._MOVEMODE == _MODE_SWIMMING)
			 || (YOUR._MOVEMODE == _MODE_WADING))
		{
			MY.INVISIBLE = ON;
		}
		ELSE
		{
			MY.INVISIBLE = OFF;
			temp_ent = YOU;
			SONAR	temp_ent,500;	// get height above the floor
			my_height = RESULT;
			YOU = temp_ent;		// YOU (the entity itself) is changed by SONAR
			MY.PAN = YOUR.PAN;
			MY.X = YOUR.X;
			MY.Y = YOUR.Y;
			MY.Z = YOUR.Z + YOUR.MIN_Z + 2 - my_height;
// To improve: Adapt shadow orientation to floor slope
		}
		WAIT 1;
	}
	REMOVE ME;
}


// Get key input from the player
// Mod Date: 6/9/00 Doug Poston
//				changed from ACTION to function
FUNCTION _player_intentions()
{
// Set the angular forces according to the player intentions
	aforce.PAN = -astrength.PAN*(KEY_FORCE.X+JOY_FORCE.X);
	aforce.TILT = astrength.TILT*(KEY_PGUP-KEY_PGDN);
	IF (MOUSE_MODE == 0) {	// Mouse switched off?
		 aforce.PAN += -astrength.PAN*MOUSE_FORCE.X*mouseview;
		 aforce.TILT += astrength.TILT*MOUSE_FORCE.Y*mouseview;
	}
	aforce.ROLL = 0;
// Set ROLL force if ALT was pressed
	IF (KEY_ALT != 0) {
		aforce.ROLL = aforce.PAN;
		aforce.PAN = 0;
	}
// Double the forces in case the player pressed SHIFT
	IF (KEY_SHIFT != 0) {
		aforce.PAN += aforce.PAN;
		aforce.TILT += aforce.TILT;
		aforce.ROLL += aforce.ROLL;
	}
// Limit the forces in case the player
// pressed buttons, mouse and joystick simultaneously
	limit.PAN = 2*astrength.PAN;
	limit.TILT = 2*astrength.TILT;
	limit.ROLL = 2*astrength.ROLL;

	IF (aforce.PAN > limit.PAN) {  aforce.PAN = limit.PAN; }
	IF (aforce.PAN < -limit.PAN) {  aforce.PAN = -limit.PAN; }
	IF (aforce.TILT > limit.TILT) {  aforce.TILT = limit.TILT; }
	IF (aforce.TILT < -limit.TILT) {  aforce.TILT = -limit.TILT; }
	IF (aforce.ROLL > limit.ROLL) {  aforce.ROLL = limit.ROLL; }
	IF (aforce.ROLL < -limit.ROLL) {  aforce.ROLL = -limit.ROLL; }

// Set the cartesian forces according to the player intentions
	force.X = strength.X*(KEY_FORCE.Y+JOY_FORCE.Y);
	force.Y = strength.Y*(KEY_COMMA-KEY_PERIOD);
	force.Z = strength.Z*(KEY_HOME-KEY_END);
	IF (MOUSE_MODE == 0) {	// Mouse switched off?
		force.X += strength.X*MOUSE_RIGHT*mouseview;
	}

// Double the forces in case the player pressed SHIFT
	IF (KEY_SHIFT != 0) {
		force.X += force.X;
		force.Y += force.Y;
		force.Z += force.Z;
	}

// Limit the forces in case the player tried to cheat by
// operating buttons, mouse and joystick simultaneously
	limit.X = 2*strength.X;
	limit.Y = 2*strength.Y;
	limit.Z = 2*strength.Z;

	IF (force.X > limit.X) {  force.X = limit.X; }
	IF (force.X < -limit.X) { force.X = -limit.X; }
	IF (force.Y > limit.Y) {  force.Y = limit.Y; }
	IF (force.Y < -limit.Y) { force.Y = -limit.Y; }
	IF (force.Z > limit.Z) {  force.Z = limit.Z; }
	IF (force.Z < -limit.Z) { force.Z = -limit.Z; }
}

// Mod Date: 6/9/00 Doug Poston
//				changed to function
FUNCTION _player_force()
{
	IF (_camera == 0) {	// If the camera does not move itself
IFDEF ACKNEX_VERSION414;
		if (client_moving)
		{
			force.X = MY._FORCE_X;
			force.Y = MY._FORCE_Y;
			force.Z = MY._FORCE_Z;
			aforce.PAN = MY._AFORCE_PAN;
			aforce.TILT = MY._AFORCE_TILT;
			aforce.ROLL = MY._AFORCE_ROLL;
		}
		ELSE
		{
			_player_intentions();
		}
IFELSE;
		_player_intentions();
ENDIF;
		aforce.PAN *= MY._FORCE;
		aforce.TILT *= MY._FORCE;
		aforce.ROLL *= MY._FORCE;
		force.X *= MY._FORCE;
		force.Y *= MY._FORCE;
		force.Z *= MY._FORCE;
	}
	ELSE
	{ // player controls camera - set actor forces to zero
		aforce.PAN = 0;
		aforce.TILT = 0;
		aforce.ROLL = 0;
		force.X = 0;
		force.Y = 0;
		force.Z = 0;
	}
}


ACTION client_move
{
IFDEF ACKNEX_VERSION414;
	client_moving = 1;
	WHILE (1) {
		_player_intentions();
		if (player) {	// player created on the client?
			player._FORCE_X = force.X;
			player._FORCE_Y = force.Y;
			player._FORCE_Z = force.Z;
			player._AFORCE_PAN = aforce.PAN;
			player._AFORCE_TILT = aforce.TILT;
			player._AFORCE_ROLL = aforce.ROLL;
// send forces to server
			SEND player._FORCE_X;
			SEND player._FORCE_Y;
			SEND player._FORCE_Z;
			SEND player._AFORCE_PAN;
			SEND player._AFORCE_TILT;
			SEND player._AFORCE_ROLL;


// move the camera
			move_view();
		}
		WAIT 1;
	}
ENDIF;
	RETURN;
}

/////////////////////////////////////////////////////////////////////
ACTION toggle_person {
	IF (person_3rd > 0) {
		person_3rd = 0;
	} ELSE {
		person_3rd = 0.5;
	}
}

/////////////////////////////////////////////////////////////////////
// Auxiliary actions

// Desc: scan for a surface below the ME entity
//       set my_floornormal vector to the normal of the surface
//			set my_height to the distance between ME.MIN_Z and the surface
//			set floorspeed to the X & Y speed of any platform ME is on.
ACTION scan_floor
{
	SONAR	ME,4000;

	my_floornormal.X = NORMAL.X; 	// set my_floornormal to the normal of the surface
	my_floornormal.Y = NORMAL.Y;
	my_floornormal.Z = NORMAL.Z;
	my_height = RESULT;       		// set my_height to the distance between entity's MIN_Z and surface

	my_floorspeed.X = 0; 			// reset floorspeed to zero
	my_floorspeed.Y = 0;

	// if the player is standing on a platform, move him with it
	IF (YOU != NULL)
	{
		IF (YOUR._TYPE == _TYPE_ELEVATOR)
		{
			my_floorspeed.X = YOUR._SPEED_X;
			my_floorspeed.Y = YOUR._SPEED_Y;
			// Z speed is not necessary - this is done by the height adaption
		}
	}
// test the floor texture
//	temp.X = MY.X;
//	temp.Y = MY.Y;
//	temp.Z = MY.Z - 500;
//	LOOK NULL,MY.X,temp;
}

/////////////////////////////////////////////////////////////
// Calculate a position directly ahead of the camera
// Input:  p (distance)
// Output: MY_POS
ACTION set_pos_ahead
{
	temp.X = COS(CAMERA.PAN);
	temp.Y = SIN(CAMERA.PAN);
	temp.Z = p*COS(CAMERA.TILT);
	MY_POS.X = CAMERA.X + temp.Z*temp.X;
	MY_POS.Y = CAMERA.Y + temp.Z*temp.Y;
	MY_POS.Z = CAMERA.Z + p*SIN(CAMERA.TILT);
}

/////////////////////////////////////////////////////////////
// Calculate a 3d position relative to the camera angles
// Input:  MY_POS
// Output: MY_POS
// Mod Date: 6/9/00 Doug Poston
//				changed to function
FUNCTION _set_pos_ahead_xyz()
{
	VECROTATE MY_POS,CAMERA.PAN;
	IF (person_3rd != 0)
	{
		MY_POS.X += player.X;
		MY_POS.Y += player.Y;
		MY_POS.Z += player.Z;
	}
	ELSE
	{
		MY_POS.X += CAMERA.X;
		MY_POS.Y += CAMERA.Y;
		MY_POS.Z += CAMERA.Z;
	}
}

////////////////////////////////////////////////////////////////////////
// Desc: event action to indicate any event by resetting the event flag
//
// Mod Date: 6/9/00 Doug Poston
//				changed to function
FUNCTION _setback()
{
	IF (EVENT_TYPE == EVENT_BLOCK) { MY.ENABLE_BLOCK = OFF; }
	IF (EVENT_TYPE == EVENT_ENTITY) { MY.ENABLE_ENTITY = OFF; }
	IF (EVENT_TYPE == EVENT_STUCK) { MY.ENABLE_STUCK = OFF; }

	IF (EVENT_TYPE == EVENT_PUSH) { MY.ENABLE_PUSH = OFF; }
	IF (EVENT_TYPE == EVENT_IMPACT) { MY.ENABLE_IMPACT = OFF; }

	IF (EVENT_TYPE == EVENT_DETECT) { MY.ENABLE_DETECT = OFF; }
	IF (EVENT_TYPE == EVENT_SCAN) { MY.ENABLE_SCAN = OFF; }
	IF (EVENT_TYPE == EVENT_SHOOT) { MY.ENABLE_SHOOT = OFF; }
	IF (EVENT_TYPE == EVENT_TRIGGER) { MY.ENABLE_TRIGGER = OFF; }

	IF (EVENT_TYPE == EVENT_TOUCH) { MY.ENABLE_TOUCH = OFF; }
	IF (EVENT_TYPE == EVENT_RELEASE) { MY.ENABLE_RELEASE = OFF; }
	IF (EVENT_TYPE == EVENT_CLICK) { MY.ENABLE_CLICK = OFF; }
}

// Mod Date: 6/9/00 Doug Poston
//				changed to function
FUNCTION _beep() { BEEP; }

////////////////////////////////////////////////////////////////////////
// Handle action. Set to SPACE by default.
// Will operate doors or items within 200 quants.
VAR indicator = 0;

DEFINE _HANDLE,1;		// SCAN via space key
DEFINE _EXPLODE,2;	// SCAN by an explosion
DEFINE _GUNFIRE,3;	// SHOOT fired by a gun
DEFINE _WATCH,4;		// looking for an enemy
DEFINE _DETECTED,5;	// detected by an enemy
DEFINE _SHOOT1,6;		// shoot key pressed (not used yet)

ACTION handle
{
	IF (player != NULL) {
		MY_POS.X = player.X;
		MY_POS.Y = player.Y;
		MY_POS.Z = player.Z;
		MY_ANGLE.PAN = player.PAN;
	} ELSE {
		MY_POS.X = CAMERA.X;
		MY_POS.Y = CAMERA.Y;
		MY_POS.Z = CAMERA.Z;
		MY_ANGLE.PAN = CAMERA.PAN;
	}
	MY_ANGLE.TILT = CAMERA.TILT;
	scan_handle();
}

// scan a wide cone of 200 quants range
ACTION scan_handle
{
	temp.PAN = 120;
	temp.TILT = 180;
	temp.Z = 200;
	indicator = _HANDLE;
	SCAN	MY_POS,MY_ANGLE,temp;
}


// This action can be run by a player entity on the server
// It checks for receiving a handle signal, then performs a scan
ACTION perform_handle
{
IFDEF ACKNEX_VERSION414;
	WHILE (1) {
		IF (MY._SIGNAL == _HANDLE) {	// client has pressed handle key
			MY.HIDDEN = ON;
			MY._SIGNAL = 0;				// reset it
			MY_POS.X = MY.X;
			MY_POS.Y = MY.Y;
			MY_POS.Z = MY.Z;
			MY_ANGLE.PAN = MY.PAN;
			MY_ANGLE.TILT = MY.TILT;
			scan_handle();
		}
		WAIT 1;
	}
ENDIF;
	RETURN;
}

ACTION send_handle
{
IFDEF ACKNEX_VERSION414;
	IF (player != NULL) {
		player._SIGNAL = _HANDLE;	// send command to perform a scan
		SEND player._SIGNAL;
	}
IFELSE;
	BRANCH handle;
ENDIF;
}
/////////////////////////////////////////////////////////////////////
ON_F7 toggle_person;

ON_SPACE send_handle;

/////////////////////////////////////////////////////////////////////