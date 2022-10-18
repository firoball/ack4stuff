//----------------------------------------
// Bildschirmanzeige für Framerate und Spielerposition
//----------------------------------------


FONT debug_font,<ackfont.pcx>,6,9;
SKILL fps { VAL 1; }

PANEL debug_pan {
	POS_X	0;
	POS_Y	2;
	DIGITS	0,0,3,debug_font,16,fps;
	DIGITS	24,0,4,debug_font,1,player.X;
	DIGITS	54,0,4,debug_font,1,player.Y;
	DIGITS	84,0,4,debug_font,1,player.Z;
	DIGITS	114,0,4,debug_font,1,episode2;
	DIGITS	144,0,4,debug_font,1,user1;
	FLAGS	TRANSPARENT,REFRESH;
}

STRING	debug_str,
	"fps x    y    z";

TEXT debug_txt {
	POS_X	0;
	POS_Y	2;
	FONT	debug_font;
	STRING	debug_str;
}

//----------------------------------------
// Anzeige aktivieren
//----------------------------------------

ACTION set_debug {
	SET debug_pan.VISIBLE,ON;
	SET debug_txt.VISIBLE,ON;
	WHILE (1) {
		debug_pan.POS_Y = SCREEN_SIZE.Y - 15;
		debug_txt.POS_Y = SCREEN_SIZE.Y - 29;
		fps = 0.9*fps + 0.1*TIME_FAC;
		WAIT	1;
	}
}
