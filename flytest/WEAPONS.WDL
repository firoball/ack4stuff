//////////////////////////////////////////////////////////////////////
// WDL prefabs for weapon entities
//////////////////////////////////////////////////////////////////////
// change these sounds and graphics for your weapon
IFNDEF WEAPON_DEFS;
 SOUND gun_click,<empty.wav>;
 SOUND gun_wham,<wham.wav>;
 SOUND explo_wham,<explo.wav>;
 DEFINE hit_wham,explo_wham;
 SOUND gun_fetch,<beamer.wav>;
 DEFINE ammo_fetch,gun_fetch;
 DEFINE health_fetch,gun_fetch;

 DEFINE muzzle_flash,<particle.pcx>;
 DEFINE small_flash,<particle.pcx>;
 DEFINE fireball,<blitz.pcx>;
 DEFINE BULLET_EXPLO,<explo+7.pcx>;
 DEFINE EXPLO_FRAMES,7;
 DEFINE WEAPON_AMPL,0.2;	// swaying
ENDIF;

//////////////////////////////////////////////////////////////////////
// adapt those skills and strings to your game
// ammo starting and maximum values
SKILL ammo1 { VAL 0; Z 200; }
SKILL ammo2 { VAL 0; Z 100; }
SKILL ammo3 { VAL 0; Z 40; }
SKILL ammo4 { VAL 0; Z 10; }

// dynamic light values
SKILL light_explo { RED 50; GREEN 50; BLUE 255; }
SKILL light_flash { RED 200; GREEN 150; BLUE 50; }
SKILL light_muzzle { RED 200; GREEN 20; BLUE 20; }
SKILL light_bullet { RED 200; GREEN 50; BLUE 20; }

// you'll probably want to redefine those strings. No problem.
STRING got_ammo1_str,"Got an ammo pack!";
STRING got_ammo2_str,"Got a big ammo pack!";
STRING got_ammo3_str,"Got a grenade pack!";
STRING got_ammo4_str,"Got a rocket pack!";
STRING got_medi_str,"Got a first aid kit!";
STRING got_gun1_str,"Got a small gun!";
STRING got_gun2_str,"Got a medium gun!";
STRING got_gun3_str,"Got a large gun!";
STRING got_gun4_str,"Got a gun no. 4!";
STRING got_gun5_str,"Got a gun no. 5!";
STRING got_gun6_str,"Got a gun no. 6!";
STRING got_gun7_str,"Got a gun no. 7!";

//////////////////////////////////////////////////////////////////////
/* Gun Action

FLAG1
	If this flag is set, the gun model rotates before being picked up.

FLAG2
	If this flag is set, the message on picking up the item will be
	suppressed.

FLAG5
   If this flag is marked, the gun sways a little if the camera is
	moving. The sway period is the same as used for head bobbing in the
	movement.wdl. If the flag is not marked, the gun stands still.

FLAG7
   If this flag is marked, it's a machine gun. Otherwise, a single
	action gun.

SKILL1..SKILL3
	X Y Z position of the gun relative to the camera.

SKILL4
	Ammo type (1..4). If 0, the gun doesn't consume ammunition. The part
	after the decimal, times 100, gives the amount of ammo to be added
	on picking up the gun. E.g. 2.30 = Ammo type 2, 30 rounds are
	already in the gun.

SKILL5 (_BULLETSPEED)
	Speed of the bullet, default = 200 quants / tick. The part after the
	decimal, times 10, gives the strength of the recoil. If 0, then
	there is no recoil. If SKILL5 is above 0, the recoil is done by
	moving backwards. If SKILL5 is below 0, then the recoil is done by
	swinging upwards.

SKILL6
	Weapon number that determines the key (1..7) to be pressed to select
	that gun.

SKILL7
   The time (in ticks) the gun needs to reload. Includes the time for
   the gun animation, if any.

SKILL8
   Fire mode, can be composed by adding the following numbers:

	1 - Damage is applied by a SHOOT instruction, without bullet (DAMAGE_SHOOT).
	2 - Damage is applied by IMPACT of the bullet (DAMAGE_IMPACT).
	3 - Damage is applied by a SCAN explosion of the bullet (DAMAGE_EXPLODE).

	4 - the gun fires red particles (FIRE_PARTICLE).
	8 - the gun fires dark bullets (FIRE_DPARTICLE).
	12 - the gun fires orange fireballs, which radiate light (FIRE_BALL).
	16 - the gun fires a rocket model w/smoke trail (FIRE_ROCKET)

	32 - the bullets leave smoke trails(BULLET_SMOKETRAIL).

	128 - at hit point there will be a light flash (HIT_FLASH).
	256 - at hit point there will be an explosion (HIT_EXPLO).
	384 - at hit point there will be a big explosion.

	512 - at hit point a cloud of smoke will ascend (HIT_SMOKE).

	1024 - there will be multiple hit points, as by a shotgun (HIT_SCATTER).

	2048 - the gun spats out cartridge cases.

	4096 - the bullets follow gravity.

	8192 - at hit point a shower of sparks (HIT_SPARKS).

	Only combinations 133 and 303 are already implemented.

	The part after the decimal, times 100, gives the amount of damage
	the bullet produces (default = 10).

*/
///////////////////////////////////////////////////////////////////////
DEFINE _OFFS_X,MY.SKILL1;
DEFINE _OFFS_Y,MY.SKILL2;
DEFINE _OFFS_Z,MY.SKILL3;
DEFINE _AMMOTYPE,SKILL4;
DEFINE _BULLETSPEED,SKILL5;
DEFINE _WEAPONNUMBER,SKILL6;
DEFINE _FIRETIME,SKILL7;

DEFINE _OFFS_FLASH,SKILL14;
DEFINE _RECOIL,SKILL15;
DEFINE _DAMAGE,SKILL16;
DEFINE _DISPLACEMENT,SKILL17;
DEFINE _FIRE,SKILL18;

DEFINE __REPEAT,FLAG7;

DEFINE MODE_DAMAGE,3;
DEFINE DAMAGE_SHOOT,1;
DEFINE DAMAGE_IMPACT,2;
DEFINE DAMAGE_EXPLODE,3;

DEFINE MODE_FIRE,28;        // DCP
DEFINE FIRE_PARTICLE,4;
DEFINE FIRE_DPARTICLE,8;
DEFINE FIRE_BALL,12;
DEFINE FIRE_ROCKET,16;

DEFINE BULLET_SMOKETRAIL,32;

DEFINE MODE_HIT,384;
DEFINE HIT_FLASH,128;
DEFINE HIT_EXPLO,256;

DEFINE HIT_SMOKE, 512;

DEFINE HIT_SCATTER,1024;

DEFINE HIT_SPARKS,8192;
///////////////////////////////////////////////////////////////////////
SYNONYM weapon { TYPE ENTITY; }
// The weapon must be a model pointing into X-direction,
// its center must be inside the barrel.

SYNONYM weapon1 { TYPE ENTITY; }
SYNONYM weapon2 { TYPE ENTITY; }
SYNONYM weapon3 { TYPE ENTITY; }
SYNONYM weapon4 { TYPE ENTITY; }
SYNONYM weapon5 { TYPE ENTITY; }
SYNONYM weapon6 { TYPE ENTITY; }
SYNONYM weapon7 { TYPE ENTITY; }

SKILL weapon_1 { VAL 0; }	// set to 1 if the player owns that weapon
SKILL weapon_2 { VAL 0; }
SKILL weapon_3 { VAL 0; }
SKILL weapon_4 { VAL 0; }
SKILL weapon_5 { VAL 0; }
SKILL weapon_6 { VAL 0; }
SKILL weapon_7 { VAL 0; }

SKILL gun_muzzle {}
SKILL gun_target {}
SKILL gun_loaded { VAL 1; }
SKILL fireball_speed {}

SKILL weapon_number { VAL 0; }
SKILL ammo_number { VAL 0; }

var damage = 0;
var range = 0;
var fire_mode = 0;
var weapon_firing = 0;

//////////////////////////////////////////////////////////////////////
ACTION testgun {
IFNDEF TEST;
	REMOVE ME;
	RETURN;
ENDIF;
	SET MY.__ROTATE,ON;
	SET MY.__REPEAT,ON;
	SET MY.__BOB,ON;
	MY.SKILL1 = 50;
	MY.SKILL2 = 20;
	MY.SKILL3 = 20;
	MY._AMMOTYPE = 1.50;
	MY._WEAPONNUMBER = 1;
	MY._BULLETSPEED = -500.05;
	MY._FIRETIME = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.30;
	CALL gun;
}

ACTION logangun
{
	SET MY.__ROTATE,ON;
	SET MY.__REPEAT,ON;
	SET MY.__BOB,ON;
	MY.SKILL1 = 42;
	MY.SKILL2 = 20;
	MY.SKILL3 = 7;
	MY._AMMOTYPE = 0.0;
	MY._WEAPONNUMBER = 3;
	MY._BULLETSPEED = 1000.25;
	MY._FIRETIME = 5;

	// SHOOT damage (immediate)
	// + flash at hit point
	// + smoke at hit point
	// + sparks at hit point
	// 50 points of damage per shot
	MY._FIREMODE = DAMAGE_SHOOT + HIT_FLASH + HIT_SMOKE + FIRE_PARTICLE + HIT_SPARKS + 0.50;
	CALL gun;
}


ACTION sparkgun {
	SET MY.__ROTATE,ON;
	SET MY.__REPEAT,ON;
	SET MY.__BOB,ON;
	MY.SKILL1 = 50;
	MY.SKILL2 = 20;
	MY.SKILL3 = 20;
	MY._AMMOTYPE = 1.50;
	MY._WEAPONNUMBER = 1;
	MY._BULLETSPEED = -500.05;
	MY._FIRETIME = 2;
	MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH+0.30;
	CALL gun;
}

ACTION flashgun {
	SET MY.__ROTATE,ON;
	SET MY.__REPEAT,ON;
	SET MY.__BOB,ON;
	MY.SKILL1 = 42;
	MY.SKILL2 = 20;
	MY.SKILL3 = 7;
	MY._AMMOTYPE = 2.15;
	MY._WEAPONNUMBER = 2;
	MY._BULLETSPEED = 150.05;
	MY._FIRETIME = 5;
	MY._FIREMODE = DAMAGE_EXPLODE+FIRE_BALL+HIT_EXPLO+BULLET_SMOKETRAIL+0.50;
	CALL gun;
}

//////////////////////////////////////////////////////////////////////
ACTION ammopac {
// default ammo type is 1
	IF (MY._AMMOTYPE == 0) { MY._AMMOTYPE = 1; }
// default ammo amount is a quarter of ammo maximum
	IF (MY.SKILL5 == 0) {
		IF (MY._AMMOTYPE == 1) { MY.SKILL5 = ammo1.Z * 0.25; }
		IF (MY._AMMOTYPE == 2) { MY.SKILL5 = ammo2.Z * 0.25; }
		IF (MY._AMMOTYPE == 3) { MY.SKILL5 = ammo3.Z * 0.25; }
		IF (MY._AMMOTYPE == 4) { MY.SKILL5 = ammo4.Z * 0.25; }
	}

	SET MY.EVENT,ammo_pickup;
	CALL item_pickup;
}

ACTION medipac {
	IF (MY.SKILL5 == 0) { MY.SKILL5 = 25; }
	SET MY.EVENT,medi_pickup;
	CALL item_pickup;
}

// Desc: set up a gun
//
ACTION gun
{
	// set the weapon camera offset (if one is not already defined)
	IF (MY.SKILL1 == 0)
	{
		MY.SKILL1 = 50;
		MY.SKILL2 = 20;
		MY.SKILL3 = 20;
	}

	// make sure we have a valid _WEAPONNUMBER
	IF (MY._WEAPONNUMBER <= 0 || MY._WEAPONNUMBER > 7)
	{ MY._WEAPONNUMBER = 1; }

	// set damage
	MY._DAMAGE = FRC(MY._FIREMODE) * 100;
 	IF (MY._DAMAGE == 0)
	{ MY._DAMAGE = 20; } // default to 20 damage

	// set firemode
	MY._FIREMODE = INT(MY._FIREMODE);
	IF (MY._FIREMODE == 0)
	{ MY._FIREMODE = DAMAGE_SHOOT+FIRE_PARTICLE+HIT_FLASH; }   // default to

	// set recoil (up or back)
	MY._RECOIL = FRC(MY._BULLETSPEED) * 100;

	// set bullet speed
	MY._BULLETSPEED = ABS(MY._BULLETSPEED);
	IF (MY._BULLETSPEED < 1)
	{ MY._BULLETSPEED = 200; }   // default to 200

	MY._OFFS_FLASH = MY.MAX_X + 1; 	// Muzzle flash offset

	SET MY.EVENT,gun_pickup;
	CALL item_pickup;

	// check whether this gun was picked up before in another level,
	// and has to be re-created for this level
	IF (MY._WEAPONNUMBER == 1 && weapon_1 == 1 && weapon1 == NULL)
	{ weapon1 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 2 && weapon_2 == 1 && weapon2 == NULL)
	{ weapon2 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 3 && weapon_3 == 1 && weapon3 == NULL)
	{ weapon3 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 4 && weapon_4 == 1 && weapon4 == NULL)
	{ weapon4 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 5 && weapon_5 == 1 && weapon5 == NULL)
	{ weapon5 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 6 && weapon_6 == 1 && weapon6 == NULL)
	{ weapon6 = ME; GOTO restore; }
	IF (MY._WEAPONNUMBER == 7 && weapon_7 == 1 && weapon7 == NULL)
	{ weapon7 = ME; GOTO restore; }

	RETURN;

restore:
	// weapon was already picked up by the player
	MY._AMMOTYPE = INT(MY._AMMOTYPE);	// happens on pickup

	SET MY.INVISIBLE,ON;
	SET MY.PASSABLE,ON;
	SET MY.ENABLE_SCAN,OFF;
	SET MY.ENABLE_CLICK,OFF;
	SET MY.ENABLE_PUSH,OFF;
	SET MY.EVENT,NULL;
	// Was it the last weapon the player carried?
	IF (weapon_number == MY._WEAPONNUMBER) { CALL gun_select; }
}

//////////////////////////////////////////////////////////////////////
ACTION medi_pickup {
	IF (EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { RETURN; }
	IF (EVENT_TYPE == EVENT_PUSH && YOU != player) { RETURN; }

	IF (YOU == NULL) { SET YOU,player; }
	IF (YOU == NULL) { RETURN; }

	YOUR._HEALTH += MY.SKILL5;
	IF (YOUR._HEALTH > 100) { YOUR._HEALTH = 100; }
	PLAY_SOUND health_fetch,50;
	SET msg.STRING,got_medi_str;
	IF (MY.__SILENT != ON) { CALL show_message; }
	REMOVE ME;
}

ACTION ammo_pickup {
	IF (EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { RETURN; }
	IF (EVENT_TYPE == EVENT_PUSH && YOU != player) { RETURN; }

	IF (MY._AMMOTYPE == 1) { ammo1 += MY.SKILL5; SET msg.STRING,got_ammo1_str; }
	IF (MY._AMMOTYPE == 2) { ammo2 += MY.SKILL5; SET msg.STRING,got_ammo2_str; }
	IF (MY._AMMOTYPE == 3) { ammo3 += MY.SKILL5; SET msg.STRING,got_ammo3_str; }
	IF (MY._AMMOTYPE == 4) { ammo4 += MY.SKILL5; SET msg.STRING,got_ammo4_str; }
	IF (MY.__SILENT != ON) { CALL show_message; }
	CALL _ammo_limit;
	PLAY_SOUND ammo_fetch,50;
	REMOVE ME;
}

ACTION _ammo_limit {	// clip ammo at maximum values
	IF (ammo1 > ammo1.Z) { ammo1 = ammo1.Z; }
	IF (ammo2 > ammo2.Z) { ammo2 = ammo2.Z; }
	IF (ammo3 > ammo3.Z) { ammo3 = ammo3.Z; }
	IF (ammo4 > ammo4.Z) { ammo4 = ammo4.Z; }
}

ACTION gun_pickup
{
	IF (EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { RETURN; }
	IF (EVENT_TYPE == EVENT_PUSH && YOU != player) { RETURN; }

	SET MY.ENABLE_SCAN,OFF;
	SET MY.ENABLE_CLICK,OFF;
	SET MY.ENABLE_PUSH,OFF;

	IF (INT(MY._AMMOTYPE) == 1) { ammo1 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	IF (INT(MY._AMMOTYPE) == 2) { ammo2 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5); }
	IF (INT(MY._AMMOTYPE) == 3) { ammo3 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	IF (INT(MY._AMMOTYPE) == 4) { ammo4 += INT(FRC(MY._AMMOTYPE) * 100 + 0.5);	}
	MY._AMMOTYPE = INT(MY._AMMOTYPE);	// ammo type
	CALL _ammo_limit;

	weapon_number = MY._WEAPONNUMBER;
	IF (weapon_number == 1) { SET weapon1,ME; weapon_1 = 1; SET ON_1,_gun_select1; SET msg.STRING,got_gun1_str; }
	IF (weapon_number == 2) { SET weapon2,ME; weapon_2 = 1; SET ON_2,_gun_select2; SET msg.STRING,got_gun2_str; }
	IF (weapon_number == 3) { SET weapon3,ME; weapon_3 = 1; SET ON_3,_gun_select3; SET msg.STRING,got_gun3_str; }
	IF (weapon_number == 4) { SET weapon4,ME; weapon_4 = 1; SET ON_4,_gun_select4; SET msg.STRING,got_gun4_str; }
	IF (weapon_number == 5) { SET weapon5,ME; weapon_5 = 1; SET ON_5,_gun_select5; SET msg.STRING,got_gun5_str; }
	IF (weapon_number == 6) { SET weapon6,ME; weapon_6 = 1; SET ON_6,_gun_select6; SET msg.STRING,got_gun6_str; }
	IF (weapon_number == 7) { SET weapon7,ME; weapon_7 = 1; SET ON_7,_gun_select7; SET msg.STRING,got_gun7_str; }

	IF (MY.__SILENT != ON) { CALL show_message; }
	CALL gun_select;
}

ACTION _gun_select1 { weapon_number = 1; CALL gun_select; }
ACTION _gun_select2 { weapon_number = 2; CALL gun_select; }
ACTION _gun_select3 { weapon_number = 3; CALL gun_select; }
ACTION _gun_select4 { weapon_number = 4; CALL gun_select; }
ACTION _gun_select5 { weapon_number = 5; CALL gun_select; }
ACTION _gun_select6 { weapon_number = 6; CALL gun_select; }
ACTION _gun_select7 { weapon_number = 7; CALL gun_select; }


// Desc: select/switch weapon
ACTION gun_select
{
	IF (weapon != NULL) {	// remove old weapon
		SET weapon.INVISIBLE,ON;
		SET weapon.PASSABLE,ON;
	}

	IF (weapon_number == 1) { SET ME,weapon1; }
	IF (weapon_number == 2) { SET ME,weapon2; }
	IF (weapon_number == 3) { SET ME,weapon3; }
	IF (weapon_number == 4) { SET ME,weapon4; }
	IF (weapon_number == 5) { SET ME,weapon5; }
	IF (weapon_number == 6) { SET ME,weapon6; }
	IF (ME == NULL) { RETURN; }

	ammo_number = MY._AMMOTYPE;
	SET MY.INVISIBLE, OFF;
	SET MY.PASSABLE,ON;	// prevent collision with obstacles
	SET MY.NEAR,ON;	// prevent clipping
	SET weapon,ME;		// I'm the current weapon now
	SET carry,weapon_carry;

	EXCLUSIVE_GLOBAL;
// handle firing
	WHILE (weapon == ME)
	{
		IF (weapon_firing && (gun_loaded > 0) && (MY._FIRE <= 0) )
		{
			CALL gun_fire;
		}

		IF ((weapon_firing == 0) && (gun_loaded == 0) && (MY.__REPEAT == OFF))
		{
			gun_loaded = 1;
		}
		WAIT 1;
	}
}

//////////////////////////////////////////////////////////////////////
// Called from player_move action; player must exist here
ACTION weapon_carry {
	IF (weapon == NULL || player == NULL) { RETURN; }
	IF (person_3rd != 0)
	{
		SET weapon.INVISIBLE,ON;

player._FIREMODE = weapon._FIRE;  //????????????
	/*	// if firing in 3rd person mode, calculate the player's attack frame
		IF (weapon._FIRE > 0)
		{
			temp = (weapon._FIRETIME - weapon._FIRE) / weapon._FIRETIME;
			if (temp < 0) { temp = 0; }
			if (temp > 0.9) { temp = 0.9; }
			player.FRAME = 1 + player._WALKFRAMES + player._RUNFRAMES + 1 + player._ATTACKFRAMES * temp;
		}
	*/
	}
	ELSE
	{
		SET weapon.INVISIBLE,OFF;
		MY_POS.X = weapon.SKILL1;
		MY_POS.Y = -weapon.SKILL2;
		MY_POS.Z = -weapon.SKILL3;
		IF (weapon._RECOIL > 0) {
			MY_POS.X -= weapon._DISPLACEMENT; }
		IF (player.__BOB == ON) {
			MY_POS.Y += headwave * WEAPON_AMPL;
			MY_POS.X += headwave * WEAPON_AMPL;
			MY_POS.Z -= headwave * WEAPON_AMPL;
		}

		CALL _set_pos_ahead_xyz;
		weapon.X = MY_POS.X ;
		weapon.Y = MY_POS.Y;
		weapon.Z = MY_POS.Z;
		weapon.PAN = CAMERA.PAN;
		weapon.TILT = CAMERA.TILT;
		IF (weapon._RECOIL < 0) {
			weapon.TILT -= weapon._DISPLACEMENT; }
	}
}

// fire weapon
ACTION weapon_fire {
	weapon_firing = 1;
 	WHILE (KEY_CTRL || MOUSE_LEFT) { WAIT 1; }
	weapon_firing = 0;
}

// deselect weapon
ACTION weapon_remove {
	IF (weapon != NULL) {
		SET weapon.INVISIBLE,ON;
		SET weapon,NULL;
		weapon_number = 0;
	}
}

// put weapons and ammo to inital state
ACTION weapon_init {
	CALL weapon_remove;
	ammo1 = 0;
	ammo2 = 0;
	ammo3 = 0;
	ammo4 = 0;
	weapon_1 = 0;
	weapon_2 = 0;
	weapon_3 = 0;
	weapon_4 = 0;
	weapon_5 = 0;
	weapon_6 = 0;
	weapon_7 = 0;
	weapon_number = 0;
}
//////////////////////////////////////////////////////////////////////

// Desc:
//
// Mod: 6/14/00 Doug Poston
//			Added a WAIT 1 so bullet does not collide with muzzle_flash
ACTION gun_fire
{
// anymore ammo?
	IF (MY._AMMOTYPE == 1) {
		IF (ammo1 > 0) { ammo1 -= 1; }
		ELSE { GOTO no_ammo; }
	}
	IF (MY._AMMOTYPE == 2) {
		IF (ammo2 > 0) { ammo2 -= 1; }
		ELSE { GOTO no_ammo; }
	}
	IF (MY._AMMOTYPE == 3) {
		IF (ammo3 > 0) { ammo3 -= 1; }
		ELSE { GOTO no_ammo; }
	}
	IF (MY._AMMOTYPE == 4) {
		IF (ammo4 > 0) { ammo4 -= 1; }
		ELSE { GOTO no_ammo; }
	}

   gun_loaded = 0;
// place muzzle flash
	IF ((person_3rd != 0) && (player != NULL)) {
		MY_POS.X = player.MAX_X - player.MIN_X;
		MY_POS.Y = 0;
		MY_POS.Z = 0;
	} ELSE {
		MY_POS.X = MY.SKILL1 + MY._OFFS_FLASH;
		MY_POS.Y = -MY.SKILL2;
		MY_POS.Z = -MY.SKILL3;
	}
	CALL _set_pos_ahead_xyz;
	gun_muzzle.X = MY_POS.X;
	gun_muzzle.Y = MY_POS.Y;
	gun_muzzle.Z = MY_POS.Z;
	CREATE muzzle_flash,gun_muzzle,_flashup;

	MY_POS.X = MY._BULLETSPEED;
	IF ((person_3rd != 0) && (player != NULL)) {
		MY_POS.Y = 0;
		MY_POS.Z = 0;
	} ELSE {
		MY_POS.Y = -MY.SKILL2;
		MY_POS.Z = -MY.SKILL3;
	}
	CALL _set_pos_ahead_xyz;
	gun_target.X = MY_POS.X;
	gun_target.Y = MY_POS.Y;
	gun_target.Z = MY_POS.Z;

// emit a bullet or particle
	shot_speed.X = (gun_target.X - gun_muzzle.X);
	shot_speed.Y = (gun_target.Y - gun_muzzle.Y);
	shot_speed.Z = (gun_target.Z - gun_muzzle.Z);

	damage = MY._DAMAGE;
	fire_mode = MY._FIREMODE;
	WAIT 1; // allow muzzle_flash to become passable (so bullet does not hit it!)
	CALL gun_shot;

	MY._FIRE = MY._FIRETIME;
	MY._DISPLACEMENT = MY._RECOIL;
	WHILE (MY._FIRE > 0) {
		WAIT 1;
 // rock back into place from recoil
		MY._DISPLACEMENT *= 0.6;
		MY._FIRE -= TIME;
	}
	MY._DISPLACEMENT = 0 ;
	MY._FIRE = 0 ;

	IF (MY.__REPEAT == ON) { gun_loaded = 1;}
	RETURN;

no_ammo:
	PLAY_ENTSOUND ME,gun_click,50;
}

// needs gun_muzzle,shot_speed,damage,fire_mode
//
// Mod:	6/14/00 Doug Poston
//			uses _hit_point_effect() for SHOOT bullets
// Mod:	6/14/00 Doug Poston
//			added placeholder for darkshot particles
//			when functions can take parameters, use a color para for particle_shot()
ACTION gun_shot
{
	IF ((fire_mode & MODE_FIRE) == FIRE_PARTICLE)
	{ EMIT 1,gun_muzzle,particle_shot; }

	IF ((fire_mode & MODE_FIRE) == FIRE_DPARTICLE)
	{ EMIT 1,gun_muzzle,particle_shot; }

	IF ((fire_mode & MODE_FIRE) == FIRE_BALL)
	{ CREATE fireball,gun_muzzle,bullet_shot; }

	IF ((fire_mode & MODE_FIRE) == FIRE_ROCKET)
	{ CREATE <rocket.mdl>,gun_muzzle,rocket_launch; }


	// bullet is
	IF ((fire_mode & MODE_DAMAGE) == DAMAGE_SHOOT)
	{
		gun_target.X = 2*shot_speed.X + gun_muzzle.X;
		gun_target.Y = 2*shot_speed.Y + gun_muzzle.Y;
		gun_target.Z = 2*shot_speed.Z + gun_muzzle.Z;

		indicator = _GUNFIRE;	// indicator for the entity that was hit
		SHOOT gun_muzzle,gun_target;

   	if (RESULT > 0)
		{ // hit something?
			_hit_point_effect();	// send fire_mode and TARGET
		}
	}
}

///////////////////////////////////////////////////////////////////////
// hit flash
ACTION _blowup
{
	MY.SCALE_X = 2;
	MY.SCALE_Y = 2;
	SET MY.PASSABLE,ON;
	SET MY.FACING,ON;
	SET MY.NEAR,ON;
	SET MY.FLARE,ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_flash.RED;
	MY.LIGHTGREEN = light_flash.GREEN;
	MY.LIGHTBLUE = light_flash.BLUE;
	MY.LIGHTRANGE = 64;
	WAIT 1;
	PLAY_ENTSOUND ME,hit_wham,300;
	REMOVE ME;
}

// muzzle flash
ACTION _flashup
{
	MY.SCALE_X = 2;
	MY.SCALE_Y = 2;
	SET MY.PASSABLE,ON;
// Set flare only in D3D mode
	IF (VIDEO_MODE > 8) { SET MY.FLARE,ON; }
	ELSE { SET MY.TRANSPARENT,ON; }

	SET MY.FACING,ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_muzzle.RED;
	MY.LIGHTGREEN = light_muzzle.GREEN;
	MY.LIGHTBLUE = light_muzzle.BLUE;
	MY.LIGHTRANGE = 100;
	WAIT 1;
	PLAY_SOUND gun_wham,50;
	REMOVE ME;
}


FUNCTION _fireball_event()
{
// check for all collision events
	IF (EVENT_TYPE == EVENT_BLOCK
		|| EVENT_TYPE == EVENT_ENTITY
		|| EVENT_TYPE == EVENT_STUCK
		|| EVENT_TYPE == EVENT_IMPACT
		|| EVENT_TYPE == EVENT_PUSH)
	{
		EXCLUSIVE_ENTITY;	// terminate other actions, to stop moving
		SET MY.EVENT,NULL;

 		range = MY._DAMAGE * 3;
		damage = MY._DAMAGE;
 		temp.PAN = 360;
		temp.TILT = 180;
		temp.Z = range;
		indicator = _EXPLODE;	// must always be set before scanning
		SCAN	MY.POS,MY_ANGLE,temp;

		MORPH BULLET_EXPLO,ME;
		MY._DIEFRAMES = EXPLO_FRAMES;
		CALL actor_explode;
	}
}


// Desc: event attached to rocket
//			Explode the rocket.
//
// Mod Date: 6/13/00 Doug Poston
//				Created
FUNCTION _rocket_event()
{
	EXCLUSIVE_ENTITY;	// terminate other actions, to stop moving
	SET MY.EVENT,NULL;
	MY.SKILL9 = -1;   // stop movement

  	// Explode
	MORPH <explo+7.pcx>, ME;
	MY.AMBIENT = 100;
	MY.FACING = ON;
	MY.NEAR = ON;
  	SET MY.FLARE,ON;

	SET MY.PASSABLE, ON;
	MY.AMBIENT = 100;
	MY.LIGHTRED = light_flash.RED;
	MY.LIGHTGREEN = light_flash.GREEN;
	MY.LIGHTBLUE = light_flash.BLUE;
	MY.LIGHTRANGE = 64;
	WAIT 1;
	PLAY_ENTSOUND ME,hit_wham,300;
	WHILE (MY.CYCLE <= 7)
	{
		MY.CYCLE += TIME;
		WAITT 1;
	}

	// Apply damage
	range = MY._DAMAGE * 6;
	damage = MY._DAMAGE;
 	temp.PAN = 360;
	temp.TILT = 360;
	temp.Z = range;
	indicator = _EXPLODE;	// must always be set before scanning
	SCAN	MY.POS,MY_ANGLE,temp;

	REMOVE ME;
}




// runs a bullet; requires shot_speed, damage, fire_mode to be set
ACTION bullet_shot
{
	SET MY.ENABLE_BLOCK,ON;
	SET MY.ENABLE_ENTITY,ON;
	SET MY.ENABLE_STUCK,ON;
	SET MY.ENABLE_IMPACT,ON;
	SET MY.ENABLE_PUSH,ON;
	SET MY.EVENT,_fireball_event;

	SET MY.FACING,ON;	// in case of fireball

	MY.LIGHTRED = light_bullet.RED;
	MY.LIGHTGREEN = light_bullet.GREEN;
	MY.LIGHTBLUE = light_bullet.BLUE;
	MY.LIGHTRANGE = 100;
	MY.AMBIENT = 100;

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

  	WHILE (MY.NEAR != ON) {	// my.near is set by the explosion
		WAIT 1; // wait at the loop beginning, to let it appear at the start position

		temp = TIME;
		IF (temp > 1.5) { temp = 1.5; }	// make bullet slower on slow PCs
// MOVE moves by a distance, so multiply the speed by time.
		fireball_speed.x = MY.SKILL2 * temp;
		fireball_speed.y = MY.SKILL3 * temp;
		fireball_speed.z = MY.SKILL4 * temp;

		IF ((MY._FIREMODE & BULLET_SMOKETRAIL) == BULLET_SMOKETRAIL) {
			temp = 3 * TIME;
			IF (temp > 6) { temp = 6; }	// generate max 6 particels
			EMIT temp,MY.POS,particle_fade; 	// smoke trail
		}

 		MOVE ME,nullskill,fireball_speed;
	}
}




// Desc: launch a rocket (models)
//
// Mod Date: 6/13/00 Doug Poston
//				Created
//
function rocket_launch()
{
 	SET MY.ENABLE_BLOCK, ON;      // collision with map surface
	SET MY.ENABLE_ENTITY, ON;     // collision with entity
 	SET MY.ENABLE_STUCK,ON;
	SET MY.ENABLE_IMPACT,ON;
	SET MY.ENABLE_PUSH,ON;
 	MY.EVENT = _rocket_event;

	MY.AMBIENT = 100;  // bright
	MY.LIGHTRANGE = 150;
	MY.LIGHTRED = 250;
	MY.LIGHTGREEN = 50;
	MY.LIGHTBLUE = 50;

 	MY.PAN = YOUR.PAN; // the rocket start in the same direction than this 'emitter'
 	MY.TILT = YOUR.TILT;
 	MY.ROLL = YOUR.ROLL;

	MY.SKILL2 = shot_speed.x;
	MY.SKILL3 = shot_speed.y;
	MY.SKILL4 = shot_speed.z;
	MY._DAMAGE = damage;
	MY._FIREMODE = fire_mode;

	MY.SKILL9 = 250; // 'burn time'  (fuel)
	WHILE (MY.SKILL9 > 0)
	{
		SPEED.X = MY.SKILL2 * TIME;
		SPEED.Y = MY.SKILL3 * TIME;
		SPEED.Z = MY.SKILL4 * TIME;
		MOVE ME, NULLSKILL, SPEED;


		EMIT 3,MY.POS,particle_smoke;	// EMIT smoke
		MY.SKILL9 -= TIME;  // burn fuel
		WAITT 1;     // update position once per tick
	}
	_rocket_event();   // explode when out of fuel
}




ACTION actor_explode
{
	SET MY.FACING,ON;	// face the camera
	SET MY.NEAR,ON;
	SET MY.FLARE,ON;
	SET MY.PASSABLE,ON;	// don't push the player through walls
	MY.FRAME = 1;
	WAIT	1;
	PLAY_ENTSOUND ME,explo_wham,1000;
	MY.LIGHTRED = light_explo.RED;
	MY.LIGHTGREEN = light_explo.GREEN;
	MY.LIGHTBLUE = light_explo.BLUE;
	MY.AMBIENT = 100;
	MY.LIGHTRANGE += 50;
// use the new sprite animation
	WHILE (MY.FRAME < MY._DIEFRAMES) {
		WAIT 1;
		MY.LIGHTRANGE += 15;
		MY.LIGHTRED += 20 * TIME;	// fade to red
		MY.LIGHTBLUE -= 20 * TIME;
		MY.FRAME += TIME;
	}
	WAIT 1;
	REMOVE ME;
}


// Desc: create a hit point 'effect' depending on (fire_mode & MODE_HIT) value
//
// Input:fire_mode
//			TARGET
//
// 		6/14/00 Doug Poston
//
function _hit_point_effect()
{
	// flash at hit point?
	IF ((fire_mode & MODE_HIT) == HIT_FLASH)
	{
		CREATE small_flash,TARGET,_blowup;
	}

	// smoke at hit point?
	IF (fire_mode & HIT_SMOKE)
	{
	 	EMIT 20,TARGET,particle_smoke;	// EMIT smoke
	}

	IF(fire_mode & HIT_SPARKS)
	{
		EMIT 20,TARGET,particle_scatter;	// EMIT sparks
	}

}

/////////////////////////////////////////////////////////////
ON_CTRL weapon_fire;
ON_MOUSE_LEFT weapon_fire;