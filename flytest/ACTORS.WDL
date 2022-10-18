//////////////////////////////////////////////////////////////////////
// WDL prefabs for actors and enemies
//////////////////////////////////////////////////////////////////////
ACTION patrol
{
	IF (MY._FORCE == 0) {  MY._FORCE = 1; }
	IF (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	IF (MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	CALL anim_init;

// find next start position
	MY._TARGET_X = MY.X;
	MY._TARGET_Y = MY.Y;
	MY._TARGET_Z = MY.Z;
	scan_sector.PAN = 360;
	CALL _scan_target;

	WHILE (MY._MOVEMODE > 0)
	{
// find direction
		MY_POS.X = MY._TARGET_X - MY.X;
		MY_POS.Y = MY._TARGET_Y - MY.Y;
		MY_POS.Z = 0;
		TO_ANGLE MY_ANGLE,MY_POS;

		IF (MY_ANGLE.Z < 30) {	// near target? Find next
			scan_sector.PAN = 20;
			CALL _scan_target;
		}

		force = MY._FORCE * 2;
		CALL actor_turn;	// look to target

		force = MY._FORCE;
		IF (ABS(aforce.PAN) > MY._FORCE) {	// reduce speed if turning
			force *= 0.5; }
		IF (MY_ANGLE.Z < 40) {	// reduce speed near target
			force *= 0.5; }
		CALL actor_move;
// Wait one tick, then repeat
		WAIT	1;
	}
}

///////////////////////////////////////////////////////////////////////
// helper actions

// move ahead, according to force
ACTION actor_move
{
	force.Y = 0;
	force.Z = 0;

// find ground below
	CALL scan_floor;
	CALL move_gravity;
	CALL actor_anim;
}

ACTION actor_follow
{
	IF (MY._FORCE == 0) {  MY._FORCE = 2; }
	IF (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	IF (MY._WALKSOUND == 0) { MY._WALKSOUND = _SOUND_WALKER; }
	CALL anim_init;

	WHILE (1)
	{
// calculate a direction to walk into
		temp.X = player.X - MY.X;
		temp.Y = player.Y - MY.Y;
		temp.Z = 0;
		TO_ANGLE MY_ANGLE,temp;

// turn towards player
		MY_ANGLE.TILT = 0;
		MY_ANGLE.ROLL = 0;
		force = MY._FORCE * 2;
		CALL actor_turn;

// walk towards him
		force = MY._FORCE;
		MY._MOVEMODE = _MODE_WALKING;
		CALL actor_move;

		WAIT 1;
	}
}


IFDEF ACKNEX_VERSION414;
ACTION _actor_connect
{
	IF (EVENT_TYPE == EVENT_DISCONNECT) { REMOVE ME; }
}
ENDIF;

// turn towards target angle MY_ANGLE, according to force
//
// Mod Date: 6/27/00 Doug Poston
//				Replaced ACCEL
ACTION actor_turn
{
	aforce.PAN = 0;
	temp = ANG(MY_ANGLE.PAN - MY.PAN);
	IF (temp > 5)
	{
		aforce.PAN = force;
	}
	ELSE
	{
		IF (temp < -5)
		{
			aforce.PAN = -force;
		}
		ELSE
		{
			aforce.PAN = force*temp*0.25;
		}
	}

	// Now accelerate the angular speed, and change MY angles
	// -old method- ACCEL	MY._ASPEED,aforce,ang_fric;
	temp = min(TIME*ang_fric,1);
	MY._ASPEED_PAN  += (TIME * aforce.pan)  - (temp * MY._ASPEED_PAN);
	MY._ASPEED_TILT += (TIME * aforce.tilt) - (temp * MY._ASPEED_TILT);
	MY._ASPEED_ROLL += (TIME * aforce.roll) - (temp * MY._ASPEED_ROLL);

	MY.PAN += MY._ASPEED_PAN;
}

// Find next start position
ACTION _scan_target
{
// scan from old target
	MY_POS.X = MY._TARGET_X;
	MY_POS.Y = MY._TARGET_Y;
	MY_POS.Z = MY._TARGET_Z;
	MY_ANGLE.PAN = MY._TARGET_PAN;
	MY_ANGLE.TILT = 0;
	scan_sector.TILT = 90;
	scan_sector.Z = 2000;
	SCAN_POS MY_POS,MY_ANGLE,scan_sector;
	IF (RESULT > 0) {
// if found, set new target
		MY._TARGET_X = MY_POS.X;
		MY._TARGET_Y = MY_POS.Y;
		MY._TARGET_Z = MY_POS.Z;
		MY._TARGET_PAN = MY_ANGLE.PAN;
		MY._MOVEMODE = _MODE_WALKING;
	} ELSE {
		MY._MOVEMODE = 0;
	}
}
//////////////////////////////////////////////////////////////////////