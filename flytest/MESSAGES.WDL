//////////////////////////////////////////////////////////////////////
// WDL prefabs for displaying messages
//////////////////////////////////////////////////////////////////////
IFNDEF MSG_DEFS;
 FONT standard_font,<ackfont.pcx>,6,9;

 DEFINE MSG_X,4;		// from left
 DEFINE MSG_Y,4;		// from above
 DEFINE BLINK_TICKS,6;	// msg blinking period
 DEFINE MSG_TICKS,64;	// msg appearing time
 DEFINE msg_font,standard_font;
 SOUND msg_sound,<msg.wav>;

 DEFINE PANEL_POSX,4;	// health panel from left
 DEFINE PANEL_POSY,-20;	// from below
 FONT digit_font,<digfont.pcx>,12,16;	// ammo/health font
ENDIF;

IFNDEF MSG_DEFS2;
 DEFINE SCROLL_X,4;		// scroll text from left
 DEFINE SCROLL_Y,4;		// from above
 DEFINE SCROLL_LINES,4;	// maximum 8;
ENDIF;

IFNDEF MSG_DEFS3;
 DEFINE HEALTHPANEL,game_panel;	// default health/ammo panel

 DEFINE touch_font,standard_font;
 DEFINE touch_sound,msg_sound;
ENDIF;

//////////////////////////////////////////////////////////////////////
SKILL msg_counter	{ VAL 0; }
STRING empty_str,
 "                                                                    ";
STRING temp_str,
 "                                                                    ";

TEXT msg {
	POS_X MSG_X;
	POS_Y MSG_Y;
	FONT	msg_font;
	STRING empty_str;
}

//////////////////////////////////////////////////////////////////////
// To display a message string for 5 seconds, perform the instructions
// SET msg.STRING,message_string; CALL show_message;

ACTION show_message {
//	SET ME,NULL;		// prevent stopping action by removing an entity
	EXCLUSIVE_GLOBAL;		// stop previous show_message action
	PLAY_SOUND 	msg_sound,66;
	SET	msg.VISIBLE,ON;
	WAITT	MSG_TICKS;
	SET	msg.STRING,empty_str;
	SET	msg.VISIBLE,OFF;
}

// The same, but message will blink
ACTION blink_message {
//	SET ME,NULL;
	EXCLUSIVE_GLOBAL;
	PLAY_SOUND 	msg_sound,66;
	msg_counter = MSG_TICKS;
	WHILE (msg_counter > 0)
	{
		IF (msg.VISIBLE == ON) {
			SET	msg.VISIBLE,OFF;
		} ELSE {
			SET	msg.VISIBLE,ON;
		}
		WAITT	BLINK_TICKS;
		msg_counter -= BLINK_TICKS;
	}
	SET	msg.STRING,empty_str;
	SET	msg.VISIBLE,OFF;
}


//////////////////////////////////////////////////////////////////////
// actions for scrolling messages
//////////////////////////////////////////////////////////////////////
STRING message_str,
 "                                                                    ";
TEXT enter_txt {
	FONT	msg_font;
	STRING message_str;
}

TEXT scroll {
	POS_X MSG_X;
	POS_Y MSG_Y;
	FONT	msg_font;
	STRINGS 8;
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	STRING "                                                           ";
	INDEX SCROLL_LINES;
}

SYNONYM scroll_string { TYPE STRING; }

// scroll message upwards while adding a line
ACTION scroll_message {
	PLAY_SOUND 	msg_sound,66;
	SET scroll.VISIBLE,1;
	temp = 1; SET scroll.INDEX,temp;	// INDEX must be set by SET
	WHILE (temp <= SCROLL_LINES)
	{
// this can be used to study the difference between SET and SET_STRING
		SET scroll_string,scroll.STRING;
// now scroll_string is a synonym for the scroll string # (INDEX)
		temp += 1; SET scroll.INDEX,temp;
// now copy scroll string # (INDEX + 1) to scroll string # INDEX, i.e. upwards
		SET_STRING scroll_string,scroll.STRING;
	}
  	SET scroll.INDEX,SCROLL_LINES;
	SET_STRING scroll.STRING,empty_str;
}

IFDEF ACKNEX_VERSION414;
STRING joined_str," joined";

ACTION msg_join {
	SET_STRING temp_str,MESSAGE;
	ADD_STRING temp_str,joined_str;
	SET_STRING scroll.STRING,temp_str;
	CALL scroll_message;
}

SYNONYM message_syn { TYPE STRING; DEFAULT message_str; }

ACTION msg_string {
	IF (MY_STRING == message_syn) {	// synonyms may be compared directly
		SET_STRING scroll.STRING,message_str;
		CALL scroll_message;
		SET_STRING message_str,empty_str;
	}
}
ENDIF;

ACTION enter_message
{
	SET enter_txt.VISIBLE,ON;
	enter_txt.POS_X = scroll.POS_X;
	enter_txt.POS_Y = scroll.POS_Y + (SCROLL_LINES-1) * scroll.CHAR_Y;
	INKEY	message_str;
	IF (RESULT == 13) {
IFDEF ACKNEX_VERSION414;
		SEND_STRING	message_str;
ENDIF;
	}
	SET_STRING message_str,empty_str;
	SET enter_txt.VISIBLE,OFF;
}

//////////////////////////////////////////////////////////////////////
// actions for ammo and health panels
//////////////////////////////////////////////////////////////////////
SKILL show_ammo {}
SKILL show_health {}
SKILL show_armor {}
SKILL ammo_number {}
SKILL ammo1 {}
SKILL ammo2 {}
SKILL ammo3 {}
SKILL ammo4 {}

PANEL game_panel {
	POS_X		PANEL_POSX;
	DIGITS	0,0,3,digit_font,1,show_ammo;
	DIGITS	40,0,3,digit_font,1,show_health;
//	DIGITS	80,0,3,digit_font,1,show_armor;
	FLAGS		TRANSPARENT,REFRESH;
}

//////////////////////////////////////////////////////////////////////
ACTION show_panels
{
	SET HEALTHPANEL.VISIBLE,ON;
	WHILE (1) {	// forever
		HEALTHPANEL.POS_Y = SCREEN_SIZE.Y + PANEL_POSY;
		IF (ammo_number == 0) { show_ammo = 0; }
		IF (ammo_number == 1) { show_ammo = ammo1; }
		IF (ammo_number == 2) { show_ammo = ammo2; }
		IF (ammo_number == 3) { show_ammo = ammo3; }
		IF (ammo_number == 4) { show_ammo = ammo4; }
		IF (player != NULL) {
			show_health = player._HEALTH;
			show_armor = player._ARMOR;
		}
		WAIT	1;
	}
}

//////////////////////////////////////////////////////////////////////
// Stuff for displaying object titles if the mouse touches them
TEXT touch_txt {
	FONT	touch_font;
	STRING empty_str;
	FLAGS CENTER_X,CENTER_Y;
}

// display a touch text at mouse position
ACTION _show_touch
{
	IF (MY.STRING1 != NULL)
	{
		PLAY_SOUND 	touch_sound,33;
		SET touch_txt.VISIBLE,ON;
		SET touch_txt.STRING,MY.STRING1;
		touch_txt.POS_X = MOUSE_POS.X;
		touch_txt.POS_Y = MOUSE_POS.Y;
		SET MY.ENABLE_RELEASE,ON;

	//	WHILE (touch_text.VISIBLE == ON)	// move text with mouse
	//	{
	//		touch_text.POSX = MOUSE_X;
	//		touch_text.POSY = MOUSE_Y;
	//		WAIT 1;
	//	}
	}
}

// hide touch text if it still displayed my string
ACTION _hide_touch
{
	IF (touch_txt.STRING == MY.STRING1) {
		SET touch_txt.VISIBLE,OFF; }
}

// call this from a event action to operate the touch text
ACTION handle_touch
{
	IF (EVENT_TYPE == EVENT_TOUCH) { BRANCH _show_touch; }
	IF (EVENT_TYPE == EVENT_RELEASE) { BRANCH _hide_touch; }
}

//////////////////////////////////////////////////////////////////////

IFDEF ACKNEX_VERSION414;
ON_JOIN	msg_join;
ON_STRING msg_string;
ON_F4 enter_message;
ENDIF;