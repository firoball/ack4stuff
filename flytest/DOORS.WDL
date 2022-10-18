// 6/20/00 Doug Poston
//			Added doorswitches
///////////////////////////////////////////////////	/////////////////////
// doors.wdl - doors, platforms, switches
////////////////////////////////////////////////////////////////////////
IFNDEF DOORS_DEF;
 SOUND gate_snd <gate.wav>;		// elevators
 SOUND open_snd <door_op.wav>;
 SOUND close_snd <door_cl.wav>;
 SOUND key_fetch <beamer.wav>;
 SOUND trigger_snd <click.wav>;
ENDIF;

IFNDEF DOORS_DEF2;
 SOUND teleport_snd <beamer.wav>;
ENDIF;
////////////////////////////////////////////////////////////////////////
// Strings for needing and picking up keys; can be redefined
STRING need_key1_str "Red key required";
STRING need_key2_str "Green key required";
STRING need_key3_str "Blue key required";
STRING need_key4_str "Silver key required";
STRING need_key5_str "Golden key required";
STRING need_key6_str "Black key required";
STRING need_key7_str "White key required";
STRING need_key8_str "Yet another key required";
STRING got_key1_str "Found a red key!";
STRING got_key2_str "Found a green key!";
STRING got_key3_str "Found a blue key!";
STRING got_key4_str "Found a silver key!";
STRING got_key5_str "Found a golden key!";
STRING got_key6_str "Found a black key!";
STRING got_key7_str "Found a white key!";
STRING got_key8_str "Found a yet another key!";

// These skills may not only be set by keys, but can also be set by
// dedicated actions, dialogues in adventures, and so on.
// If a key skill is set to 1, the door or elevator will work.
SKILL key1 { VAL 0; }
SKILL key2 { VAL 0; }
SKILL key3 { VAL 0; }
SKILL key4 { VAL 0; }
SKILL key5 { VAL 0; }
SKILL key6 { VAL 0; }
SKILL key7 { VAL 0; }
SKILL key8 { VAL 0; }


SKILL		temp_dist { VAL 0; }		// temp store a distance (used in range trigger)
SKILL		temp_dist2 { VAL 0; }		// temp store a distance (used in range trigger)
SYNONYM	temp_elevator	{ TYPE ENTITY; }  // store the current elevator  (dcp - changed from temp_ent because of name conflict in movement.wdl)

///////////////////////////////////////////////////////////////////////
DEFINE _ENDPOS_X,SKILL1;	// target position for elevator
DEFINE _ENDPOS_Y,SKILL2;
DEFINE _ENDPOS_Z,SKILL3;	// target height for elevator
DEFINE _ENDPOS,SKILL3;		// opening angle for doors
DEFINE _KEY,SKILL4;			// key number, 0 = no key needed
DEFINE _KEYTYPE,SKILL4;		// legacy
DEFINE _PAUSE,SKILL6;		// wait time at end positions
DEFINE _TRIGGER_RANGE,SKILL7;	// door/elevator may be triggered
DEFINE _SWITCH,SKILL8;		// remote switch number for operating (not yet implemented)

DEFINE _CURRENTPOS,SKILL9;
DEFINE _TRIGGERFRAME,SKILL10;	// Frame number of the last received trigger
DEFINE _STARTPOS_X,SKILL27;	// start position for elevator
DEFINE _STARTPOS_Y,SKILL28;
DEFINE _STARTPOS_Z,SKILL29;	// start height for elevator

DEFINE __ROTATE,FLAG1;	// key item rotates
DEFINE __SILENT,FLAG2;	// no message
DEFINE __REMOTE,FLAG6;	// platform can be remote started from the target position
DEFINE __GATE,FLAG7;		// elevator is a gate
DEFINE __LID,FLAG7;		// door is a lid (opens vertically)

DEFINE __MOVING,FLAG8;  // set during movement


//////////////////////////////////////////////////////////////////////////////////////////////////
var	doorswitch_states = 0;		// the states of each door switch (0-off, 1-on)


// Desc: the door switch event
//			if the _doorevent_check returns a valid value, set/reset (XOR)
//		  the doorswitch_states value using the switch's _SWITCH value
//
//	Date: 6/20/00
function doorswitch_event()
{
	_doorevent_check();
	IF (RESULT) { doorswitch_states ^= MY._SWITCH; }	// set/reset door switch
}
// Desc: action attached to door switch
//			can be used to active both doors and/or elevators
//
//	Date: 6/20/00
ACTION	doorswitch
{
	MY.EVENT = doorswitch_event;
	_doorevent_init();

	IF (MY._SWITCH == 0) { MY._SWITCH = 1; }	// default to switch 1

}

// Desc: Reset all the door switches
//
//	Date: 6/20/00
function	_doorswitch_reset_all ()
{
	doorswitch_states = 0;
}






// Desc: check the switch once every 24 ticks
//       if it's state has changed, activate
//
//	Date: 6/20/00
function	_elevator_use_switch()
{
	WHILE (1)
	{
		IF ((MY._SWITCH & doorswitch_states) != 0)
		{
			// state has changed (0->1), activate
			elevator_move();

			WHILE ((MY._SWITCH & doorswitch_states) != 0)
			{
				WAITT 24;
			}
			// state has changed (1->0), activate
			elevator_move();

		}
		WAITT 24;

	}
}

// Desc: check the switch once every 24 ticks
//       if it's state has changed, activate
//
//	Date: 6/20/00
function	_door_use_switch()
{
	WHILE (1)
	{
		IF ((MY._SWITCH & doorswitch_states) != 0)
		{
			// state has changed (0->1), activate
			_door_swing();

			WHILE ((MY._SWITCH & doorswitch_states) != 0)
			{
				WAITT 24;
			}
			// state has changed (1->0), activate
			_door_swing();

		}
		WAITT 24;

	}
}


////////////////////////////////////////////////////////////////////////
// Rotates an entity as long as it is visible and stays at the same place
ACTION ent_rotate
{
// by default, rotate horizontally
	IF ((MY.SKILL1 == 0) && (MY.SKILL2 == 0) && (MY.SKILL3 == 0)) {
		MY.SKILL1 = 3; }
//store the current position
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;
// rotate it als long as it isn't picked up
	WHILE (MY.INVISIBLE == OFF
		&& MY._STARTPOS_X == MY.X
		&& MY._STARTPOS_Y == MY.Y
		&& MY._STARTPOS_Z == MY.Z)
	{
		MY.PAN += MY.SKILL1*TIME;
		MY.TILT += MY.SKILL2*TIME;
		MY.ROLL += MY.SKILL3*TIME;
		WAIT	1;
	}
}

////////////////////////////////////////////////////////////////////////
// Key actions.

// rotate an item horizontally
ACTION item_rotate
{
//store the current position
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;
// rotate it als long as it isn't picked up
	WHILE (MY.INVISIBLE == OFF
		&& MY._STARTPOS_X == MY.X
		&& MY._STARTPOS_Y == MY.Y
		&& MY._STARTPOS_Z == MY.Z)
	{
		MY.PAN += 3*TIME;
		WAIT	1;
	}
}

// action to enable an entity to be picked up
ACTION item_pickup
{
	MY.PUSH = -1;
	SET MY.ENABLE_SCAN,ON;	// pick up pressing SPACE..
	SET MY.ENABLE_CLICK,ON;	// clicking with the mouse...
	SET MY.ENABLE_PUSH,ON;	// or touching the item

	IF (MY.__ROTATE == ON) { CALL item_rotate; }
}

// This entity must not look like a key at all...
ACTION key
{
	IF (MY._KEY == 0) { MY._KEY = 1; }
	SET MY.EVENT,_key_pickup;
	CALL item_pickup;
}

ACTION _key_pickup
{
	IF (EVENT_TYPE == EVENT_SCAN && indicator != _HANDLE) { RETURN; }
	IF (EVENT_TYPE == EVENT_PUSH && YOU != player) { RETURN; }

	IF (MY._KEY == 1) { key1 = 1; SET msg.STRING,got_key1_str; }
	IF (MY._KEY == 2) { key2 = 1; SET msg.STRING,got_key2_str; }
	IF (MY._KEY == 3) { key3 = 1; SET msg.STRING,got_key3_str; }
	IF (MY._KEY == 4) { key4 = 1; SET msg.STRING,got_key4_str; }
	IF (MY._KEY == 5) { key5 = 1; SET msg.STRING,got_key5_str; }
	IF (MY._KEY == 6) { key6 = 1; SET msg.STRING,got_key6_str; }
	IF (MY._KEY == 7) { key7 = 1; SET msg.STRING,got_key7_str; }
	IF (MY._KEY == 8) { key8 = 1; SET msg.STRING,got_key8_str; }
	IF (MY.__SILENT != ON) { CALL show_message; }
	PLAY_SOUND key_fetch,50;
	REMOVE ME;
}

// put keys to inital state
ACTION key_init
{
	key1 = 0;
	key2 = 0;
	key3 = 0;
	key4 = 0;
	key5 = 0;
	key6 = 0;
	key7 = 0;
	key8 = 0;
}

////////////////////////////////////////////////////////////////////////
// Teleporter action. Transports an entity to the SKILL1,2,3 position
// it touched. SKILL5 gives an angle.
ACTION teleporter
{
	SET MY.EVENT,_tele_event;
	SET MY.ENABLE_IMPACT,ON;
// enable operating on stepping onto (for platform teleporters)
	IF (MY._TRIGGER_RANGE == 1) {	SET MY.ENABLE_SONAR,ON; }
// enable mouse text
	IF (MY.STRING1 != NULL) { SET MY.ENABLE_TOUCH,ON; }
}

ACTION _tele_event
{
	CALL handle_touch;	// show mouse touch text, if any

// entity walked over it while performing SONAR, or touched it
	IF (EVENT_TYPE == EVENT_SONAR
		|| EVENT_TYPE == EVENT_IMPACT)
	{
		WAIT 1;	// the entity was already moving, so this must be finished before displacing it
		YOUR.X = MY.SKILL1;	// displace the entity
		YOUR.Y = MY.SKILL2;
		YOUR.Z = MY.SKILL3;
		YOUR.PAN = MY.SKILL5;
		CAMERA.AMBIENT += 30;	// a short flash
		PLAY_SOUND teleport_snd,50;
		WAITT 2;
		CAMERA.AMBIENT -= 20;
		WAITT 2;
		CAMERA.AMBIENT -= 10;
	}
}
////////////////////////////////////////////////////////////////////////
// Door action. Opens if a SCAN instruction was performed.
ACTION lid
{
	SET MY.__LID,ON;
	BRANCH door;
}

ACTION door
{
	SET MY.EVENT,door_event;
	CALL _doorevent_init;
	IF (MY._FORCE == 0) { MY._FORCE = 5; }
	IF (MY._ENDPOS == 0) { MY._ENDPOS = 90; }
}
/*
ACTION trigger_beep {
	SET	MY.EVENT,signal;
	SET	MY.ENABLE_TRIGGER,1;
	SET	MY.TRIGGER_RANGE,10;
	SET	MY.PASSABLE,1;
}
*/

ACTION door_event
{
	CALL _doorevent_check;
	IF (RESULT) { BRANCH _door_swing; }
}

// closes the door again if no trigger was received within the last 4 framesa second
ACTION _doorevent_close
{
	WAIT 4;
// close door of no trigger received again, and yet open and not moving
	IF ((TOTAL_FRAMES > MY._TRIGGERFRAME + 3)
		&& (MY._CURRENTPOS == MY._ENDPOS)
		&& (MY.__MOVING == OFF))
	{
		BRANCH _door_swing; }
}

ACTION _door_swing
{
	SET MY.__MOVING,ON;
// check whether to open or to close
	IF (MY._CURRENTPOS < MY._ENDPOS)
	{
		PLAY_ENTSOUND ME,open_snd,66;
		WHILE (MY._CURRENTPOS < MY._ENDPOS) {
			IF (MY.__LID == ON) {
				MY.ROLL += MY._FORCE*TIME;
			} ELSE {
				MY.PAN -= MY._FORCE*TIME;
			}
			MY._CURRENTPOS += ABS(MY._FORCE)*TIME;
			WAIT	1;
		}
		IF (MY.__LID == ON) {
			MY.ROLL -= MY._CURRENTPOS-MY._ENDPOS;
		} ELSE {
			MY.PAN += MY._CURRENTPOS-MY._ENDPOS;
		}
		MY._CURRENTPOS = MY._ENDPOS;
		IF (MY.__LID == ON) {
			SET MY.PASSABLE,ON;	// otherwise the player won't fit through
		}
	} ELSE {
		PLAY_ENTSOUND ME,close_snd,66;
		WHILE (MY._CURRENTPOS > 0) {
			IF (MY.__LID == ON) {
				MY.ROLL -= MY._FORCE*TIME;
			} ELSE {
				MY.PAN += MY._FORCE*TIME;
			}
			MY._CURRENTPOS -= ABS(MY._FORCE)*TIME;
			WAIT	1;
		}
		IF (MY.__LID == ON) {
			MY.ROLL -= MY._CURRENTPOS;
		} ELSE {
			MY.PAN += MY._CURRENTPOS;
		}
		MY._CURRENTPOS = 0;
		IF (MY.__LID == ON) {
			SET MY.PASSABLE,0;
		}
	}
	SET MY.__MOVING,OFF;
}

////////////////////////////////////////////////////////////////////////
//  elevator action
//
//	 Desc: set up the elevator
//
//
//  DCP - added ranged trigger (3/22/00)
//
//  DCP - changed recall trigger (3/27/00)
//
//  DCP - added _elevatorevent_init to resolve conflict in _doorevent_init (4/4/00)
ACTION elevator
{
	IF (MY._FORCE == 0) { MY._FORCE = 5; }
	IF (MY._ENDPOS_X == 0) { MY._ENDPOS_X = MY.X; }
	IF (MY._ENDPOS_Y == 0) { MY._ENDPOS_Y = MY.Y; }
	IF (MY._ENDPOS_Z == 0) { MY._ENDPOS_Z = MY.Z; }


	MY._TYPE = _TYPE_ELEVATOR;
	SET MY.EVENT,elevator_event;
	CALL _elevatorevent_init;       // DCP - changed from _doorevent_init


	// initialize the movement parameters of the elevator
	MY._STARTPOS_X = MY.X;
	MY._STARTPOS_Y = MY.Y;
	MY._STARTPOS_Z = MY.Z;

	MY._TARGET_X = MY._ENDPOS_X;
	MY._TARGET_Y = MY._ENDPOS_Y;
	MY._TARGET_Z = MY._ENDPOS_Z;


 	IF ((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
 	{
 		// create a remote trigger to recall elevator
   	CREATE <arrow.pcx>,MY._TARGET_X,_elevator_target;
 	}


	SET MY.__MOVING,OFF;


	// if it's a paternoster, start its movement action
	IF ((MY.__GATE == OFF) && (MY._PAUSE > 0))
	{
		WAITT MY._PAUSE;
		CALL elevator_move;
	}

}



// will open and close a gate vertically
ACTION gate
{
	SET MY.__GATE,ON;	// define a gate - very similar to an elevator
	MY._ENDPOS_Z = MY.Z + 0.9*(MY.MAX_Z - MY.MIN_Z);
	CALL elevator;
}

ACTION elevator_event
{
	CALL _doorevent_check;
	IF (RESULT) { BRANCH elevator_move; }
}

// Desc: handle ranged trigger events
ACTION _elevator_target_event
{
	// entity performed SCAN nearby (by pressing SPACE)
	IF ((EVENT_TYPE == EVENT_SCAN) && (indicator == _HANDLE))
	{
		SET MY,MY.ENTITY1;		// pretend that I'm the elevator
		BRANCH elevator_event;  // and received a SCAN myself
	}


// if we receive a trigger event...
	// DcP - NOTE: EVENT_CLICK ADDED TO TEST RECALL CODE (4/4/00)
	IF ((EVENT_TYPE == EVENT_TRIGGER) || (EVENT_TYPE == EVENT_CLICK))
	{
 		// check to see if the player is closer to the elevator or this trigger
		// calculate the distance squared to the trigger (You = player, me = trigger)
   	temp.X = YOUR.X - MY.X;
	  	temp.Y = YOUR.Y - MY.Y;
	  	temp.Z = YOUR.Z - MY.Z;

		TO_ANGLE temp_dist, temp;
		// DcP- replaced with TO_ANGLE
		//temp_dist.Z = (temp.X * temp.X) + (temp.Y * temp.Y) + (temp.Z * temp.Z);

 	  	SET ME,MY.ENTITY1;	   // become the elevator

		// calculate the distance squared to the elevator (You = player, me = elevator)
    	temp.X = YOUR.X - MY.X;
	  	temp.Y = YOUR.Y - MY.Y;
	  	temp.Z = YOUR.Z - MY.Z;
		TO_ANGLE temp_dist2, temp;

	   //	IF (temp_dist < ((temp.X * temp.X) + (temp.Y * temp.Y) + (temp.Z * temp.Z)))

	   // DcP - NOTE: These lines commented out to test trigger without compairing it to the elevator pos.
 		IF (temp_dist.Z < temp_dist2.Z)
 	  	{
			BRANCH elevator_event;	// activate the elevator
 	  	}
	}
}


// Desc: invisible target entity action to remote call the elevator
//
// this entity is linked to the calling entity through its ENTITY1 skill
// this entity uses the calling entity's _RECALL_TRIGGER_RANGE value
ACTION _elevator_target
{
 	SET MY.INVISIBLE,ON;
	SET MY.PASSABLE,ON;
 	SET MY.ENTITY1,YOU;	// store the adept_elevator synonym

	// ranged trigger is set here
	IF (YOUR._TRIGGER_RANGE > 1)
	{
		MY.TRIGGER_RANGE = YOUR._TRIGGER_RANGE;
   	SET MY.ENABLE_TRIGGER,ON;
	   // DcP - NOTE: EVENT_CLICK ADDED TO TEST RECALL CODE (4/4/00)
   	SET MY.ENABLE_CLICK,ON;
 	}

	// here the REMOTE must also be considered
	IF (YOUR.__REMOTE == ON)
	{
		SET MY.ENABLE_SCAN,ON;
	}

 	SET MY.EVENT,_elevator_target_event;
  	SET YOUR.ENTITY1,ME;	// link the calling entity (elevator) to this target
}



// Action - elevator_move
//
// DCP- added code to move 'triggers' to the opposite ends from the elevator  (3//22/00)
ACTION elevator_move
{
again:
	// start moving the elevator
	SET MY.__MOVING,ON;
	PLAY_ENTSOUND ME,gate_snd,66;


	// DCP - if we're using a remote trigger
	IF ((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		SET temp_elevator,MY.ENTITY1;   			// the ranged target
  		SET temp_elevator.ENABLE_SCAN,OFF;     // disable scan on this trigger
		SET temp_elevator.ENABLE_TRIGGER,OFF;  // disable range on this trigger
	}


	WHILE (MY.__MOVING == ON)
	{

		WAIT 1;			// DcP - moved wait to the start of this block, before the __MOVING flag is set to OFF

		// calculate the 3D direction to move to
		MY._SPEED_X = MY._TARGET_X - MY.X;
		MY._SPEED_Y = MY._TARGET_Y - MY.Y;
		MY._SPEED_Z = MY._TARGET_Z - MY.Z;

		// check the distance to the target position, using pythagoras
		temp = MY._SPEED_X*MY._SPEED_X + MY._SPEED_Y*MY._SPEED_Y + MY._SPEED_Z*MY._SPEED_Z;

		// we have now the square of the distance to the target,
		// and must compare it with the square of the distance to move
		IF (temp > MY._FORCE * TIME * MY._FORCE * TIME) {
			// if far, move with normal speed
			temp = MY._FORCE * TIME;
			NORMALIZE MY._SPEED,temp;	// adjust the speed vector's length
		} ELSE {	// if near, stop after moving the rest distance
			SET MY.__MOVING,OFF;
		}

  		MOVE	ME,NULLSKILL,MY._SPEED;	// move into that direction

		MY._SPEED_X = MY_SPEED.X;	// set the speed to the real distance covered
		MY._SPEED_Y = MY_SPEED.Y;	// for moving the player with the platform
		MY._SPEED_Z = MY_SPEED.Z;
	}

	MY._SPEED_X = 0;
	MY._SPEED_Y = 0;
	MY._SPEED_Z = 0;

	// at end position, reverse the direction
	IF (MY._TARGET_X == MY._ENDPOS_X
		&& MY._TARGET_Y == MY._ENDPOS_Y
		&& MY._TARGET_Z == MY._ENDPOS_Z )
	{
		MY._TARGET_X = MY._STARTPOS_X;
		MY._TARGET_Y = MY._STARTPOS_Y;
		MY._TARGET_Z = MY._STARTPOS_Z;
	} ELSE {
		MY._TARGET_X = MY._ENDPOS_X;
		MY._TARGET_Y = MY._ENDPOS_Y;
		MY._TARGET_Z = MY._ENDPOS_Z;
	}


	// DCP - if a ranged trigger is used,
   IF ((MY._TRIGGER_RANGE > 1) || (MY.__REMOTE == ON))
	{
		SET temp_elevator,MY.ENTITY1;   // the ranged target

		temp_elevator.X = MY._TARGET_X; // move the ranged target to the elevator's target point
	  	temp_elevator.Y = MY._TARGET_Y;
	  	temp_elevator.Z = MY._TARGET_Z;

  		IF (MY.__REMOTE == ON)
		{
			SET temp_elevator.ENABLE_SCAN,ON;    // re-activate the scan event
		}

		// ranged trigger is set here
		IF (MY._TRIGGER_RANGE > 1)
		{
	  		SET temp_elevator.ENABLE_TRIGGER,ON;         	// re-activate the trigger event
 		}
  	}


   // DcP - reset the elevator's _TRIGGERFRAME to the current TOTAL_FRAMES    (4/7/00)
	//
	//      _TRIGGERFRAME is used in _doorevent_check to allow the user time
	//      to step off the lift before accepting new SONAR events
	MY._TRIGGERFRAME = TOTAL_FRAMES;


	// if a gate or paternoster, close it or restart
	IF (((MY.__GATE == ON) && (MY._PAUSE > 0) && (MY.Z > MY._STARTPOS_Z))
		// close gate again
		|| ((MY.__GATE == OFF) && (MY._PAUSE > 0)))
	{
		// start paternoster in reverse direction
		WAITT MY._PAUSE;
		GOTO	again;
	}
}






////////////////////////////////////////////////////////////////////////
// helper actions for the events

// Desc: init the elevator
//
// DCP - Added this action because _doorevent_init caused conflicts with
//      remote trigger code (4/4/00)
//
// Mod:	6/20/00 Doug Poston
//			added switch activation
ACTION _elevatorevent_init
{
	SET MY.ENABLE_SCAN,ON;
	SET MY.ENABLE_CLICK,ON;

	// enable operating on stepping onto (for elevators)
	IF (MY._TRIGGER_RANGE > 0)
	{
		SET MY.ENABLE_SONAR,ON;
	}

	// enable mouse text
	IF (MY.STRING1 != NULL)
	{
		SET MY.ENABLE_TOUCH,ON;
	}

	MY._TRIGGERFRAME = 0;
	MY.PUSH = 10;	// move through the level blocks

	// if it is switch activated...
	IF (MY._SWITCH != 0)
	{
		_elevator_use_switch();
	}

}


// Mod:	6/20/00 Doug Poston
//			added switch activation
ACTION _doorevent_init
{
	SET MY.ENABLE_SCAN,ON;
	SET MY.ENABLE_CLICK,ON;

// enable triggering
	IF (MY._TRIGGER_RANGE >= 2) {
		SET MY.ENABLE_TRIGGER,ON;
		MY.TRIGGER_RANGE = MY._TRIGGER_RANGE;
	}

// enable operating on stepping onto (for elevators)
	IF (MY._TRIGGER_RANGE == 1) {
		SET MY.ENABLE_SONAR,ON;
	}

// enable mouse text
	IF (MY.STRING1 != NULL) {
		SET MY.ENABLE_TOUCH,ON;
	}

	MY._TRIGGERFRAME = 0;
	MY.PUSH = 10;	// move through the level blocks

	// if it is switch activated...
	IF (MY._SWITCH != 0)
	{
		_door_use_switch();
	}
}

// this action checks whether an event can operate the door or platform
ACTION _doorevent_check
{
	CALL handle_touch;	// show mouse touch text, if any

	IF (MY.__MOVING == ON) { GOTO ignore; }	// don't handle a moving door

// entity performed SCAN nearby (by pressing SPACE)
	IF ((EVENT_TYPE == EVENT_SCAN) && (indicator == _HANDLE))
		|| (EVENT_TYPE == EVENT_CLICK)
	{
		PLAY_SOUND trigger_snd,50;
		GOTO try_key;
	}

// player or entity with TRIGGER_RANGE walked nearby.
// trigger only opens the door, closing is automatically
	IF (EVENT_TYPE == EVENT_TRIGGER) {
// not already open, and no trigger since the last 2 frames ?
		IF ((MY._CURRENTPOS != MY._ENDPOS)
			&& (TOTAL_FRAMES > (MY._TRIGGERFRAME + 2)))
		{
			MY._TRIGGERFRAME = TOTAL_FRAMES;
			GOTO try_key;
		}
		MY._TRIGGERFRAME = TOTAL_FRAMES;
// each trigger starts an action which closes the door again
// if the triggering entity is outside range after some time
		CALL _doorevent_close;
	}

// entity walked over it while performing SONAR
// sonar starts the platform
	IF (EVENT_TYPE == EVENT_SONAR) {
// no sonar or trigger since the last 5 frames (this is to make sure the
// entity has walked off the platform before re-triggering)
		IF (TOTAL_FRAMES > (MY._TRIGGERFRAME + 5))
		{
		beep;   //@@@@@
			MY._TRIGGERFRAME = TOTAL_FRAMES;
			GOTO try_key;
		}

		MY._TRIGGERFRAME = TOTAL_FRAMES;
	}

// no operating condition happened, so tell the door not to move
ignore:
	RESULT = 0;
	RETURN;

try_key:
	IF ((MY._KEY == 1)&&(key1 == 0)) { SET msg.STRING,need_key1_str; GOTO message; }
	IF ((MY._KEY == 2)&&(key2 == 0)) { SET msg.STRING,need_key2_str; GOTO message; }
	IF ((MY._KEY == 3)&&(key3 == 0)) { SET msg.STRING,need_key3_str; GOTO message; }
	IF ((MY._KEY == 4)&&(key4 == 0)) { SET msg.STRING,need_key4_str; GOTO message; }
	IF ((MY._KEY == 5)&&(key5 == 0)) { SET msg.STRING,need_key5_str; GOTO message; }
	IF ((MY._KEY == 6)&&(key6 == 0)) { SET msg.STRING,need_key6_str; GOTO message; }
	IF ((MY._KEY == 7)&&(key7 == 0)) { SET msg.STRING,need_key7_str; GOTO message; }
	IF ((MY._KEY == 8)&&(key8 == 0)) { SET msg.STRING,need_key8_str; GOTO message; }

operate:
	RESULT = 1;
	RETURN;

message: // and don't operate
	IF (MY.__SILENT != ON) { CALL show_message; }
	RESULT = 0;
	RETURN;
}


///////////////////////////////////////////////////////////////////////