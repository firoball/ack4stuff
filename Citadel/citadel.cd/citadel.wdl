///////////////////////////////////////////////////////////////////////////////////
// ~ Shadows of the Lost Citadel ~ Main WDL
//
// created by Firoball  1/13/2001
// last modified  1/19/2001 by Firoball
///////////////////////////////////////////////////////////////////////////////////

/*
Last changes

-Fog_color and Clip_range defaults changed
*/

VAR VIDEO_DEPTH=16;
VAR VIDEO_MODE=6;
VAR CLIP_RANGE=1600;
VAR FOG_COLOR=1;

INCLUDE <movement.wdl>;

MAIN startup;

FUNCTION startup()
{
        LOAD_LEVEL <forest.wmb>;
        set_timer(); //see movement wdl
}