FONT debug_font,<ackfont.pcx>,6,9;

panel debug_pan
{
        flags visible,refresh;
        DIGITS        50,0,1,debug_font,1,kfire;
        DIGITS        50,10,1,debug_font,1,ksfire;
        DIGITS        50,20,1,debug_font,1,kstrafe;
        DIGITS        50,30,1,debug_font,1,kright;
        DIGITS        50,40,1,debug_font,1,kleft;
        DIGITS        50,50,1,debug_font,1,kdown;
        DIGITS        50,60,1,debug_font,1,kup;

        DIGITS        150,0,1,debug_font,1,t0;
        DIGITS        150,10,1,debug_font,1,t1;
        DIGITS        150,20,1,debug_font,1,t2;
        DIGITS        150,30,1,debug_font,1,t3;
        DIGITS        150,40,1,debug_font,1,t4;
        DIGITS        150,50,1,debug_font,1,t5;
        DIGITS        150,60,1,debug_font,1,t6;

        DIGITS        150,70,3,debug_font,1,player.ctrl;
        DIGITS        50,70,5,debug_font,1,player.ptrhandle;
        DIGITS        50,80,5,debug_font,1,sphere.ptrhandle;
}