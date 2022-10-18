//////////////////////////////////////////////////////////
// Simple WDL game menu
//////////////////////////////////////////////////////////
IFNDEF MENU_DEFS;
 SOUND  menu_click <click.wav>;	// menu select sound
 DEFINE menu_font standard_font;	// menu font
 BMAP button_low,<black.pcx>,0,0,64,10;// menu item background
 BMAP button_hi,<white.pcx>,0,0,64,10;	// menu selected item background
 BMAP yesno_back,<black.pcx>,0,0,64,24;// yes/no panel background
 BMAP yesno_low,<black.pcx>,0,0,28,10;	// yes/no button background
 BMAP yesno_hi,<white.pcx>,0,0,28,10;	// yes/no selected button background
 BMAP arrow,<arrow.pcx>;// mouse pointer
 DEFINE YES_OFFS_X,2;	// offsets for yes/no buttons to panel
 DEFINE NO_OFFS_X,34;
 DEFINE YESNO_OFFS_Y,12;
ENDIF;	// MENU_DEFS

IFNDEF MENU_DEFS2;
 DEFINE CONSOLE_MODE_2;	// console line don't disappear after [ENTER]
 DEFINE INFO_NAME,"stat";
 DEFINE SAVE_NAME,"game";
ENDIF;
//////////////////////////////////////////////////////////
// skills to be preserved on score loading & level change
SKILL SOUND_VOL { TYPE GLOBAL; VAL 100; }
SKILL MIDI_VOL { TYPE GLOBAL; VAL 50; }
SKILL difficulty { TYPE GLOBAL; VAL 0; }

//////////////////////////////////////////////////////////
SKILL menu_pos { X 10; Y 10; }	// position of menu on screen
SKILL menu_dist { X 4; Y 12; }	// distance between buttons
SKILL menu_offs { X 2; Y 1; }		// offset text to button below
SKILL menu_max { VAL 7; }			// max items per menu

SKILL yesno_pos { X 10; Y 10; }	// position of yes/no panel
SKILL yesno_offs { X 2; Y 2; }	// offset text to panel

//////////////////////////////////////////////////////////
// Texts and messages appearing in the menu
STRING new_game_str,"New";
STRING load_game_str,"Load";
STRING save_game_str,"Save";
STRING quit_game_str,"Quit";
STRING options_str,"Options";
STRING help_str,"Help";
STRING resume_str,"Back";

STRING yes_str,"Yes";
STRING no_str," No";

STRING quit_yesno,"  Quit?";

STRING ok_str,"OK";
STRING wait_str,"Please wait...";
STRING save_error,"MALFUNCTION... can't save game";
STRING load_error,"MALFUNCTION... save before loading!";

STRING helptxt_str,
"ESC - Menu
F1  - Help
F2  - Quicksave
F3  - Quickload
F4  - Multiplayer message
F5  - Toggle resolution
F6  - Screenshot
F7  - Toggle person mode
F11 - Toggle gamma
F12 - Toggle sound/music
F10 - Exit";

//////////////////////////////////////////////////////////
// a lot of default strings, actions and synonyms
// which are used for the items of the menu

SKILL menu_cursor { VAL 0; } // determines which item is selected

// strings for the names of the five games to save and load
STRING name1_str,"         ";
STRING name2_str,"         ";
STRING name3_str,"         ";
STRING name4_str,"         ";
STRING name5_str,"         ";

SYNONYM mystring { TYPE STRING; }

// synonyms for the actions to execute for each of the 7 menu items
SYNONYM menu_do1 { TYPE ACTION; }
SYNONYM menu_do2 { TYPE ACTION; }
SYNONYM menu_do3 { TYPE ACTION; }
SYNONYM menu_do4 { TYPE ACTION; }
SYNONYM menu_do5 { TYPE ACTION; }
SYNONYM menu_do6 { TYPE ACTION; }
SYNONYM menu_do7 { TYPE ACTION; }

// Synonyms to save and restore any actions that were
// previously assigned to menu keys
SYNONYM old_menu_esc { TYPE ACTION; }
SYNONYM old_help_esc { TYPE ACTION; }
SYNONYM old_yesno_esc { TYPE ACTION; }
SYNONYM old_menu_enter { TYPE ACTION; }
SYNONYM old_yesno_enter { TYPE ACTION; }
SYNONYM old_cud { TYPE ACTION; }
SYNONYM old_cuu { TYPE ACTION; }
SYNONYM old_cul { TYPE ACTION; }
SYNONYM old_cur { TYPE ACTION; }
SYNONYM old_f1 { TYPE ACTION; }

// Actions which are really performed if clicking one of the 7 menu items.
// The menu has to disappear before the action is executed
ACTION _b1 { CALL _menu_clear; CALL menu_do1; }
ACTION _b2 { CALL _menu_clear; CALL menu_do2; }
ACTION _b3 { CALL _menu_clear; CALL menu_do3; }
ACTION _b4 { CALL _menu_clear; CALL menu_do4; }
ACTION _b5 { CALL _menu_clear; CALL menu_do5; }
ACTION _b6 { CALL _menu_clear; CALL menu_do6; }
ACTION _b7 { CALL _menu_clear; CALL menu_do7; }

ACTION _buttonclick { PLAY_SOUND menu_click,40; }

// Texts on the menu item buttons
TEXT menu_txt1 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt2 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt3 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt4 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt5 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt6 { LAYER 11; FONT menu_font; STRING empty_str; }
TEXT menu_txt7 { LAYER 11; FONT menu_font; STRING empty_str; }

// The items of which the menu really consists.
// Each item is a panel with a single button.
PANEL menu_pan1 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b1,NULL,_buttonclick;
}
PANEL menu_pan2 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b2,NULL,_buttonclick;
}
PANEL menu_pan3 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b3,NULL,_buttonclick;
}
PANEL menu_pan4 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b4,NULL,_buttonclick;
}
PANEL menu_pan5 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b5,NULL,_buttonclick;
}
PANEL menu_pan6 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b6,NULL,_buttonclick;
}
PANEL menu_pan7 {
	LAYER 10; FLAGS REFRESH,TRANSPARENT;
	BUTTON 0,0,button_hi,button_low,button_hi,_b7,NULL,_buttonclick;
}

PANEL menu_select {
	LAYER 10.5; BMAP button_hi; FLAGS REFRESH,TRANSPARENT;
}

/////////////////////////////////////////////////////////////////////
// This action initializes the menu
ACTION menu_show {
	CALL _yesno_hide;	// if a yesno panel was active, hide it

// First, set all button panels to their correct positions
	menu_pan1.POS_X = menu_pos.X;
	menu_pan1.POS_Y = menu_pos.Y;
	menu_txt1.POS_X = menu_pos.X + menu_offs.X;
	menu_txt1.POS_Y = menu_pos.Y + menu_offs.Y;
	menu_pan2.POS_X = menu_pan1.POS_X + menu_dist.X;
	menu_pan2.POS_Y = menu_pan1.POS_Y + menu_dist.Y;
	menu_txt2.POS_X = menu_txt1.POS_X + menu_dist.X;
	menu_txt2.POS_Y = menu_txt1.POS_Y + menu_dist.Y;
	menu_pan3.POS_X = menu_pan2.POS_X + menu_dist.X;
	menu_pan3.POS_Y = menu_pan2.POS_Y + menu_dist.Y;
	menu_txt3.POS_X = menu_txt2.POS_X + menu_dist.X;
	menu_txt3.POS_Y = menu_txt2.POS_Y + menu_dist.Y;
	menu_pan4.POS_X = menu_pan3.POS_X + menu_dist.X;
	menu_pan4.POS_Y = menu_pan3.POS_Y + menu_dist.Y;
	menu_txt4.POS_X = menu_txt3.POS_X + menu_dist.X;
	menu_txt4.POS_Y = menu_txt3.POS_Y + menu_dist.Y;
	menu_pan5.POS_X = menu_pan4.POS_X + menu_dist.X;
	menu_pan5.POS_Y = menu_pan4.POS_Y + menu_dist.Y;
	menu_txt5.POS_X = menu_txt4.POS_X + menu_dist.X;
	menu_txt5.POS_Y = menu_txt4.POS_Y + menu_dist.Y;
	menu_pan6.POS_X = menu_pan5.POS_X + menu_dist.X;
	menu_pan6.POS_Y = menu_pan5.POS_Y + menu_dist.Y;
	menu_txt6.POS_X = menu_txt5.POS_X + menu_dist.X;
	menu_txt6.POS_Y = menu_txt5.POS_Y + menu_dist.Y;
	menu_pan7.POS_X = menu_pan6.POS_X + menu_dist.X;
	menu_pan7.POS_Y = menu_pan6.POS_Y + menu_dist.Y;
	menu_txt7.POS_X = menu_txt6.POS_X + menu_dist.X;
	menu_txt7.POS_Y = menu_txt6.POS_Y + menu_dist.Y;

// Now save the old actions of ESC, Cursor, ENTER keys into synonyms
// and assign them them new actions required for the menu
	SET old_menu_esc,ON_ESC;
	SET ON_ESC,_menu_clear;	// now ESC clears the menu
	SET old_cuu,ON_CUU;
	SET on_cuu,_menu_up;		// CUU moves the selection cursor up
	SET old_cud,ON_CUD;
	SET on_cud,_menu_down;	// CUD moves it down
	SET old_menu_enter,ON_ENTER;
	SET ON_ENTER,_menu_exec;// and ENTER ececutes the selected item

// and now place the menu cursor to the first item, and make the
// whole menu visible.
	CALL _menu_visible;
	CALL _menu_set;	// highlight first item
}

// This just makes all menu items - buttons and texts above - visible on screen.
ACTION _menu_visible {
	IF (menu_max >= 1) {
		SET menu_pan1.VISIBLE,ON;
		SET menu_txt1.VISIBLE,ON;
	}
	IF (menu_max >= 2) {
		SET menu_pan2.VISIBLE,ON;
		SET menu_txt2.VISIBLE,ON;
	}
	IF (menu_max >= 3) {
		SET menu_pan3.VISIBLE,ON;
		SET menu_txt3.VISIBLE,ON;
	}
	IF (menu_max >= 4) {
		SET menu_pan4.VISIBLE,ON;
		SET menu_txt4.VISIBLE,ON;
	}
	IF (menu_max >= 5) {
		SET menu_pan5.VISIBLE,ON;
		SET menu_txt5.VISIBLE,ON;
	}
	IF (menu_max >= 6) {
		SET menu_pan6.VISIBLE,ON;
		SET menu_txt6.VISIBLE,ON;
	}
	IF (menu_max >= 7) {
		SET menu_pan7.VISIBLE,ON;
		SET menu_txt7.VISIBLE,ON;
	}
	FREEZE_MODE = 1;	// when the menu is on screen, the game freezes
	menu_cursor = 1;	// place to first item
}


// This just lets all menu items disappear again
ACTION _menu_hide {
	SET menu_pan1.VISIBLE,OFF;
	SET menu_txt1.VISIBLE,OFF;
	SET menu_pan2.VISIBLE,OFF;
	SET menu_txt2.VISIBLE,OFF;
	SET menu_pan3.VISIBLE,OFF;
	SET menu_txt3.VISIBLE,OFF;
	SET menu_pan4.VISIBLE,OFF;
	SET menu_txt4.VISIBLE,OFF;
	SET menu_pan5.VISIBLE,OFF;
	SET menu_txt5.VISIBLE,OFF;
	SET menu_pan6.VISIBLE,OFF;
	SET menu_txt6.VISIBLE,OFF;
	SET menu_pan7.VISIBLE,OFF;
	SET menu_txt7.VISIBLE,OFF;
	SET menu_select.VISIBLE,OFF;
}

// This quits the menu, restores old key actions, and continues the game
ACTION _menu_clear {
	if (menu_cursor > 0) {
		CALL _menu_hide;
		SET ON_ESC,old_menu_esc;
		SET ON_CUU,old_cuu;
		SET ON_CUD,old_cud;
		SET ON_ENTER,old_menu_enter;
		FREEZE_MODE = 0;
		menu_cursor = 0;
	}
}

// One item up
ACTION _menu_up {
	menu_cursor -= 1;
	BRANCH _menu_set;
}

// One item down
ACTION _menu_down {
	menu_cursor += 1;
	BRANCH _menu_set;
}

// Highlights the selected menu item, onto which the menu cursor is placed
ACTION _menu_set {
// cursor highlight has no effect in mouse mode
	IF (MOUSE_MODE >= 1) { SET menu_select.VISIBLE,OFF; RETURN; }

// restrict the menu cursor to valid values
	IF (menu_cursor < 1) { menu_cursor = menu_max; }
	IF (menu_cursor > menu_max) { menu_cursor = 1; }

// set the highlight panel onto the selected item, and make it visible
	menu_select.POS_X = menu_pos.X + (menu_cursor-1) * menu_dist.X;
	menu_select.POS_Y = menu_pos.Y + (menu_cursor-1) * menu_dist.Y;
	SET menu_select.VISIBLE,ON;
	CALL _buttonclick;
}

// exceutes the action of the selected menu item
ACTION _menu_exec {
// if alt or ctrl was pressed, don't execute the menu but the old action
	IF (KEY_ALT || KEY_CTRL) { BRANCH old_menu_enter; }

// now ececute the item action, dependent on the menu cursor position
	PLAY_SOUND	menu_click,60;
	IF (menu_cursor == 1) { BRANCH _b1; }
	IF (menu_cursor == 2) { BRANCH _b2; }
	IF (menu_cursor == 3) { BRANCH _b3; }
	IF (menu_cursor == 4) { BRANCH _b4; }
	IF (menu_cursor == 5) { BRANCH _b5; }
	IF (menu_cursor == 6) { BRANCH _b6; }
	IF (menu_cursor == 7) { BRANCH _b7; }
}

///////////////////////////////////////////////////////////////////////
// Yes/No Panel stuff
SKILL yesno_active { VAL 0; }

// For saving and restoring the old key actions
SYNONYM old_y { TYPE ACTION; }
SYNONYM old_z { TYPE ACTION; }
SYNONYM old_n { TYPE ACTION; }

// Action to execute if YES is clicked on
SYNONYM yesno_do { TYPE ACTION; }
ACTION _yes_exec { CALL _yesno_clear; CALL yesno_do; }

// The yes/no panel consists of 2 buttons, not surprisingly
PANEL yesno_pan {
	LAYER 12; BMAP yesno_back; FLAGS TRANSPARENT,REFRESH;
	BUTTON YES_OFFS_X,YESNO_OFFS_Y,yesno_hi,yesno_low,yesno_hi,
		_yes_exec,NULL,_buttonclick;
	BUTTON NO_OFFS_X,YESNO_OFFS_Y,yesno_hi,yesno_low,yesno_hi,
		_yesno_clear,NULL,_buttonclick;
}

// Texts of the panel and the two buttons
TEXT yesno_txt { LAYER 13; FONT menu_font; STRING empty_str; }
TEXT yes_txt { LAYER 13; FONT menu_font; STRING yes_str; }
TEXT no_txt { LAYER 13; FONT menu_font; STRING no_str; }

///////////////////////////////////////////////////////////////////////
// Initialzes the yesno panel
ACTION yesno_show {
	CALL _menu_clear;		// in case menu was switched on before
	CALL _yesno_clear;	// remove last yesno

// set the position of yesno panels and text
	yesno_pan.POS_X = yesno_pos.X;
	yesno_pan.POS_Y = yesno_pos.Y;
	yesno_txt.POS_X = yesno_pan.POS_X + yesno_offs.X;
	yesno_txt.POS_Y = yesno_pan.POS_Y + yesno_offs.Y;
	yes_txt.POS_X = yesno_txt.POS_X + YES_OFFS_X;
	yes_txt.POS_Y = yesno_txt.POS_Y + YESNO_OFFS_Y;
	no_txt.POS_X = yesno_txt.POS_X + NO_OFFS_X;
	no_txt.POS_Y = yes_txt.POS_Y;

// let everything appear on screen
	SET yesno_pan.VISIBLE,ON;
	SET yesno_txt.VISIBLE,ON;
	SET yes_txt.VISIBLE,ON;
	SET no_txt.VISIBLE,ON;

// Save the old key actions, and set the reqired panel actions
	SET old_yesno_esc,ON_ESC;
	SET ON_ESC,_yesno_clear;
	SET old_n,ON_N;
	SET ON_N,_yesno_clear;
	SET old_yesno_enter,ON_ENTER;
	SET ON_ENTER,_yes_exec;
	SET old_y,ON_Y;
	SET ON_Y,_yes_exec;
	SET old_z,ON_Z;		// for German keyboard...
	SET ON_Z,_yes_exec;

	yesno_active = 1;
	FREEZE_MODE = 1;		// freeze game
}

// let the yesno panel disappear
ACTION _yesno_hide {
	SET yesno_pan.VISIBLE,OFF;
	SET yesno_txt.VISIBLE,OFF;
	SET yes_txt.VISIBLE,OFF;
	SET no_txt.VISIBLE,OFF;
}

// exit the yesno panel
ACTION _yesno_clear {
	if (yesno_active) {
		CALL _yesno_hide;
		FREEZE_MODE = 0;		// unfreeze game
// restore old key actions
		SET ON_ESC,old_yesno_esc;
		SET ON_N,old_n;
		SET ON_ENTER,old_yesno_enter;
		SET ON_Y,old_y;
		SET ON_Z,old_z;
		yesno_active = 0;
	}
}

///////////////////////////////////////////////////////////////////////
// menu actions for a standard game

ACTION menu_main {
	SET menu_txt1.STRING,new_game_str;
	SET menu_txt2.STRING,load_game_str;
	SET menu_txt3.STRING,save_game_str;
	SET menu_txt4.STRING,quit_game_str;
	SET menu_txt5.STRING,options_str;
	SET menu_txt6.STRING,help_str;
	SET menu_txt7.STRING,resume_str;

	SET menu_do1,game_init;	// normally an action which resets all
	SET menu_do2,_menu_load;
	SET menu_do3,_menu_save;
	SET menu_do4,exit_yesno;
	SET menu_do5,game_options;
	SET menu_do6,game_help;
	SET menu_do7,_menu_clear;

	menu_max = 7;
	CALL menu_show;
}

ACTION game_init {	// default action, to be replaced by a game-adapted action
	CALL key_init;
	CALL weapon_init;
	CALL main;
}

ACTION weapon_init { RETURN; }	// dummy action, if weapons.wdl is not included

SKILL _entry { TYPE GLOBAL; VAL 0; }
ACTION game_entry {	// mark the score to re-enter the game (yet to do)
	IF (_entry == 0) {
		_entry = 1;
	}
}

///////////////////////////////////////////////////////////////////////
ACTION exit_yesno {
	SET	yesno_txt.STRING,quit_yesno;
	SET	yesno_do,game_exit;
	CALL	yesno_show;
}

ACTION game_exit {
	CALL	save_status;			// save global skills & strings
	EXIT	"3D GameStudio (c) conitec 1999\n";
}

///////////////////////////////////////////////////////////////////////
// save/load stuff
SKILL slot	{ VAL 0; }	// number of last score

ACTION _menu_save {
	SET menu_txt1.STRING,name1_str;
	SET menu_txt2.STRING,name2_str;
	SET menu_txt3.STRING,name3_str;
	SET menu_txt4.STRING,name4_str;
	SET menu_txt5.STRING,name5_str;
	SET menu_txt6.STRING,resume_str;

	SET menu_do1,_menu_save1;
	SET menu_do2,_menu_save2;
	SET menu_do3,_menu_save3;
	SET menu_do4,_menu_save4;
	SET menu_do5,_menu_save5;
	SET menu_do6,_menu_clear;

	menu_max = 6;
	CALL menu_show;
}

ACTION _menu_save1 { slot = 1; SET mystring,name1_str; BRANCH _game_save; }
ACTION _menu_save2 { slot = 2; SET mystring,name2_str; BRANCH _game_save; }
ACTION _menu_save3 { slot = 3; SET mystring,name3_str; BRANCH _game_save; }
ACTION _menu_save4 { slot = 4; SET mystring,name4_str; BRANCH _game_save; }
ACTION _menu_save5 { slot = 5; SET mystring,name5_str; BRANCH _game_save; }

ACTION _game_save
{
	CALL _menu_visible;	// was hidden before
	INKEY	mystring;
	IF (RESULT != 13) { BRANCH _menu_clear; }
	CALL	_menu_clear;
	CALL	save_status;			// save global skills & strings
	SET ON_LOAD,load_status;	// to automatically reload them

//	SET msg.STRING,wait_str;
//	CALL	show_message;

	SAVE SAVE_NAME,slot;	// save game
	IF (RESULT < 0) {		// Error?
		SET msg.STRING,save_error;
	} ELSE {
		SET msg.STRING,ok_str;
	}
	CALL	show_message;
}


// after re-loading a game, reload all global parameters
ACTION save_status {
	SAVE_INFO INFO_NAME,0;
}
ACTION load_status {
	WAIT 2;	// don't override previous LOAD etc.
	LOAD_INFO INFO_NAME,0;
}

///////////////////////////////////////////////////////////////////////
ACTION _menu_load {
	SET menu_txt1.STRING,name1_str;
	SET menu_txt2.STRING,name2_str;
	SET menu_txt3.STRING,name3_str;
	SET menu_txt4.STRING,name4_str;
	SET menu_txt5.STRING,name5_str;
	SET menu_txt6.STRING,resume_str;

	SET menu_do1,_menu_load1;
	SET menu_do2,_menu_load2;
	SET menu_do3,_menu_load3;
	SET menu_do4,_menu_load4;
	SET menu_do5,_menu_load5;
	SET menu_do6,_menu_clear;

	menu_max = 6;
	CALL menu_show;
}

ACTION _menu_load1 { slot = 1; BRANCH _game_load; }
ACTION _menu_load2 { slot = 2; BRANCH _game_load; }
ACTION _menu_load3 { slot = 3; BRANCH _game_load; }
ACTION _menu_load4 { slot = 4; BRANCH _game_load; }
ACTION _menu_load5 { slot = 5; BRANCH _game_load; }

ACTION _game_load {
	SET	msg.STRING,wait_str;
	CALL	show_message;
	WAIT	1;				// to display wait message before loading
	LOAD	SAVE_NAME,slot;
	SET	msg.STRING,load_error;	// failed!
	CALL	show_message;
}

///////////////////////////////////////////////////////////////////////
ACTION game_help {
	FREEZE_MODE = 1;
	SET msg.STRING,helptxt_str;
	SET msg.VISIBLE,ON;
	SET old_help_esc,ON_ESC;
	SET ON_ESC,help_hide;
	SET old_f1,ON_F1;
	SET ON_F1,help_hide;
}

ACTION help_hide {
	FREEZE_MODE = 0;
	SET msg.VISIBLE,OFF;
	SET ON_ESC,old_help_esc;
	SET ON_F1,old_f1;
}

///////////////////////////////////////////////////////////////////////
// Options sliders stuff
DEFINE SLIDER_LEN,70;

BMAP slider_map,<white.pcx>,0,0,10,10;
BMAP slider_bar,<black.pcx>,0,0,SLIDER_LEN,2;

SKILL bar_val1 { VAL SLIDER_LEN; }
SKILL bar_val2 { VAL SLIDER_LEN; }
SKILL bar_val3 { VAL SLIDER_LEN; }
SKILL slider_soundvol { X 80; Y 0; Z 100; }
SKILL slider_musicvol { X 50; Y 0; Z 100; }
SKILL slider_resolution { X 3; Y 1; Z 8; }

PANEL option_pan {
	LAYER 10;	FLAGS REFRESH;
	HBAR 4,8,SLIDER_LEN,slider_bar,1,bar_val1;	// just to draw a black line
	HSLIDER 4,4,SLIDER_LEN,slider_map,slider_soundvol;

	HBAR 4,28,SLIDER_LEN,slider_bar,1,bar_val2;
	HSLIDER 4,24,SLIDER_LEN,slider_map,slider_musicvol;

	HBAR 4,48,SLIDER_LEN,slider_bar,1,bar_val3;
	HSLIDER 4,44,SLIDER_LEN,slider_map,slider_resolution;
}

STRING optionsound_str,"-  volume  +";
STRING optionmusic_str,"-  music   +";
STRING optionres_str,  "-  video   +";

// Yet to do: modularize a slider panel
ACTION game_options {
	EXCLUSIVE_GLOBAL;
	FREEZE_MODE = 1;
	option_pan.POS_X = menu_pos.X;
	option_pan.POS_Y = menu_pos.Y;
	menu_txt1.POS_X = menu_pos.X + 2;
	menu_txt1.POS_Y = menu_pos.Y + 15;
	menu_txt2.POS_X = menu_txt1.POS_X;
	menu_txt2.POS_Y = menu_txt1.POS_Y + 20;
	menu_txt3.POS_X = menu_txt2.POS_X;
	menu_txt3.POS_Y = menu_txt2.POS_Y + 20;
	SET option_pan.VISIBLE,ON;
	SET menu_txt1.VISIBLE,ON;
	SET menu_txt2.VISIBLE,ON;
	SET menu_txt3.VISIBLE,ON;
	SET menu_txt1.STRING,optionsound_str;
	SET menu_txt2.STRING,optionmusic_str;
	SET menu_txt3.STRING,optionres_str;
	SET old_menu_esc,ON_ESC;
	SET ON_ESC,options_hide;
	SET old_cuu,ON_CUU;
	SET ON_CUU,_slider_up;
	SET old_cud,ON_CUD;
	SET ON_CUD,_slider_down;
	SET old_cul,ON_CUL;
	SET ON_CUL,_slider_left;
	SET old_cur,ON_CUR;
	SET ON_CUR,_slider_right;

	menu_cursor = 1;
	slider_soundvol = SOUND_VOL;
	slider_musicvol = MIDI_VOL;
	slider_resolution = VIDEO_MODE;

	WHILE (option_pan.VISIBLE == ON) {
		IF (MOUSE_MODE == 0) {
			IF (menu_cursor == 1) {
				IF (bar_val1 == 0) {
					bar_val1 = SLIDER_LEN;
				} ELSE {
					bar_val1 = 0;
				}
				bar_val2 = SLIDER_LEN;
				bar_val3 = SLIDER_LEN;
			}
			IF (menu_cursor == 2) {
				IF (bar_val2 == 0) {
					bar_val2 = SLIDER_LEN;
				} ELSE {
					bar_val2 = 0;
				}
				bar_val1 = SLIDER_LEN;
				bar_val3 = SLIDER_LEN;
			}
			IF (menu_cursor == 3) {
				IF (bar_val3 == 0) {
					bar_val3 = SLIDER_LEN;
				} ELSE {
					bar_val3 = 0;
				}
				bar_val2 = SLIDER_LEN;
				bar_val1 = SLIDER_LEN;
			}
		} ELSE {
		 	bar_val1 = SLIDER_LEN;
		 	bar_val2 = SLIDER_LEN;
		 	bar_val3 = SLIDER_LEN;
		}
		SOUND_VOL = slider_soundvol;
		MIDI_VOL = slider_musicvol;
		WAIT 1;
	}
}

// move the cursor one slider up
ACTION _slider_up {
	IF (MOUSE_MODE != 0) { RETURN; }
	CALL _buttonclick;
	menu_cursor -= 1;
	IF (menu_cursor < 1) { menu_cursor = 3; }
}

// move the cursor one slider down
ACTION _slider_down {
	IF (MOUSE_MODE != 0) { RETURN; }
	CALL _buttonclick;
	menu_cursor += 1;
	IF (menu_cursor > 3) { menu_cursor = 1; }
}

// move selected slider to right
ACTION _slider_right {
	IF (MOUSE_MODE != 0) { RETURN; }
	CALL _buttonclick;
	IF (menu_cursor == 1) {
		slider_soundvol += 10;
		IF (slider_soundvol > slider_soundvol.Z) { slider_soundvol = slider_soundvol.Z; }
	}
	IF (menu_cursor == 2) {
		slider_musicvol += 10;
		IF (slider_musicvol > slider_musicvol.Z) { slider_musicvol = slider_musicvol.Z; }
	}
	IF (menu_cursor == 3) {
		slider_resolution += 1;
		IF (slider_resolution > slider_resolution.Z) { slider_resolution = slider_resolution.Z; }
	}
}

// move selected slider to left
ACTION _slider_left {
	IF (MOUSE_MODE != 0) { RETURN; }
	CALL _buttonclick;
	IF (menu_cursor == 1) {
		slider_soundvol -= 10;
		IF (slider_soundvol < slider_soundvol.Y) { slider_soundvol = slider_soundvol.Y; }
	}
	IF (menu_cursor == 2) {
		slider_musicvol -= 10;
		IF (slider_musicvol < slider_musicvol.Y) { slider_musicvol = slider_musicvol.Y; }
	}
	IF (menu_cursor == 3) {
		slider_resolution -= 1;
		IF (slider_resolution < slider_resolution.Y) { slider_resolution = slider_resolution.Y; }
	}
}

ACTION options_hide {
	IF (slider_resolution != VIDEO_MODE) {
		SWITCH_VIDEO slider_resolution,0,0;
		slider_resolution = VIDEO_MODE;
		CALL _show_resolution;
	}
	FREEZE_MODE = 0;
	SET option_pan.VISIBLE,OFF;
	SET menu_txt1.VISIBLE,OFF;
	SET menu_txt2.VISIBLE,OFF;
	SET menu_txt3.VISIBLE,OFF;
	SET ON_ESC,old_menu_esc;
	SET ON_CUU,old_cuu;
	SET ON_CUD,old_cud;
	SET ON_CUL,old_cul;
	SET ON_CUR,old_cur;
}


///////////////////////////////////////////////////////////////////////////////////
ACTION mouse_toggle { 		// switches the mouse on and off
	MOUSE_MODE += 2;
	IF (MOUSE_MODE > 2) {	// was it already on?
		MOUSE_MODE = 0;		// mouse off
	} ELSE {
		BRANCH mouse_on;
	}
}

ACTION mouse_on { 		// switches the mouse on
	SET menu_select.VISIBLE,OFF;	// menu now handled by mouse
	SET MOUSE_MAP,arrow;
	WHILE (MOUSE_MODE > 0) {
IFDEF ACKNEX_VERSION414;	// This version suports the true mouse cursor
		MOUSE_POS.X = POINTER.X;
		MOUSE_POS.Y = POINTER.Y;
IFELSE;
		MOUSE_POS.X += MICKEY.X;
		MOUSE_POS.Y += MICKEY.Y;
ENDIF;
		WAIT	1; 		      // now move it over the screen
	}
}

ACTION mouse_off { 		// switches the mouse off
	MOUSE_MODE = 0;
}

//SKILL MOUSE_SPOT { X 5; Y 5; }

////////////////////////////////////////////////////////////////////////////
// For debugging purposes, use the EXECUTE instruction
// to type in WDL instructions during gameplay, like at a console.
// You can examine skill values through "TO_STRING look,skill;"

STRING exec_buffer	// just an 80-char string
"                                                                              ";
STRING look "         "; // to see skills via TO_STRING;

TEXT console_txt {
	POS_X 4;
	LAYER	10;
	FONT 	standard_font;
	STRINGS 3;
IFDEF CONSOLE_MODE_2;
	STRING "Enter instructions below, abort with [ESC]:";
IFELSE;
	STRING "Enter instructions below:";
ENDIF;
	STRING exec_buffer;
	STRING look;
}

ACTION console
{
	IF (console_txt.VISIBLE == ON) { RETURN; }	//already running
	console_txt.POS_Y = SCREEN_SIZE.Y - 60;
	SET console_txt.VISIBLE,ON;
	WHILE (console_txt.VISIBLE == ON)
	{
		INKEY	exec_buffer;
		IF (RESULT == 13) {
			EXECUTE exec_buffer;
IFDEF CONSOLE_MODE_2;
		} ELSE {
			SET console_txt.VISIBLE,OFF;
		}
IFELSE;
		}
		SET console_txt.VISIBLE,OFF;
ENDIF;
	}
}

// Implementing a scrolling console, instead of a 1-line one,
// is left as an exercise to the reader...

//////////////////////////////////////////////////////////////
// screen resolution display
//////////////////////////////////////////////////////////////////////
STRING resolution_str,"                              ";
STRING screen_str,"Video ";
STRING x_str,"x";

ACTION _show_resolution {
// compose the resolution string from strings and numbers
	SET_STRING resolution_str,screen_str;
// now it reads "Video "
	TO_STRING  temp_str,SCREEN_SIZE.X;
	ADD_STRING resolution_str,temp_str;
// now it reads "Video hhhh" (hhhh is the hor resolution)
	ADD_STRING resolution_str,x_str;
// now it reads "Video hhhhx"
	TO_STRING  temp_str,SCREEN_SIZE.Y;
	ADD_STRING resolution_str,temp_str;
// now it reads "Video hhhhxvvvv"
	ADD_STRING resolution_str,x_str;
// now it reads "Video hhhhxvvvvx"
	TO_STRING  temp_str,VIDEO_DEPTH;
	ADD_STRING resolution_str,temp_str;
// and now it reads "Video hhhhxvvvvxdd"
	SET	msg.STRING,resolution_str;
	BRANCH	show_message;
}

ACTION game_resolution {
	CALL _toggle_video;
	CALL _show_resolution;
}

//////////////////////////////////////////////////////////////////////
// Default key assignements to control the game
ON_ESC menu_main;
ON_F1	 game_help;
ON_F5	 game_resolution;
ON_F10 exit_yesno;
ON_TAB console;

ON_MOUSE_RIGHT	mouse_toggle;