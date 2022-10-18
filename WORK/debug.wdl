/////////////////////////////////////////////////////////
// Debug panel - to display fps*10, nexus and error skill
/////////////////////////////////////////////////////////
IFNDEF debug_font;
	FONT debug_font,<ackfont.pcx>,6,9;
//	FONT debug_font,<ledfont.pcx>,10,22;
ENDIF;

SKILL	fps { VAL 1; }

SKILL d_ang { }
SKILL d_vec { X 1; Y 1; Z 0; }

/////////////////////////////////////////////////////////
PANEL debug_panel {
	POS_X		0;
	POS_Y		2;
	DIGITS	0,0,3,debug_font,16,fps;
	DIGITS	20,0,4,debug_font,1,sys_seconds;
/*
	DIGITS	50,0,4,debug_font,100,MOUSE_FORCE.X;	//NORMAL.Y;
	DIGITS	90,0,4,debug_font,100,MOUSE_FORCE.Y;	//debug_val;	//CAMERA.X;
	DIGITS	120,0,4,debug_font,100,my_floornormal.Z;	//debug_val;	//CAMERA.X;
	DIGITS	150,0,4,debug_font,1,HIT.Z;
	DIGITS	180,0,4,debug_font,10,absforce.X;
	DIGITS	210,0,4,debug_font,10,absforce.Y;
	DIGITS	240,0,4,debug_font,10,force.X;
*/
	DIGITS	60,0,4,debug_font,1,temp_dist.Z;	//NORMAL.Y;
	DIGITS	90,0,4,debug_font,1,temp_dist2.Z;	//NORMAL.Y;
	DIGITS	120,0,4,debug_font,1,total_frames;
//	DIGITS	60,0,4,debug_font,10,my_floornormal.X;	//NORMAL.Y;
//	DIGITS	90,0,4,debug_font,10,my_floornormal.Y;	//debug_val;	//CAMERA.X;
//	DIGITS	120,0,4,debug_font,10,my_floornormal.Z;	//debug_val;	//CAMERA.X;

//	DIGITS	150,0,5,debug_font,1,D3D_TEXSIZE.X;
//	DIGITS	190,0,5,debug_font,1,D3D_TEXSIZE.Y;
//	DIGITS	230,0,5,debug_font,1,D3D_TEXSIZE.Z;

#	DIGITS	130,0,4,debug_font,10,NORMAL.Y;	//debug_val;	//CAMERA.X;
#	DIGITS	170,0,4,debug_font,10,NORMAL.Z;	//debug_val;	//CAMERA.X;

	# Zeitmessung
#	DIGITS	275,0,2,standard_font,1,CD_TRACK;

	FLAGS	TRANSPARENT,REFRESH;
}

STRING	debug_labels_1,
	"fps";	// res_x res_y x   y";
#	"fps nx mdist  vx cl slc drw buf ob ac  clp  max  m";

TEXT	debug_text {
	POS_X		0;
	POS_Y		2;
	FONT		standard_font;
	STRING	TEX_NAME;	//debug_labels_1;
}
///////////////////////////////////////////////
ACTION set_debug {
	SET	debug_panel.VISIBLE,ON;
	SET	debug_text.VISIBLE,ON;
	WHILE (1) {	// forever
		debug_panel.POS_Y = SCREEN_SIZE.Y - 15;
		debug_text.POS_Y = SCREEN_SIZE.Y - 29;
		fps = 0.9*fps + 0.1*TIME_FAC;
		WAIT	1;
	}
}