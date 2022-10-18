SKILL menusel {X 1; Z 8;} //Z=menu entries

STRING yes_str "Yes";
STRING no_str "No";
STRING quit_str "Leave Martek's Adventure?";

STRING menu1_str "Start Game";
STRING menu2_str "Game Settings";
STRING menu3_str "Video Settings";
STRING menu4_str "Help Guide";
STRING menu5_str "Credits";
STRING menu6_str "Quit Game";
STRING menu7_str " ";
STRING menu8_str "Exit to Game";
STRING menusel_str "                  ";
STRING empty_str " ";

FONT bigfont, <bigfont.pcx>,10,16;
FONT bigfont_yellow, <bigfonty.pcx>,10,16;

BMAP menu_map, <menu.pcx>;
PANEL menu_pan {
POS_X 0;
POS_X 0;
LAYER 10;
BMAP menu_map;
FLAGS REFRESH;
}

TEXT mainmenu_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
INDEX 1;
STRINGS 8;
STRING menu1_str,menu2_str,menu3_str,menu4_str,menu5_str,menu6_str,menu7_str,menu8_str;
LAYER 10;
FLAGS NARROW;
}

TEXT menusel_txt {
FONT bigfont_yellow;
POS_X 0;
POS_Y 0;
STRING menusel_str;
LAYER 11;
FLAGS NARROW;
}

TEXT quit_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
STRING quit_str;
LAYER 10;
FLAGS NARROW,CENTER_X,CENTER_Y;
}

TEXT yesno_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
INDEX 1;
STRINGS 2;
STRING yes_str,no_str;
LAYER 10;
FLAGS NARROW;
}

STRING pause_str, "Game Paused";
TEXT pause_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
STRING pause_str;
LAYER 20;
FLAGS NARROW,CENTER_X,CENTER_Y;
}

STRING names_str, "________________________________
Robert 'Firoball' J{ger
master@firoball.de

_______________________
Tom 'Hai ok' Knapp
hai_ok@firoball.de

___________________
Thomas 'KTS' Scheiffele
kts@crew99.de";

STRING credits_str, "- Scripting,Level Design,Game Idea -
\n\n
- Modeling and Animations -
\n\n
- Additional Textures -
";

TEXT credits_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
STRING credits_str;
LAYER 20;
FLAGS NARROW,CENTER_X;
}

TEXT names_txt {
FONT bigfont;
POS_X 0;
POS_Y 0;
STRING names_str;
LAYER 20;
FLAGS NARROW,CENTER_X;
}

//////////Menu Actions//////////

ACTION pause_game {
	IF (pause_txt.VISIBLE==0) {
		#CALL reset_controls;
		SET ON_ESC,pause_game;
		pause_txt.POS_X=SCREEN_SIZE.X/2;
		pause_txt.POS_Y=SCREEN_SIZE.Y/2;
		SET pause_txt.VISIBLE,1;
		SET FREEZE_MODE,1;
	} ELSE {
		SET pause_txt.VISIBLE,NULL;	
		SET ON_ESC,show_menu;
		#CALL set_controls;
		SET FREEZE_MODE,0;
	}
}

SYNONYM menu_txt {TYPE TEXT; DEFAULT mainmenu_txt;}
ACTION show_menu {
	IF (menu_txt.VISIBLE==1) {
		SET menu_pan.VISIBLE,0;
		SET menu_txt.VISIBLE,0;
		SET menusel_txt.VISIBLE,0;
		SET ON_CUU,NULL;
		SET ON_CUD,NULL;
		SET ON_ENTER,NULL;
		SET ON_PAUSE,pause_game;
		SET FREEZE_MODE,0;
	} ELSE {
		SET menu_txt,mainmenu_txt;
		menusel=1;
		menusel.Z=8;
		menu_txt.POS_X=45;
		menu_txt.POS_Y=SCREEN_SIZE.Y/6;
		menusel_txt.POS_X=45;
		menusel_txt.POS_Y=SCREEN_SIZE.Y/6;
		menu_pan.POS_Y=SCREEN_SIZE.Y/6-7;
		menu_pan.POS_X=1;
		SET_STRING menusel_txt.STRING,menu1_str;	
		SET menu_pan.VISIBLE,1;
		SET menu_txt.VISIBLE,1;
		SET menusel_txt.VISIBLE,1;
		SET ON_CUU, sel_menu_up;
		SET ON_CUD, sel_menu_down;
		SET ON_ENTER, exec_menu;
		SET ON_PAUSE,NULL;
		SET FREEZE_MODE,1;
	}
}

ACTION sel_menu_up {
redo:
	menusel-=1;
	IF (menusel<1) {menusel=menusel.Z;}
	SET menu_txt.INDEX,menusel;
	STRICMP empty_str,menu_txt.STRING;
	IF (RESULT==0) {GOTO redo;}
	menusel_txt.POS_Y=menu_txt.POS_Y+(menusel-1)*16;
	SET_STRING menusel_txt.STRING,menu_txt.STRING;	
}

ACTION sel_menu_down {
redo:
	menusel+=1;
	IF (menusel>menusel.Z) {menusel=1;}
	SET menu_txt.INDEX,menusel;
	STRICMP empty_str,menu_txt.STRING;
	IF (RESULT==0) {GOTO redo;}
	menusel_txt.POS_Y=menu_txt.POS_Y+(menusel-1)*16;
	SET_STRING menusel_txt.STRING,menu_txt.STRING;	
}

ACTION exec_menu {
	IF (menusel==5) {
		CALL show_menu;
		BRANCH show_credits;
	}
	IF (menusel==6) {
		CALL show_menu;
		BRANCH quit_game;
	}
	IF (menusel==8) {
		BRANCH show_menu;
	}
}

//////////

ACTION exec_quit {
	IF (menusel==1) {
		BRANCH quit;
	}
	IF (menusel==2) {
		BRANCH no_quit;
	}
}

ACTION show_credits {
	IF (credits_txt.VISIBLE==1) {
		SET credits_txt.VISIBLE,0;
		SET names_txt.VISIBLE,0;
		SET ON_ESC,show_menu;
		SET FREEZE_MODE,0;
	} ELSE {
		credits_txt.POS_X=SCREEN_SIZE.X/2;
		credits_txt.POS_Y=SCREEN_SIZE.Y/6;
		names_txt.POS_X=credits_txt.POS_X;
		names_txt.POS_Y=credits_txt.POS_Y+4;
		SET credits_txt.VISIBLE,1;
		SET names_txt.VISIBLE,1;
		SET ON_ESC,show_credits;
		SET FREEZE_MODE,1;
	}
}

ACTION quit_game {
	SET FREEZE_MODE,1;
	SET menu_txt,yesno_txt;
	quit_txt.POS_X=SCREEN_SIZE.X/2;
	quit_txt.POS_Y=SCREEN_SIZE.Y/2;
	yesno_txt.POS_X=quit_txt.POS_X-(yesno_txt.CHAR_X*3/2);
	yesno_txt.POS_Y=quit_txt.POS_Y+16;
	menusel_txt.POS_X=yesno_txt.POS_X;
	menusel_txt.POS_Y=yesno_txt.POS_Y;
	SET_STRING menusel_txt.STRING,yes_str;	
	menusel=1;
	menusel.Z=2;
	SET quit_txt.VISIBLE,1;
	SET yesno_txt.VISIBLE,1;
	SET menusel_txt.VISIBLE,1;
#	CALL reset_controls;
	SET ON_ESC,no_quit;
	SET ON_N,no_quit;
	SET ON_Z,quit;
	SET ON_Y,quit;
	SET ON_J,quit;
	SET ON_CUU, sel_menu_up;
	SET ON_CUD, sel_menu_down;
	SET ON_ENTER,exec_quit;
}

ACTION no_quit {
	SET quit_txt.VISIBLE,0;
	SET yesno_txt.VISIBLE,0;
	SET menusel_txt.VISIBLE,0;
	SET ON_ESC,show_menu;
	SET ON_N,NULL;
	SET ON_Z,NULL;
	SET ON_Y,NULL;
	SET ON_J,NULL;
	SET ON_CUU,NULL;
	SET ON_CUD,NULL;
	SET ON_ENTER,NULL;
#	CALL set_controls;
	SET FREEZE_MODE,0;
}

ACTION quit {
	CALL reset_user;
	SAVE_INFO "game",1;
	WAIT 1;
	SAVE_INFO "config",VIDEO_DEPTH;
	WAIT 1;
	EXIT;
}

ON_ESC show_menu;
ON_PAUSE pause_game;
ON_F10 quit_game;

ACTION reset_user {
	user1.X=0;
	user1.Y=0;
	user1.Z=0;
	user2.X=0;
	user2.Y=0;
	user2.Z=0;
	user3.X=0;
	user3.Y=0;
	user3.Z=0;
	user4.X=0;
	user4.Y=0;
	user4.Z=0;
	user5.X=0;
	user5.Y=0;
	user5.Z=0;
}