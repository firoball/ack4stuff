///////////////////////////////////////////////////////////////////////////////////
// WDL prefabs for entity movement
///////////////////////////////////////////////////////////////////////////////////
IFNDEF MOVE_DEFS;
 DEFINE DEFAULT_WALK,13.040;
 DEFINE DEFAULT_RUN,5.060;
ENDIF;

///////////////////////////////////////////////////////////////////////////////////
SKILL ladder_pl {}
SKILL jump_ready {VAL 1;}
SKILL jump_height {VAL 40;}
SKILL gnd_fric { VAL 0.5; }	// ground friction
SKILL air_fric { VAL 0.03; }	// air friction
SKILL ang_fric { VAL 0.6; }	// angular friction
SKILL gravity  { VAL 5; }		// gravity force
SKILL strength  { X 5; Y 4; Z 4; }	// ahead, side, jump strength
SKILL camera_dist	{ VAL 400; }
SKILL move_mode	{VAL 1;}

SKILL MOUSE_MODE {VAL 0;}
SKILL MOUSE_CALM {VAL 1;}
SKILL mouse_wait {VAL 0;}
///////////////////////////////////////////////////////////////////////
DEFINE BOTTOM,SKILL1;
DEFINE TOP,SKILL2;
DEFINE PLAYER_X,SKILL3;
DEFINE PLAYER_Y,SKILL4;

DEFINE _WALKFRAMES,SKILL1;
DEFINE _RUNFRAMES,SKILL2;
DEFINE _ATTACKFRAMES,SKILL3;
DEFINE _DIEFRAMES,SKILL4;
DEFINE _MOVEMODE,SKILL17;

DEFINE FULLARMOR,SKILL30;
DEFINE HEALTH,SKILL31;
DEFINE LIVES,SKILL32;
DEFINE WEAPON,SKILL33;
DEFINE SCORE,SKILL34;
DEFINE HELMET,SKILL35;
DEFINE ARMOR,SKILL36;

///////////////////////////////////////////////////////////////////////
DEFINE _ENTSPEED,SKILL11;		// speed
DEFINE _ENTSPEED_X,SKILL11;
DEFINE _ENTSPEED_Y,SKILL12;
DEFINE _ENTSPEED_Z,SKILL13;
DEFINE _ENTASPEED,SKILL14;		// angular speed
DEFINE _ENTASPEED_PAN,SKILL14;
DEFINE _ENTASPEED_TILT,SKILL15;
DEFINE _ENTASPEED_ROLL,SKILL16;

DEFINE _WALKDIST,SKILL21;
DEFINE _RUNDIST,SKILL22;


///////////////////////////////////////////////////////////////////////
SKILL force	{}		// cartesian force, entity coordinates
SKILL absforce	{}	// cartesian force, world coordinates
SKILL aforce	{}	// angular force
SKILL speed    { X 0; Y 0; Z 0; }	// cartesian speed, entity coordinates
SKILL abspeed  { X 0; Y 0; Z 0; }	// cartesian speed, world coordinates
SKILL aspeed	{}	// angular speed
SKILL p	{}
SKILL friction {}

SKILL my_dist 	{}		// covered distance
SKILL my_height	{}
SKILL my_floornormal	{}

SYNONYM player { TYPE ENTITY; }
SYNONYM ladder { TYPE ENTITY; }
SYNONYM player1_armor {TYPE ENTITY;}
SYNONYM player1_helmet {TYPE ENTITY;}
SYNONYM player1_weapon {TYPE ENTITY;}

DEFINE _MODE_WALKING,1;
DEFINE _MODE_CLIMBWAIT,5;
DEFINE _MODE_CLIMBING,6;

///////////////////////////////////////////////////////////////////////
ACTION player_walk {
	SET MY.FAT,OFF;
	SET MY.NARROW,ON;
	MY._MOVEMODE = _MODE_WALKING;
	MY.HEALTH=100;
	MY.LIVES=3;
	CALL player_move;
}

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
ACTION player_move {
	SET player,ME;
	SET MY.ENABLE_SCAN,ON;	// so that enemies can detect me

	IF (MY._MOVEMODE == 0) { MY._MOVEMODE = _MODE_WALKING; }
	IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = DEFAULT_WALK; }
	IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = DEFAULT_RUN; }
	CALL anim_init;

	WHILE (MY._MOVEMODE > 0)
	{
	IF (move_mode!=1) {GOTO skip_move;}


// Get the angular and translation forces
		CALL	_player_force;
// find ground below
		CALL  _scan_floor;

	IF (MY.Z<ladder.BOTTOM+2 && force.X<0 && MY._MOVEMODE==_MODE_CLIMBING) {
		MY._MOVEMODE=_MODE_WALKING;
		MY.X=ladder.PLAYER_X;
		MY.Y=ladder.PLAYER_Y;
		force.X=0;
		force.Z=0;
//arrived bottom of ladder
	}
	IF (MY.Z-5>ladder.TOP && MY._MOVEMODE==_MODE_CLIMBING) {
		MY._MOVEMODE=_MODE_CLIMBWAIT;
		force.X=0;
		force.Z=0;
//arrived on top of ladder
	}

		ACCEL	MY._ENTASPEED,aforce,ang_fric;

		IF (MY._MOVEMODE!=_MODE_CLIMBING) {MY.PAN += MY._ENTASPEED_PAN;}
//disable panning on ladder
		MY.ROLL += MY._ENTASPEED_ROLL;

// Decide wether the actor is on the floor or not
		IF (my_height < 2 && force.Z > 0 && jump_ready>=4) {
			jump_ready=0;
			force.Z *= 5;
		} ELSE {
			force.Z = 0;
		}
		IF (_PLAYER_JUMP!=0 && MY._MOVEMODE==_MODE_WALKING) {
			temp.PAN=40;
			temp.TILT=35;
			temp.Z=100;
	
			MY_ANGLE.PAN=90;
			MY_ANGLE.TILT=0;
			SCAN player.POS,MY_ANGLE,temp;
		}
		IF (_PLAYER_JUMP==0) {jump_ready+=TIME;}
//after releasing jump button, ready for next jump after a few ticks

		CALL  move_gravity;
		IF (MY._MOVEMODE == _MODE_WALKING) {
			CALL actor_anim;

		}
		CALL move_view;
		IF (player1_armor!=NULL) {
			player1_armor.X=PLAYER.X;
			player1_armor.Y=PLAYER.Y;
			player1_armor.Z=PLAYER.Z;
			player1_armor.PAN=PLAYER.PAN;
			player1_armor.TILT=PLAYER.TILT;
			player1_armor.ROLL=PLAYER.ROLL;
			player1_armor.FRAME=PLAYER.FRAME;
		}
		IF (player1_helmet!=0) {
			player1_helmet.X=PLAYER.X;
			player1_helmet.Y=PLAYER.Y;
			player1_helmet.Z=PLAYER.Z;
			player1_helmet.PAN=PLAYER.PAN;
			player1_helmet.TILT=PLAYER.TILT;
			player1_helmet.ROLL=PLAYER.ROLL;
			player1_helmet.FRAME=PLAYER.FRAME;
		}
		IF (player1_weapon!=0) {
			player1_weapon.X=PLAYER.X;
			player1_weapon.Y=PLAYER.Y;
			player1_weapon.Z=PLAYER.Z;
			player1_weapon.PAN=PLAYER.PAN;
			player1_weapon.TILT=PLAYER.TILT;
			player1_weapon.ROLL=PLAYER.ROLL;
			player1_weapon.FRAME=PLAYER.FRAME;
		}
		player.FULLARMOR=player.ARMOR+player.HELMET;
skip_move:
		WAIT	1;
	}
}


/////////////////////////////////////////////////////////////////////
ACTION move_gravity {
// Decide whether the actor is standing on the floor or not
	IF (my_height < 5 || MY._MOVEMODE==_MODE_CLIMBING || MY._MOVEMODE==_MODE_CLIMBWAIT) {
		friction = gnd_fric;
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = 0;
	} ELSE {
		friction = air_fric;
		force.X *= 0.2;
		force.Y = 0;
		force.Z = 0;
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z = -gravity;
		IF (my_height-gravity<0) {
			absforce.Z=gravity-my_height;
		}
	}

	IF (MY._MOVEMODE==_MODE_CLIMBING || MY._MOVEMODE==_MODE_CLIMBWAIT) {
		force.Z=force.X;
		force.X=0;
		force.Y=0;
		absforce.X = 0;
		absforce.Y = 0;
		absforce.Z= 0;
// accelerate the entity relative speed by the force
	speed.X = 0;
	speed.Y = 0;
	speed.Z = MY._ENTSPEED_Z;
	ACCEL	speed,force,friction;
#	MY._ENTSPEED_X = speed.X;
#	MY._ENTSPEED_Y = speed.Y;
	MY._ENTSPEED_Z = speed.Z;

// Add the world gravity force
	abspeed.X = 0;
	abspeed.Y = 0;
	abspeed.Z = 0;
	ACCEL	abspeed,absforce,friction;
} ELSE {

// accelerate the entity relative speed by the force
	speed.X = MY._ENTSPEED_X;
	speed.Y = MY._ENTSPEED_Y;
	speed.Z = 0;
	ACCEL	speed,force,friction;
	MY._ENTSPEED_X = speed.X;
	MY._ENTSPEED_Y = speed.Y;

// Add the world gravity force
	abspeed.X = 0;
	abspeed.Y = 0;
	abspeed.Z = MY._ENTSPEED_Z;
	ACCEL	abspeed,absforce,friction;
	IF (my_height < 5) {
		temp = my_height;
		IF (temp < -10)  { temp = -10; }
		abspeed.Z = force.Z-temp;
	}

	IF ((abspeed.Z > 0) && (abspeed.Z + my_height > jump_height)) {
		abspeed.Z = jump_height - my_height;
		IF (abspeed.Z < 0) { abspeed.Z = 0; }
	}
MY._ENTSPEED_Z = abspeed.Z;
}

SET YOU,NULL; 
MOVE ME,speed,abspeed;
my_dist = SQRT(MY_SPEED.X*MY_SPEED.X + MY_SPEED.Y*MY_SPEED.Y);
}


ACTION anim_init {
	temp = FRC(MY._WALKFRAMES) * 1000;
	IF (temp == 0) { temp = 40; }
	MY._WALKFRAMES = INT(MY._WALKFRAMES);
	IF (MY._WALKFRAMES == 0) { MY._WALKFRAMES = 13; }
	MY._WALKDIST = MY._WALKFRAMES / temp;

	temp = FRC(MY._RUNFRAMES) * 1000;
	IF (temp == 0) { temp = 60; }
	MY._RUNFRAMES = INT(MY._RUNFRAMES);
	IF (MY._RUNFRAMES == 0) { MY._RUNFRAMES = 5; }
	MY._RUNDIST = MY._RUNFRAMES / temp;
}

// Animate a walking actor
ACTION actor_anim {
	IF (my_dist == 0) {
		MY.FRAME = 1;	// standing
		END;
	}

	IF (my_dist < 12*TIME)	// Walking
	{
		IF (MY.FRAME < 2) { MY.FRAME = 2; }

		MY.FRAME += MY._WALKDIST*my_dist;

// this is one of the expert exceptions where you can use WHILE without WAIT!
		WHILE (MY.FRAME >= 2 + MY._WALKFRAMES) {
// cycle animation
			MY.FRAME -= MY._WALKFRAMES;
		}

		IF (MY.FRAME > 1 + MY._WALKFRAMES*0.5) {
// sound for left foot
		}

IFDEF ACKNEX_VERSION412;
		IF (MY.FRAME > 1 + MY._WALKFRAMES) {
			MY.NEXT_FRAME = 2;	// inbetween to the first frame
		} ELSE {
			MY.NEXT_FRAME = 0;	// inbetween to the real next frame
		}
ENDIF;

		END;
	}
	ELSE {	// Running
		IF (MY.FRAME < 2 + MY._WALKFRAMES) { MY.FRAME = 2 + MY._WALKFRAMES; }

		MY.FRAME += MY._RUNDIST*my_dist;

		WHILE (MY.FRAME >= 2 + MY._WALKFRAMES + MY._RUNFRAMES) {
			MY.FRAME -= MY._RUNFRAMES;
		}

		IF (MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES*0.5) {
		}

IFDEF ACKNEX_VERSION412;
		IF (MY.FRAME > 1 + MY._WALKFRAMES + MY._RUNFRAMES) {
			MY.NEXT_FRAME = 2 + MY._WALKFRAMES;	// inbetween to the first frame
		} ELSE {
			MY.NEXT_FRAME = 0;	// inbetween to the real next frame
		}
ENDIF;

		END;
	}
}

///////////////////////////////////////////////////////////////////////
ACTION move_view {
	CAMERA.DIAMETER = 0;		// make the camera passable
	SET CAMERA.GENIUS,ME;

	IF (_ZOOM_IN!=0 || MOUSE_LEFT!=0) {
		camera_dist-=8*TIME;
		IF (camera_dist < 200) {
			camera_dist=200;
		}
	}
	IF (_ZOOM_OUT!=0|| MOUSE_RIGHT!=0) {
		camera_dist+=8*TIME;
		IF (camera_dist > 400) {
			camera_dist=400;
		}
	}

	IF (MOUSE_MOVING==0) {	
		mouse_wait+=TIME;
		IF (mouse_wait >=30) {
			CAMERA.PAN=55;
			CAMERA.TILT = -13;
			mouse_wait=0;
		}
	} ELSE {
		mouse_wait=0;
	}

	camera.PAN+=MICKEY.X;
	camera.TILT+=MICKEY.Y;

	IF (camera.PAN<35) {camera.PAN=35;}
	IF (camera.PAN>145) {camera.PAN=145;}
	IF (camera.TILT<-25) {camera.TILT=-25;}
	IF (camera.TILT>25) {camera.TILT=25;}

	CAMERA.X=player.X-camera_dist*COS(CAMERA.PAN);
	CAMERA.Y=player.Y-camera_dist*SIN(CAMERA.PAN);
	CAMERA.Z=(player.Z+10)-camera_dist*TAN(CAMERA.TILT);		

}


ACTION _player_intentions {
	IF (MY._MOVEMODE==_MODE_WALKING) {
		force.X = 1*strength.X*(_PLAYER_RIGHT-_PLAYER_LEFT);
		IF (force.X>0) {
			IF (player.PAN!=0) {player.PAN=0;}
		}
		IF (force.X<0) {
			IF (player.PAN!=180) {player.PAN=180;}
			force.X*=-1;
		}
		force.Z = strength.Z*(_PLAYER_JUMP);
	} 
	IF (MY._MOVEMODE==_MODE_CLIMBING) {
		force.X=strength.Z*(_PLAYER_UP-_PLAYER_DOWN);
	}
	IF (MY._MOVEMODE==_MODE_CLIMBWAIT) {
		force.X=-strength.Z*_PLAYER_DOWN;
		force.Z = 1*strength.X*(_PLAYER_RIGHT-_PLAYER_LEFT);
		IF (force.Z>0 && force.X==0) {
			IF (player.PAN!=0) {player.PAN=0;}
		}
		IF (force.Z<0 && force.X==0) {
			IF (player.PAN!=180) {player.PAN=180;}
		}
		IF (force.Z!=0 && force.X==0) {
			player.X=ladder.PLAYER_X+30*COS(player.PAN);
			player.Y=ladder.PLAYER_Y+30*SIN(player.PAN);
			MY._MOVEMODE=_MODE_WALKING;
		}
		force.Z=0;
		IF (force.X<0) {
			MY._MOVEMODE=_MODE_CLIMBING;
			MY.Z-=15;
		}
	}		
}

ACTION _player_force {
		CALL _player_intentions;
		aforce.PAN *= 0.75;
		aforce.TILT *= 0.75;
		aforce.ROLL *= 0.75;
		force.X *= 0.75;
		force.Y *= 0.75;
		force.Z *= 0.75;
}

/////////////////////////////////////////////////////////////////////
// Auxiliary actions

ACTION _scan_floor {
	SONAR	ME,4000;
	my_floornormal.X = NORMAL.X;
	my_floornormal.Y = NORMAL.Y;
	my_floornormal.Z = NORMAL.Z;
	my_height = RESULT;
}

// Calculate a position directly ahead of the camera
// Input:  p (distance)
// Output: MY_POS
ACTION set_pos_ahead {
	temp.X = COS(CAMERA.PAN);
	temp.Y = SIN(CAMERA.PAN);
	temp.Z = p*COS(CAMERA.TILT);
	MY_POS.X = CAMERA.X + temp.Z*temp.X;
	MY_POS.Y = CAMERA.Y + temp.Z*temp.Y;
	MY_POS.Z = CAMERA.Z + p*SIN(CAMERA.TILT);
}

/////////////////////////////////////////////////////////////////////