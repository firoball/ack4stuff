///////////////////////////////////////////////////////////////////////////////////
// ~ Shadows of the Lost Citadel ~ Main WDL
//
// created by Firoball  1/13/2001
// last modified  2/10/2001 by Firoball
///////////////////////////////////////////////////////////////////////////////////

/*
Last changes

-Fog_color and Clip_range defaults changed
*/

VAR VIDEO_DEPTH=16;
VAR VIDEO_MODE=6;
VAR CLIP_RANGE=1450;
//VAR FOG_COLOR=1;

ENTITY fog1_ent {
        TYPE=<fog.mdl>;
        LAYER=4;
        AMBIENT=-60;
        VIEW=CAMERA;
        X=450;
        Y=0;
        Z=0;
        FLAGS OVERLAY,FLARE;
}

ENTITY fog2_ent {
        TYPE=<fog.mdl>;
        LAYER=5;
        AMBIENT=-57;
        VIEW=CAMERA;
        X=320;
        Y=0;
        Z=0;
        FLAGS OVERLAY,FLARE;
}

ENTITY fog3_ent {
        TYPE=<fog.mdl>;
        LAYER=6;
        AMBIENT=-54;
        VIEW=CAMERA;
        X=250;
        Y=0;
        Z=0;
        FLAGS OVERLAY,FLARE;
}

ENTITY fog4_ent {
        TYPE=<fog.mdl>;
        LAYER=7;
        AMBIENT=-50;
        VIEW=CAMERA;
        X=150;
        Y=0;
        Z=0;
        FLAGS OVERLAY,FLARE;
}

INCLUDE <movement.wdl>;
INCLUDE <invent.wdl>;

MAIN startup;

FUNCTION startup()
{
        LOAD_LEVEL <forest.wmb>;
//        LOAD_LEVEL <testwall.wmb>;
        set_timer(); //see movement wdl
        init_fog();
//        camset.z=400;
//        camset.y=-45;
}

FUNCTION init_fog()
{
        fog1_ent.VISIBLE=1;
        fog2_ent.VISIBLE=1;
        fog3_ent.VISIBLE=1;
        fog4_ent.VISIBLE=1;
        WHILE (1)
        {
                fog1_ent.y=250*SIN(timer*0.35);
                fog2_ent.y=-225*SIN((timer+180)*0.4);
                fog3_ent.y=200*SIN((timer+90)*0.25);
                fog4_ent.y=-175*SIN((timer+270)*0.3);
                fog1_ent.z=-12+5*COS(timer*2);
                fog2_ent.z=-18+5*COS(timer*2);
                fog3_ent.z=-33+5*COS(timer*2);
                fog4_ent.z=-45+5*COS(timer*2);
                WAIT 1;
        }
}