// 6/14/00 Doug Poston
//	Added function "particle_smoke()"
/////////////////////////////////////////////////////////////////////////
//	WDL prefabs for particles
/////////////////////////////////////////////////////////////////////////
// Some common definitions

// bitmap used for sparks
BMAP spark_map,<particle.pcx>;
// bitmap used for smoke
BMAP smoke_map, <blitz.pcx>;

SKILL scatter_color 		{ RED 250; GREEN 250; BLUE 250; }
SKILL scatter_range 		{ RED -100; GREEN -245; BLUE -245; }
SKILL scatter_lifetime	{ VAL 50; }
SKILL scatter_size		{ VAL 100; }
IFDEF ACKNEX_VERSION414;
SKILL scatter_gravity	{ VAL 0.25; }
SKILL scatter_spread		{ VAL 6; }
IFELSE;
SKILL scatter_gravity	{ VAL 4; }
SKILL scatter_spread		{ VAL 100; }
ENDIF;
/////////////////////////////////////////////////////////////////////////
SYNONYM scatter_map { TYPE BMAP; DEFAULT spark_map; }
SKILL particle_pos {}
SKILL particle_speed {}
SKILL scatter_speed { X 0; Y 0; Z 0; }

/////////////////////////////////////////////////////////////////////////
// The particle_fade action lets a particle fade away

SKILL fade_lifetime	{ VAL 8; }
SKILL fade_color 		{ RED 255; GREEN 200; BLUE 0; }
SKILL fade_targetcolor 	{ RED 128; GREEN 128; BLUE 128; }

ACTION particle_fade {
	IF (MY_AGE == 0) {	// just born?
		MY_SIZE = 100;
		MY_SPEED.X = RANDOM(2)-1;
		MY_SPEED.Y = RANDOM(2)-1;
		MY_SPEED.Z = RANDOM(2)-1;
		MY_COLOR.RED = fade_color.RED;
		MY_COLOR.GREEN = fade_color.GREEN;
		MY_COLOR.BLUE = fade_color.BLUE;
	} ELSE {
		MY_COLOR.RED += (fade_targetcolor.RED - MY_COLOR.RED)*0.2;
		MY_COLOR.GREEN += (fade_targetcolor.GREEN - MY_COLOR.GREEN)*0.2;
		MY_COLOR.BLUE += (fade_targetcolor.BLUE - MY_COLOR.BLUE)*0.2;

		IF (MY_AGE > fade_lifetime) { SET MY_ACTION,NULL; }
	}
}
/////////////////////////////////////////////////////////////////////////
// The particle_tumble action lets a particle tumble around
// for 0.5 seconds, then disappear.

SKILL tumble_lifetime	{ VAL 8; }

ACTION particle_tumble {
	IF (MY_AGE == 0) {	// just born?
		MY_SPEED.X = RANDOM(0.3)-0.15;
		MY_SPEED.Y = RANDOM(0.3)-0.15;
		MY_SPEED.Z = RANDOM(0.3)-0.15;

		MY_SIZE = 30;
		MY_COLOR.RED = scatter_color.RED * 0.75;
		MY_COLOR.GREEN = scatter_color.GREEN * 0.3;
		MY_COLOR.BLUE = scatter_color.BLUE * 0.3;
	}
	IF (MY_AGE > tumble_lifetime) {
		SET MY_ACTION,NULL;
	}
}

/////////////////////////////////////////////////////////////////////////
// The particle_scatter action will scatter particles in all directions,
// then let them fall to the ground.
//
// Mod: 6/15/00  Doug Poston
//		Modified MY_SPEED spread (more even)
ACTION particle_scatter
{
	// just born?
	IF (MY_AGE == 0)
	{
		MY_SPEED.X = scatter_speed.X + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Y = scatter_speed.Y + RANDOM(scatter_spread) - (scatter_spread/2);
		MY_SPEED.Z = scatter_speed.Z + RANDOM(scatter_spread) - (scatter_spread/2);

		MY_SIZE = scatter_size;
		MY_COLOR.RED = scatter_color.RED;
		MY_COLOR.GREEN = scatter_color.GREEN;
		MY_COLOR.BLUE = scatter_color.BLUE;
		SET MY_MAP,scatter_map;
//		SET MY_FLARE,ON;	//$$$
		RETURN;
	}
	// Add gravity
	MY_SPEED.Z -= scatter_gravity;
	// Maybe add random term to age
	//	MY_AGE += RANDOM(0.05);

	IF (MY_AGE >= scatter_lifetime) {
		SET MY_ACTION,NULL;
	}
}

// The same, but with a particle trace behind
ACTION particle_traces {
	CALL particle_scatter;
// A particle itself may EMIT further particles
	EMIT 1,MY_POS,particle_tumble;
}

// The same, but with a color range
ACTION particle_range {
	CALL particle_scatter;
	IF (MY_AGE > 0) {
		MY_COLOR.RED += scatter_range.RED*MY_AGE/scatter_lifetime;
		MY_COLOR.GREEN += scatter_range.GREEN*MY_AGE/scatter_lifetime;
		MY_COLOR.BLUE += scatter_range.BLUE*MY_AGE/scatter_lifetime;
	}
}

// The same, but emits a sphere, with color range
ACTION particle_sphere {
	CALL particle_scatter;
	IF (MY_AGE == 0) {
		NORMALIZE MY_SPEED,scatter_spread;
	} ELSE {
		MY_COLOR.RED += scatter_range.RED*MY_AGE/scatter_lifetime;
		MY_COLOR.GREEN += scatter_range.GREEN*MY_AGE/scatter_lifetime;
		MY_COLOR.BLUE += scatter_range.BLUE*MY_AGE/scatter_lifetime;
	}
}

// This action may be called to initalize the scattering
//
// Mod Date: 6/29/00 JCL
//          Fixed scatter_speed
function scatter_init()
{
	vec_set(particle_pos,MY.X);
	vec_set(scatter_speed,NULLVECTOR); // no offset here!
}


/////////////////////////////////////////////////////////////////////////
// The particle_shot action lets a particle fly in shot_speed
// direction for 2 seconds, then disappear.

SKILL shot_lifetime	{ VAL 32; }
SKILL shot_speed		{ }

ACTION particle_shot {
	IF (MY_AGE == 0) {	// just born?
		MY_SPEED.X = shot_speed.X;
		MY_SPEED.Y = shot_speed.Y;
		MY_SPEED.Z = shot_speed.Z;
		MY_SIZE = 100;
		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 0;
		MY_COLOR.BLUE = 200;
	}
	IF (MY_AGE > shot_lifetime) {
		SET MY_ACTION,NULL;
	}
}

/////////////////////////////////////////////////////////////////
SKILL rain_mode { VAL 0; }
SKILL rain_pos { }
SKILL rain_rate { VAL 20; }	// snowflakes per second
SKILL rain_counter { }

// start snowfall around the player
// original idea by Harald Schmidt
ACTION snowfall
{
	IF (player == NULL) { END; }

	rain_mode = 1;
	WHILE (rain_mode > 0)
	{
// all snowflakes will start 50 quants above the player
		rain_pos.Z = player.Z + player.MAX_Z + 50;

//	depending on the frame rate, create several snow flakes at the same time
		rain_counter = rain_rate * TIME;
		WHILE (rain_counter > 0)
		{
// place snowflake somewhere near the player
			rain_pos.X = player.X + RANDOM(500) - 250;
			rain_pos.Y = player.Y + RANDOM(500) - 250;
// now create one flake (EMIT 1) at this position
			EMIT 1,rain_pos,particle_rain;
			rain_counter -= 1;
		}
		WAIT 1;
	}
}

ACTION particle_rain
{
// just born?
	IF (MY_AGE == 0)
	{  // this simple snow should do nothing more than fall to earth
		MY_SPEED.X = 0;
		MY_SPEED.Y = 0;
		MY_SPEED.Z = -2; // experiment with this value

// Set the size and colour you want (or maybe a bitmap)
		MY_SIZE = 100;
		MY_COLOR.RED = 255;
		MY_COLOR.GREEN = 255;
		MY_COLOR.BLUE = 255;
		END;
	}

// remove flake if below player's feet
 	IF ((player == NULL) || (MY_POS.Z < player.Z - 100))
	{
		SET MY_ACTION,NULL;
	}
}


// Desc: smoke particle
//      slowly raise (+Z) and drifts (+/- X & Y) while increasing size
//    	6/14/00 Doug Poston
//
function particle_smoke()
{
	// just born?
	IF (MY_AGE == 0)
	{
		MY_SPEED.X = random(1)-0.5;	// -0.5 to +0.5
		MY_SPEED.Y = random(2)-1;     // -1 to +1
		MY_SPEED.Z = random(1)+1;     // +1 to +2

		MY_SIZE = random(25)+25; // 25 to 50 in size

  		MY_MAP = smoke_map;
		MY_FLARE = ON;
		MY_COLOR.RED = 245;
		MY_COLOR.GREEN = 200;
		MY_COLOR.BLUE = 80;

		RETURN;
	}

	// increase the size of the smoke particle (up to max)
	IF (my_size < 800)
	{
 		MY_SIZE += (1000 - MY_SIZE)*0.1*TIME;
	}

	// Remove old particles
	IF (MY_AGE >= 35)
	{
  		MY_ACTION = NULL;
	}
}