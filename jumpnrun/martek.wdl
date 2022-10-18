SKILL D3D_TEXRESERVED {VAL 0;}
/////Video Mode Init/////

DEFINE V320x200,1;
DEFINE V320x240,2;
DEFINE V320x400,3;
DEFINE V400x300,4;
DEFINE V512x384,5;
DEFINE V640x480,6;
DEFINE V800x600,7;
DEFINE V1024x768,8;
DEFINE V1280x960,9;
DEFINE V1600x1200,10;

IFDEF d3d;
	SKILL VIDEO_DEPTH {TYPE LOCAL; VAL 16; }
	SKILL VIDEO_MODE {TYPE LOCAL; VAL V640x480; }
	SKILL TURB_SPEED {TYPE LOCAL; VAL 0.3;}
IFELSE;
	SKILL VIDEO_MODE {TYPE LOCAL; VAL V320x240; }
	SKILL VIDEO_DEPTH {TYPE LOCAL; VAL 8; }
ENDIF;

/////Level Init/////

STRING levelbase, "level";
STRING wmb, ".wmb";
STRING levelload, "............";
STRING level_str, "   ";

SKILL episode1 {TYPE LOCAL; X 1; Y 1; Z 1;}
SKILL episode2 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL episode3 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL episode4 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL episode5 {TYPE LOCAL; X 0; Y 0; Z 0;}
//X=current level
//Y=start level
//Z=number of levels

STRING userbase, "........";
STRING userbase1, "user1";
STRING userbase2, "user2";
STRING userbase3, "user3";
STRING userbase4, "user4";
STRING userbase5, "user5";
SKILL user1 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL user2 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL user3 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL user4 {TYPE LOCAL; X 0; Y 0; Z 0;}
SKILL user5 {TYPE LOCAL; X 0; Y 0; Z 0;}
//X=current level
//Y=start level
//Z=number of levels

/////Shadow Skills/Strings/////

SKILL episode1_s {X 1; Y 1; Z 1;}
SKILL episode2_s {X 0; Y 0; Z 0;}
SKILL episode3_s {X 0; Y 0; Z 0;}
SKILL episode4_s {X 0; Y 0; Z 0;}
SKILL episode5_s {X 0; Y 0; Z 0;}
SKILL user1_s {X 0; Y 0; Z 0;}
SKILL user2_s {X 0; Y 0; Z 0;}
SKILL user3_s {X 0; Y 0; Z 0;}
SKILL user4_s {X 0; Y 0; Z 0;}
SKILL user5_s {X 0; Y 0; Z 0;}

FONT standard_font,<msgfonts.pcx>,7,11;
//////////Key Synonyms//////////

DEFINE _PLAYER_UP,KEY_CUU;
DEFINE _PLAYER_DOWN,KEY_CUD;
DEFINE _PLAYER_LEFT,KEY_CUL;
DEFINE _PLAYER_RIGHT,KEY_CUR;
DEFINE _PLAYER_JUMP,KEY_CUU;
DEFINE _PLAYER_DUCK,KEY_CUD;
DEFINE _ZOOM_IN ,KEY_INS;
DEFINE _ZOOM_OUT,KEY_DEL;

DEFINE _PLAYER2_UP,KEY_H;
DEFINE _PLAYER2_DOWN,KEY_N;
DEFINE _PLAYER2_LEFT,KEY_B;
DEFINE _PLAYER2_RIGHT,KEY_M;
DEFINE _PLAYER2_JUMP,KEY_J;
DEFINE _CAM2_LEFT,KEY_5;
DEFINE _CAM2_RIGHT,KEY_6;

SKILL ladder_top {VAL 0;}
SKILL ladder_bottom {VAL 0;}
SKILL ladder_top2 {VAL 0;}
SKILL ladder_bottom2 {VAL 0;}
SKILL ladder_dist {}
SKILL D3D_PANELS {VAL 0;}
SKILL MIP_SHADED {VAL 0.5;}
SKILL move_mode {VAL 1;}

//////////
VIEW camera2 {
#	FLAGS VISIBLE;
}

///////////////////////////////////////////////////////////////////////////////////
// A4 alpha test wdl
///////////////////////////////////////////////////////////////////////////////////
PATH	"..\\template";		// Path to templates subdirectory

INCLUDE <movement.wdl>;
INCLUDE <menu.wdl>;
#INCLUDE <movemen2.wdl>;
INCLUDE <debug.wdl>;

////////////////////////////////////////////////////////////////////////////

BMAP splash_map, <splash.bmp>;

FONT display_font, <font.pcx>,8,11;
FONT menu_font, <bigfont.pcx>,10,16;

PANEL splash_pan {
BMAP splash_map;
FLAGS OVERLAY,REFRESH;
}

MAIN _main;

ACTION _main {
	CALL _init_settings;
#	LOAD_LEVEL	<level1.wmb>;
//test//
#	SET_STRING levelload,levelbase;
#	TO_STRING level_str,episode1.Y;
#	ADD_STRING levelload,level_str;
#	ADD_STRING levelload,wmb;
#	LOAD_LEVEL levelload;
//test - end//

	SET splash_pan.VISIBLE,1;
	WAITT 16;
	SET splash_pan.VISIBLE,0;

	CALL set_debug;
	IFDEF d3d;
	SET CAMERA.FOG,40;	
	IFELSE;
	SET CAMERA.FOG,28;
	ENDIF;
}

ACTION _init_settings {
	LOAD_INFO "game",1;

	episode1_s.X=episode1.X;
	episode1_s.Y=episode1.Y;
	episode1_s.Z=episode1.Z;
	episode2_s.X=episode2.X;
	episode2_s.Y=episode2.Y;
	episode2_s.Z=episode2.Z;
	episode3_s.X=episode3.X;
	episode3_s.Y=episode3.Y;
	episode3_s.Z=episode3.Z;
	episode4_s.X=episode4.X;
	episode4_s.Y=episode4.Y;
	episode4_s.Z=episode4.Z;
	episode5_s.X=episode5.X;
	episode5_s.Y=episode5.Y;
	episode5_s.Z=episode5.Z;

	LOAD_INFO "user",1;
	user1_s.X=user1.X;
	user1_s.Y=user1.Y;
	user1_s.Z=user1.Z;

	LOAD_INFO "user",2;
	user2_s.X=user2.X;
	user2_s.Y=user2.Y;
	user2_s.Z=user2.Z;

	LOAD_INFO "user",3;
	user3_s.X=user3.X;
	user3_s.Y=user3.Y;
	user3_s.Z=user3.Z;

	LOAD_INFO "user",4;
	user4_s.X=user4.X;
	user4_s.Y=user4.Y;
	user4_s.Z=user4.Z;

	LOAD_INFO "user",5;
	user4_s.X=user4.X;
	user4_s.Y=user4.Y;
	user4_s.Z=user4.Z;

	LOAD_INFO "config",VIDEO_DEPTH;	

	episode1.X=episode1_s.X;
	episode1.Y=episode1_s.Y;
	episode1.Z=episode1_s.Z;
	episode2.X=episode2_s.X;
	episode2.Y=episode2_s.Y;
	episode2.Z=episode2_s.Z;
	episode3.X=episode3_s.X;
	episode3.Y=episode3_s.Y;
	episode3.Z=episode3_s.Z;
	episode4.X=episode4_s.X;
	episode4.Y=episode4_s.Y;
	episode4.Z=episode4_s.Z;
	episode5.X=episode5_s.X;
	episode5.Y=episode5_s.Y;
	episode5.Z=episode5_s.Z;
	user1.X=user1_s.X;
	user1.Y=user1_s.Y;
	user1.Z=user1_s.Z;
	user2.X=user1_s.X;
	user2.Y=user1_s.Y;
	user2.Z=user1_s.Z;
	user3.X=user1_s.X;
	user3.Y=user1_s.Y;
	user3.Z=user1_s.Z;
	user4.X=user1_s.X;
	user4.Y=user1_s.Y;
	user4.Z=user1_s.Z;
	user5.X=user1_s.X;
	user5.Y=user1_s.Y;
	user5.Z=user1_s.Z;

	SET_STRING levelload,levelbase;
	TO_STRING level_str,episode1.Y;
	ADD_STRING levelload,level_str;
	ADD_STRING levelload,wmb;
	LOAD_LEVEL levelload;
}	
/////Panels/////

BMAP diamond_map, <diamond.pcx>;
BMAP armor_map, <armor.pcx>;
BMAP martek_map, <martek.pcx>;
BMAP health_map, <health.pcx>;

PANEL martek_pan {
LAYER 10;
BMAP martek_map;
POS_X 13;
POS_Y 5;
FLAGS OVERLAY,REFRESH,VISIBLE;
}

PANEL health_pan {
LAYER 10;
BMAP health_map;
POS_X 60;
POS_Y 5;
FLAGS OVERLAY,REFRESH,VISIBLE;
}

PANEL armor_pan {
LAYER 10;
BMAP armor_map;
POS_X 130;
POS_Y 5;
FLAGS OVERLAY,REFRESH,VISIBLE;
}

PANEL diamond_pan {
LAYER 10;
BMAP diamond_map;
POS_X 200;
POS_Y 5;
FLAGS OVERLAY,REFRESH,VISIBLE;
}

PANEL display_pan {
LAYER 10;
DIGITS 30,5,1,menu_font,1,player.LIVES;
DIGITS 80,5,3,menu_font,1,player.HEALTH;
DIGITS 150,5,3,menu_font,1,player.FULLARMOR;
DIGITS 220,5,5,menu_font,1,player.SCORE;
POS_X 5;
POS_Y 5;
FLAGS OVERLAY,REFRESH,VISIBLE;
}

/////Entity-Actions/////


ACTION Idiamond {
	SET MY.EVENT,_Idiamond_collect;
	SET MY.ENABLE_IMPACT,ON;
	SET MY.ENABLE_PUSH,ON;
	SET MY.SKILL1,10;
	MY.AMBIENT=30;
	MY.TILT=21;
	WHILE (1) {
		MY.PAN+=6*TIME;
		WAIT 1;
	}
}

ACTION _Idiamond_collect {
	YOUR.SCORE+=MY.SKILL1;
	REMOVE ME;
}

ACTION Xarmor {
MY.SKIN=1;#MY.SKILL1;
SET MY.EVENT, _Xarmor_event;
SET MY.ENABLE_IMPACT,ON;
SET MY.ENABLE_PUSH,ON;
WHILE (MY.PASSABLE==0) {
	MY.PAN+=5*TIME;
	wait 1;
}
}

ACTION _Xarmor_event {
SET MY.PASSABLE,ON;
#SET MY.SKIN,2;
YOUR.ARMOR=100;
SET player1_armor,ME;
}

ACTION Xhelmet {
MY.SKIN=1;#MY.SKILL1;
SET MY.EVENT, _Xhelmet_event;
SET MY.ENABLE_IMPACT,ON;
SET MY.ENABLE_PUSH,ON;
WHILE (MY.PASSABLE==0) {
	MY.PAN+=5*TIME;
	wait 1;
}
}

ACTION _Xhelmet_event {
SET MY.PASSABLE,ON;
#SET MY.SKIN,2;
YOUR.HELMET=50;
SET player1_helmet,ME;
}

ACTION Xanim {
WHILE (1) {
MY.FRAME += FRC(MY.SKILL1)*10*TIME; 
IF (MY.FRAME >INT( MY.SKILL1)) {
MY.FRAME = 1; }
WAIT 1;
}
}

ACTION Xflare {
SET MY.AMBIENT,100;
IFDEF d3d;
SET MY.FLARE,ON;
ENDIF;
SET MY.FAT,OFF;
SET MY.NARROW,ON;
IF (MY.FLAG2!=ON) {
	SET MY.FACING,ON;
}
ELSE {
	SET MY.TILT,MY.SKILL8;
	IF (MY.TILT!=0) {
		SET MY.ORIENTED,ON;
	}
}
IF (MY.FLAG1!=ON) {
	END;
}
MY.LIGHTRANGE=MY.SKILL1;
MY.LIGHTRED=MY.SKILL2;
MY.LIGHTGREEN=MY.SKILL3;
MY.LIGHTBLUE=MY.SKILL4;
}

ACTION Xladder {
SET MY.EVENT,_Xladder_event;
SET MY.ENABLE_SCAN,ON;
}

ACTION _Xladder_event {
IF (YOUR._MOVEMODE==_MODE_CLIMBING) {END;}
	SET jump_ready,0;
	IF (YOU==player) {
		IF (MY.FLAG1!=1) {
			MY.SKILL3=YOUR.X;
			MY.SKILL4=YOUR.Y;
			SET MY.FLAG1,ON;
		}
		SET ladder,ME;
	}
	SET YOUR.PAN,MY.PAN;
	YOUR.X=MY.X-16*COS(MY.PAN);
	YOUR.Y=MY.Y-16*SIN(MY.PAN);
#	IF (YOU==player2) {
#		SET ladder_top2,MY.SKILL2;
#		SET ladder_bottom2,MY.SKILL1;
#	}
	SET ME,YOU;
#	WAIT 1;
	SET MY._MOVEMODE,_MODE_CLIMBING;
#}
}

ACTION Xteleport { 
SET MY.EVENT,_Xteleport_event; 
SET MY.ENABLE_SCAN,ON; 
WHILE (1) {
	MY.LIGHTRANGE=100+RANDOM(20);
	MY.LIGHTRED=32+RANDOM(20);
	MY.LIGHTGREEN=140+RANDOM(8)+RANDOM(12);
	MY.LIGHTBLUE=86+RANDOM(5)+RANDOM(15);
	temp=3*TIME;
	EMIT temp,MY.POS,_Xteleport_particle;
	WAIT 3;
} 
}

ACTION _Xteleport_event { 
#IF (MY.FLAG5==ON) {
#	IF (YOUR==player) {move_mode=0;}
#	IF (YOUR==player2) {move_mode2=0;}
#	WAITT MY.SKILL5;
#	}
force.X=0;
force.Y=0;
force.Z=0;
YOUR.X = MY.SKILL1; 
YOUR.Y = MY.SKILL2; 
YOUR.Z = MY.SKILL3; 
#IF (MY.FLAG4==ON) {
	YOUR.PAN=MY.SKILL4;
#}
#IF (YOUR==player) {
#	camera.X=MY.SKILL1;
#	camera.Y=MY.SKILL2;
#	camera.Z=MY.SKILL3;
#	move_mode=1;
#}
} 

BMAP blue_particle_map, <part_blu.pcx>;
BMAP green_particle_map, <part_grn.pcx>;

ACTION _Xteleport_particle {
	IF (MY_AGE==0) {
		MY_POS.X=MY_POS.X-16+RANDOM(16)*2;
		MY_POS.Y=MY_POS.Y-16+RANDOM(16)*2;
		MY_POS.Z+=RANDOM(15);
		MY_COLOR.RED=32;
		MY_COLOR.GREEN=140;
		MY_COLOR.BLUE=86;
		IF (RANDOM(2)<1) {
			SET MY_MAP,blue_particle_map;
		} ELSE {
			SET MY_MAP,green_particle_map;
		}
		MY_SIZE=250;
		MY_SPEED.Z=1.5+RANDOM(1);
		IFDEF d3d;
			SET MY_FLARE,ON;
		IFELSE;
			SET MY_TRANSPARENT,ON;
		ENDIF;
	}
	IF (MY_AGE >=30) {
		SET MY_ACTION,NULL;
	}
}

ACTION XSanimflare{
CALL Xflare;
CALL Xanim;
}

///////////////////////////////////////////////////////////////////////////////////

WINDOW WINSTART
{
	TITLE			"A4 office test level";
	SIZE			480,320;
	MODE			IMAGE;	//STANDARD;
	BG_COLOR		RGB(240,240,240);
	FRAME			FTYP1,0,0,480,320;
//	BUTTON		BUTTON_START,SYS_DEFAULT,"Start",400,288,72,24;
	BUTTON		BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
	TEXT_STDOUT	"Arial",RGB(0,0,0),10,10,460,280;
}

/* no exit window at all..
WINDOW WINEND
{
	TITLE			"Finished";
	SIZE			540,320;
	MODE	 		STANDARD;
	BG_COLOR		RGB(0,0,0);
	TEXT_STDOUT	"",RGB(255,40,40),10,20,520,270;

	SET FONT		"",RGB(0,255,255);
	TEXT			"Any key to exit",10,270;
}*/

/////////////////////////////////////////////////////////////////
//INCLUDE <debug.wdl>;

//////////CONSOLE//////////

STRING exec_buffer,	// just an 80-char string
"                                                                              ";
TEXT console_txt {
	POS_X 4;
	LAYER	10;
	FONT 	standard_font;
	STRINGS 2;
	STRING "Enter instruction(s) below:";
	STRING exec_buffer;
	FLAGS CONDENSED;
}

ACTION console {
	console_txt.POS_Y = SCREEN_SIZE.Y - 50;
	SET	console_txt.VISIBLE,1;
	INKEY	exec_buffer;
	IF (RESULT == 13) { EXECUTE exec_buffer; }
	IF (RESULT == 0) { BEEP; }
	SET	console_txt.VISIBLE,0;
}

ON_TAB console;
