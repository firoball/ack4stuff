//////////////////////////////////////////////////////////////////////
// WAR.WDL - fighting behaviour
///////////////////////////////////////////////////////////////////////
IFNDEF WAR_DEFS;
 DEFINE ACTOR_EXPLO,<explo+7.pcx>;
 DEFINE ACTOR_EXPLO_FRAMES,7;
ENDIF;

///////////////////////////////////////////////////////////////////////
SKILL freeze_actors { VAL 0; }	// 1,2 for testing purposes


///////////////////////////////////////////////////////////////////////
DEFINE _STATE_WAIT,1;
DEFINE _STATE_ATTACK,2;
DEFINE _STATE_ESCAPE,3;
DEFINE _STATE_DIE,4;
DEFINE _STATE_FREEZE,4;

///////////////////////////////////////////////////////////////////////
SYNONYM test_actor { TYPE entity; }

STRING	robot_attack_str, "attack";	// attack frame names used by robot

ACTION robot_test {
IFNDEF test;
	REMOVE ME;
	RETURN;
ENDIF;

	SET test_actor,ME;
	MY._WALKFRAMES = 8.030;
	MY._RUNFRAMES = 4.050;
	MY._ATTACKFRAMES = 6;
	MY._DIEFRAMES = 1;
	MY._FORCE = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.05;
	MY._HITMODE = HIT_EXPLO;
	MY._WALKSOUND = _SOUND_ROBOT;
	CALL  drop_shadow;
	CALL	anim_init;
	CALL	actor_fight;
}

// Desc: add frame code back for old animation
ACTION robot1 {
	/*
	MY._WALKFRAMES = 7.020;
	MY._RUNFRAMES = 4.050;
	MY._ATTACKFRAMES = 3;
	MY._DIEFRAMES = 5;
	*/
	MY._FORCE = 0.7;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.20;
	MY._HITMODE = 0;
	MY._WALKSOUND = _SOUND_ROBOT;
	drop_shadow();	// attach shadow to robot
	//anim_init();
	actor_fight();
//	IF (MY.FLAG4 == ON) { CALL patrol; }
}


ACTION robot2 {
   /*
   MY._WALKFRAMES = 8.030;
	MY._RUNFRAMES = 4.050;
	MY._ATTACKFRAMES = 6;
	MY._DIEFRAMES = 1;
	*/
	MY._FORCE = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.05;
	MY._HITMODE = HIT_EXPLO;
	MY._WALKSOUND = _SOUND_ROBOT;
	drop_shadow(); // attach shadow to robot
	//CALL	anim_init;
	actor_fight();
//	IF (MY.FLAG4 == ON) { CALL patrol; }
}

ACTION robot3 {
	REMOVE ME;
	RETURN;
	/*
	MY._WALKFRAMES = 7.030;
	MY._RUNFRAMES = 4.050;
	MY._ATTACKFRAMES = 3;
	MY._DIEFRAMES = 5;
	*/
	MY._FORCE = 0.7;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.20;
	CALL  drop_shadow;
	//CALL	anim_init;
	CALL	actor_fight;
//	IF (MY.FLAG4 == ON) { CALL patrol; }
}


///////////////////////////////////////////////////////////////////////

// Desc: init actor for fighting and branch to the wait state
ACTION actor_fight
{
//	IF (MY._ARMOR == 0) { MY._ARMOR = 100; }
	IF (MY._HEALTH == 0) { MY._HEALTH = 100; }	// default health
	IF (MY._FORCE == 0) { MY._FORCE = 1; }       // default force

	// Allow player to pass thru actor if frozen
	IF (freeze_actors > 1) { SET MY.PASSABLE,ON; }

	MY._SIGNAL = 0;
	SET MY.ENABLE_SCAN,ON;
	SET MY.ENABLE_SHOOT,ON;
	SET MY.ENABLE_DETECT,ON;
	SET MY.EVENT,fight_event;

	BRANCH state_wait;
}

// Desc: the WAIT state
//
//	Mod:	6/15/00	Doug Poston
//			Added call to actor_move
function state_wait()
{
	MY._STATE = _STATE_WAIT;
	WHILE (MY._STATE == _STATE_WAIT)
	{

		IF (MY._HEALTH <= 0) { BRANCH state_die; }        // no health? Die
		IF (MY._HEALTH <= 30) { BRANCH state_escape; }    // low health? Escape

		// scan for the player coming near
		temp.PAN = 180;
		temp.TILT = 180;
		temp.Z = 1000;
		indicator = _WATCH;
		SCAN	MY.POS,MY.ANGLE,temp;

		// if the player has been detected...
		IF (MY._SIGNAL == _DETECTED)
		{
			MY._SIGNAL = 0;
			BRANCH state_attack;	// ATTACK!
		}
		force = 0;     // no force from this actor
		actor_move();	// react to outside forces (gravity, etc) even while waiting
		WAITT 4;
	}
}

// Desc: The attack state
//
// Mod Date: 6/27/00 Doug Poston
//				Added longer (timed) waits in attack states
function state_attack()
{
	MY._STATE = _STATE_ATTACK;
	MY._MOVEMODE = _MODE_ATTACK;	// stop patrolling etc.
	CALL attack_transitions;      // branch to other states depending on values

	// Close distance and fire
	WHILE (MY._STATE == _STATE_ATTACK)
	{
		// fire two or three times
		MY._COUNTER = 1.5 + RANDOM(1);
		attack_fire();
		WHILE (MY._COUNTER > 0) { WAITT 8; }

		// walk towards player for one to three seconds
		MY._COUNTER = 16 + RANDOM(32);
		attack_approach();
		WHILE (MY._COUNTER > 0) { WAIT 1; }
	}
}

// Desc: Use internal and external values to branch to other states
ACTION attack_transitions
{
	WHILE (MY._STATE == _STATE_ATTACK)
	{
		IF (MY._HEALTH <= 0) { BRANCH state_die; }    	// goto die state
		IF (MY._HEALTH <= 30) { BRANCH state_escape; }  // goto escape state
		IF (freeze_actors > 0) { BRANCH state_freeze; } // goto freeze state
		WAIT 1;
	}
}

//	Desc: attack the player:
//				-turn towards player
//				-check if entity can see the player
//				-play fire animation
//				-fire shot
//
// Mod Date: 5/9/00 @ 908 by Doug Poston
//           Modified to use new animation system (SET_CYCLE/FRAME)
function attack_fire()
{

	WHILE ((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{
		// turn towards player
		temp.X = player.X - MY.X;
		temp.Y = player.Y - MY.Y;
		temp.Z = player.Z - MY.Z;
		TO_ANGLE MY_ANGLE,temp;
		force = MY._FORCE * 2;
		CALL actor_turn;

		// watch out if player visible. If yes, then shoot at him
		indicator = _WATCH;
		SHOOT MY.POS,player.POS;
		IF ((RESULT > 0) && (YOU == player))	// spotted him!
		{
			// fire at player
			// 1) PLAY ATTACK ANIMATION
			// check for new animation format
			IF (FRC(MY._WALKFRAMES) == 0)
			{
				// reset entity's animation time to zero
				MY._ANIMDIST = 0;

				WHILE (MY._ANIMDIST < 50)
				{
					WAIT 1;
 					// calculate a percentage out of the animation time
					MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
					// set the frame from the percentage
	  				SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
				}
			}// END NEW STYLE ATTACK ANIMATION
			//IF (FRC(MY._WALKFRAMES) != 0)
			ELSE  // OLD STYLE ATTACK ANIMATION
			{
				// play attack animation
				MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;   // set frame to start
				MY.NEXT_FRAME = 0;	// inbetween to the real next frame
				WHILE (MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES)
				{
 			 		MY.FRAME += 0.4 * TIME;
				}
  				MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + 1;  // end at start frame
			}// END OLD STYLE ATTACK ANIMATION

			// 2) fire shot
			damage = FRC(MY._FIREMODE) * 100;
			fire_mode = MY._FIREMODE;
			IF ((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
			{
				shot_speed.X = 500;
			}
			ELSE
			{
				shot_speed.X = 100;
			}
			shot_speed.Y = 0;
			shot_speed.Z = 0;
			MY_ANGLE.PAN = MY.PAN;	// TILT is already set from TO_ANGLE
			VECROTATE shot_speed,MY_ANGLE;
			// now shot_speed points ahead

			gun_muzzle.X = MY.X;
			gun_muzzle.Y = MY.Y;
			gun_muzzle.Z = MY.Z;
			PLAY_ENTSOUND ME,gun_wham,150;
			CALL gun_shot;
			MY._COUNTER -= 1;
			IF (FRC(MY._WALKFRAMES) == 0)
			{
				// play the second half of the animation
 				WHILE (MY._ANIMDIST < 100)
				{
					WAIT 1;
 					// calculate a percentage out of the animation time
					MY._ANIMDIST += 8.0 * TIME;   // attack in ~1 second
					// set the frame from the percentage
	  				SET_FRAME	ME,robot_attack_str,MY._ANIMDIST;
				}
			}// END NEW STYLE ATTACK ANIMATION
		}
		WAIT 1;
	}// END  WHILE ((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
}

function attack_approach()
{
// calculate a direction to walk into
	temp.X = player.X - MY.X;
	temp.Y = player.Y - MY.Y;
	temp.Z = 0;
	TO_ANGLE MY_ANGLE,temp;
// ADD random deviation angle
	MY._TARGET_PAN = MY_ANGLE.PAN - 15 + RANDOM(30);

	WHILE ((MY._STATE == _STATE_ATTACK) && (MY._COUNTER > 0))
	{
// turn towards player
		MY_ANGLE.PAN = MY._TARGET_PAN;
		MY_ANGLE.TILT = 0;
		MY_ANGLE.ROLL = 0;
		force = MY._FORCE * 2;
		CALL actor_turn;

// walk towards him if not too close
		temp = (player.X - MY.X)*(player.X - MY.X)+(player.Y - MY.Y)*(player.Y - MY.Y);
		if (temp > 2500)  // 50^2
		{	//$$$10000) {
			force = MY._FORCE;
			MY._MOVEMODE = _MODE_WALKING;
			CALL actor_move;
		}

		WAIT 1;
		MY._COUNTER -= TIME;
	}
}

// low on health => try to run away
ACTION state_escape
{
	MY._STATE = _STATE_ESCAPE;
	WHILE (MY._STATE == _STATE_ESCAPE) {
		IF (MY._HEALTH <= 0) { BRANCH state_die; }
		// turn away from player
		temp.X = MY.X - player.X;
		temp.Y = MY.Y - player.Y;
		temp.Z = MY.Z - player.Z;
		TO_ANGLE MY_ANGLE,temp;
		force = MY._FORCE * 6;
		CALL actor_turn;

		force = MY._FORCE * 4;
		MY._MOVEMODE = _MODE_WALKING;
		CALL actor_move;

		WAIT 1;
	}
}


// Desc: Die:
//				-stop moving
//				-stop scanning and shooting
//				-null out my.event
//				-play death animation
//				-become passable
//
// Mod Date: 5/8/00 @ 752 by Doug Poston
//           Modified to use new animation system (SET_CYCLE/FRAME)
//
//	Notes: Uses entity's _AMIMDIST value as a 'percent death' value (0 start, 100 end)
ACTION state_die
{
	MY._MOVEMODE = 0;		// don't move anymore
	MY._STATE = _STATE_DIE;
	SET MY.ENABLE_SCAN,OFF;		// get deaf and blind
	SET MY.ENABLE_SHOOT,OFF;
	SET MY.EVENT,NULL;			// and don't react anymore

	// decide whether it's a frame number (old) or frame name (new) animation
	IF (FRC(MY._WALKFRAMES) == 0)
	{
		// reset entity's animation time to zero
		MY._ANIMDIST = 0;

		WHILE (MY._ANIMDIST < 100)
		{
			WAIT 1;
 			// calculate a percentage out of the animation time
			MY._ANIMDIST += 5.0 * TIME;   // death in ~1.25 seconds
			// set the frame from the percentage
	  		SET_FRAME	ME,anim_death_str,MY._ANIMDIST;
		}
	}// END NEW STYLE DEATH ANIMATION
	ELSE    // OLD STYLE ANIMATION
	{
		MY.FRAME = 1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES + 1;
		MY.NEXT_FRAME = 0;	// inbetween to the real next frame
		WHILE (MY.FRAME <= (1 + MY._WALKFRAMES + MY._RUNFRAMES + MY._ATTACKFRAMES + MY._DIEFRAMES))
		{
			WAIT 1;
			MY.FRAME += 0.7 * TIME;
	//		MY.Z -= TIME;	// sink into ground a little
		}

	}// END OLD STYLE ANIMATION


	// If entity explodes after death
	IF ((ME != player) && (MY._HITMODE & HIT_EXPLO))
	{
		//MORPH ACTOR_EXPLO,ME;
	  //	MY._DIEFRAMES = ACTOR_EXPLO_FRAMES;
	  _gib(/*25*/);             // use new "gib" function
	  BRANCH actor_explode;

	}
	SET MY.PASSABLE,ON;
}





ACTION state_freeze
{
	MY._STATE = _STATE_FREEZE;
	MY._MOVEMODE = _MODE_STILL;	// stop patroilling etc.
	WHILE (MY._STATE == _STATE_FREEZE) {
		IF (freeze_actors > 1) { SET MY.PASSABLE,ON; }
		IF (freeze_actors == 0) { BRANCH state_wait; }
		WAIT 1;
	}
}

////////////////////////////////////////////////////////////////////////
ACTION fight_event {
	IF ((EVENT_TYPE == EVENT_SCAN && indicator == _EXPLODE)
		|| (EVENT_TYPE == EVENT_SHOOT && indicator == _GUNFIRE))
	{
		MY._SIGNAL = _DETECTED;	// by shooting, player gives away his position

		if (indicator == _EXPLODE) {	// reduce damage according to distance
			damage *= ABS(range - RESULT)/range;
		}

		IF (MY._ARMOR <= 0) {
			MY._HEALTH -= damage;
		} ELSE {
			MY._ARMOR -= damage;
		}
		RETURN;
	}

	IF (EVENT_TYPE == EVENT_DETECT && YOU == player) {
		indicator = _WATCH;
		SHOOT MY.POS,YOUR.POS;	// can player be seen from here?
		IF ((RESULT > 0) && (YOU == player)) {		// yes
			MY._SIGNAL = _DETECTED;
		}
		RETURN;
	}
}



// PLAYER ACTIONS
///////////////////////////////////////////////////////////////////////
ACTION player_fight
{
	IF (MY._HEALTH == 0) { MY._HEALTH = 100; }

	SET MY.ENABLE_SCAN,ON;
	SET MY.ENABLE_SHOOT,ON;
	SET MY.EVENT,fight_event;

	WHILE (MY._HEALTH > 0)
	{
		IF (MY._SIGNAL == _DETECTED) {	// Hit received?
			MY._SIGNAL = 0;	// reset the _signal skill
			IF (person_3rd == 0) {
				CALL player_shake; }
		}
		WAIT 1;
	}

// Dead
	MY._HEALTH = 0;
	IF (person_3rd == 0)
	{	// 1st person die action
		MY._MOVEMODE = 0;		// don't move anymore
		MY.EVENT = NULL;		// prevent health counting down
		CALL player_tip;
		WAITT 8;
		CALL weapon_remove; 	// let weapon disappear
	}
	ELSE
	{
		CALL weapon_remove;	// prevent dead player firing
		BRANCH state_die;
	}
}




// GIB FX
// Needs more fine-tunning (and a "gibbit" model)

// Desc: explode into x number of random models
function	_gib (/*var numberOfParts*/)
{
	temp = 0;
	WHILE (temp < 25)
	{
		CREATE  <gibbit.mdl>, MY.POS, _gib_action;
		temp += 1;
	}

}

// Desc: Init and animate a gib-bit
//
// Mod Date: 6/29/00 Doug Poston
//				Added rotation and alpha-fading
function _gib_action ()
{
	// Init gib bit
	MY._SPEED_X = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Y = 25 * (RANDOM(10) - 5);    // -125 -> +125
	MY._SPEED_Z = RANDOM(35) + 15;          // 15 -> 50

	MY._ASPEED_PAN = RANDOM(35) + 35;       // 35 -> 70
	MY._ASPEED_TILT = RANDOM(35) + 35;      // 35 -> 70
	MY._ASPEED_ROLL = RANDOM(35) + 35;      // 35 -> 70

	MY.ROLL = RANDOM(180);	// start with a random orientation
	MY.PAN = RANDOM(180);

	MY.PUSH = -1;	// allow user/enemys to push thru



	// Animate gib-bit
	MY.SKILL9 = RANDOM(50);
	WHILE (MY.SKILL9 > -75)
	{
		abspeed[0] = MY._SPEED_X * TIME;
		abspeed[1] = MY._SPEED_Y * TIME;
		abspeed[2] = MY._SPEED_Z * TIME;

		MY.PAN += MY._ASPEED_PAN * TIME;
		MY.TILT += MY._ASPEED_TILT * TIME;
		MY.ROLL += MY._ASPEED_ROLL * TIME;

		MOVE  ME,NULLSKILL,abspeed;

		IF(BOUNCE.Z)
		{
			MY._SPEED_Z = -(MY._SPEED_Z/2);
			IF (MY._SPEED_Z < 0.25)
			{
				MY._SPEED_X = 0;
				MY._SPEED_Y = 0;
				MY._SPEED_Z = 0;
				MY._ASPEED_PAN = 0;
				MY._ASPEED_TILT = 0;
				MY._ASPEED_ROLL = 0;
			}
		}

		MY._SPEED_Z -= 2;
		MY.SKILL9 -= 1;

		WAIT(1);
	}


	// Fade
	MY.transparent = ON;
	MY.alpha = 100;
	while (1)
	{
   	MY.alpha -= 5*time;
		IF (MY.alpha <=0)
		{
			// remove
			REMOVE ME;
			RETURN;
		}

   	WAIT(1);
	}
}