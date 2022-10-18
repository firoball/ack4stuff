///////////////////////////////////////////////////////////////////////////////////
// ~ Shadows of the Lost Citadel ~ Movement WDL v0.003
//
// created by Firoball  1/13/2001
// last modified  1/19/2001 by Firoball
///////////////////////////////////////////////////////////////////////////////////

/*
Last changes

- camera even further optimized
- skydome with test texture added
*/

SYNONYM player {TYPE ENTITY;}

VAR timer[2]=0,0;
VAR temp[3];
VAR temp_pos[3];
VAR camdist;
VAR camset[3]=2,-5,300;
//camset.X = inertia (10 = no inertia, 1 = max)
//camset.TILT = camera tilt angle
//camset.Z = camera distance to player

//Change DEFINEs for different control settings
DEFINE PLAYER_FORWARD,KEY_CUU;
DEFINE PLAYER_BACKWARD,KEY_CUD;
DEFINE PLAYER_TURNLEFT,KEY_CUL;
DEFINE PLAYER_TURNRIGHT,KEY_CUR;
DEFINE PLAYER_ACTION,KEY_SPACE;

//Redefine Actor Skills (10-19 are used!)
DEFINE speed,SKILL10; //speed vector
DEFINE speedX,SKILL10; //forward speed
DEFINE speedY,SKILL11; //strafe speed
DEFINE speedZ,SKILL12; //falling speed (not supported yet)
DEFINE speedRot,SKILL13; //Azimuth rotation speed
DEFINE walkmode,SKILL14; //walk modes
//-1= movement blocked, not animated
//0 = not moving, animated
//1 = walking
//2 = charging for attack
//3 = attack blow
//4 = hit
//5 = dying
DEFINE anim_dist,SKILL15; //for animating
DEFINE total_dist,SKILL16; //for animating
DEFINE anim_time,SKILL17; //for animating
DEFINE anim_tot,SKILL18; //for animating
DEFINE anim_fac,SKILL19; //factor for animation speed

STRING base_str, "base";
STRING wait_str, "wait";
STRING walk_str, "walk";
STRING charge_str, "charge";
STRING attack_str, "attack";
STRING hit_str, "hit";
STRING die_str, "die";

ACTION init_player {
        SET player,ME;
        MY.SKIN=5;
        MY.anim_fac=6.5;//4.5;
//        WAIT 1;
        SONAR ME,300;
        MY.Z=TARGET.Z-MY.MIN_Z+3;
        MY.SHADOW=1;
        MY.walkmode=1;
        camdist=camset.Z;
//        MY.LIGHTRANGE=300;
        MY.LIGHTRED=240;
        MY.LIGHTGREEN=190;
        MY.LIGHTBLUE=80;
        CREATE <skydome.mdl>,MY.POS,init_skydome;
        WHILE(1)
        {
                key_input();
//                move_actor();
                move_camera();
//                set_lantern();
                WAIT 1;
        }
}

FUNCTION set_lantern()
{
        MY.LIGHTRANGE=600+100*SIN(timer*4);
}

FUNCTION move_actor()
{
                IF (MY.walkmode==-1)
                {
                        SET_FRAME ME,base_str,0;
                }
                IF (MY.walkmode==0)
                {
                        anim_wait();
                }
                IF (MY.walkmode==1)
                {
                        actor_walk();
                }
                IF (MY.walkmode==2)
                {
                        anim_charge();
                }
                IF (MY.walkmode==3)
                {
                        anim_attack();
                }
                IF (MY.walkmode==4)
                {
                        anim_hit();
                }
                IF (MY.walkmode==5)
                {
                        anim_die();
                }
}
///////////////////////////////////////////////////////////////////////////////////

FUNCTION key_input()
{
        player.speedX=(PLAYER_FORWARD-PLAYER_BACKWARD)*28*TIME;
        player.speedY=0;
        player.speedZ=0;
        player.speedRot=(PLAYER_TURNLEFT-PLAYER_TURNRIGHT)*8*TIME;
        move_actor();
}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION actor_walk()
{
        SET YOU,NULL;
        VEC_SET (temp_pos,MY.X);
        MY.PAN+=MY.speedRot;
        MOVE ME,MY.speed,NULLVECTOR;
        SONAR ME,300;
        MY.Z=TARGET.Z-MY.MIN_Z+3;
        IF (ABS(NORMAL.X)>0.45 || ABS(NORMAL.Y)>0.45)
        {
                VEC_SET (MY.X,temp_pos);
        }
        anim_walk();
}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION anim_walk()
{
        MY.anim_dist = MY.total_dist + ABS(MY.speedX) / (MY.MAX_X-MY.MIN_X);
        IF (MY.anim_dist > MY.anim_fac)
        {
                MY.anim_dist -= MY.anim_fac;
        }
        temp = 100 * MY.anim_dist/MY.anim_fac;

        SET_CYCLE ME,walk_str,temp;
        IF (MY.speed<0.01)
        {
                MY.walkmode=0;
        }
/*
        IF (MY.anim_dist < MY.total_dist)
        {
                PLAY_ENTSOUND ME,tap_snd,500;
        }
        IF ((MY.anim_dist > MY.anim_fac*0.5) && (MY.total_dist < MY.anim_fac*0.5))
        {
                PLAY_ENTSOUND ME,tap_snd,500;
        }
*/
        MY.total_dist=MY.anim_dist;
//        VEC_SET (MY.speed,NULLVECTOR);
}

FUNCTION anim_charge()
{
        MY.anim_time = MY.anim_tot+TIME;
        IF (MY.anim_time > 4)
        {
                MY.anim_tot=0;
                MY.walkmode=3;
//                PLAY_ENTSOUND ME,attack_snd,500;
//Create Flash for sword attack (disabled)
/*
                CREATE <flash.mdl>,MY.POS,_flash;
                YOUR.FLARE=1;
                YOUR.PASSABLE=1;
                YOUR.UNLIT=1;
                YOUR.AMBIENT=100;
*/
                RETURN;
        }
        temp = 100 * MY.anim_time/4;

        SET_FRAME ME,charge_str,temp;
        MY.anim_tot=MY.anim_time;
}

FUNCTION anim_attack()
{
        MY.anim_time = MY.anim_tot+TIME;
        IF (MY.anim_time > 3)
        {
                MY.walkmode=1;
                MY.anim_tot=0;
                MY.FLAG8=0;
                RETURN;
        }
        temp = 100 * MY.anim_time/3;
        SET_FRAME ME,attack_str,temp;
        MY.anim_tot=MY.anim_time;
        IF (temp>=50 && MY.FLAG8!=1)
        {
                MY.FLAG8==1;
                MY_ANGLE.PAN = MY.PAN;
                MY_ANGLE.TILT = 0;
                MY_POS.PAN = 120;
                MY_POS.TILT = 160;
                MY_POS.Z = 80;
                SCAN MY.POS,MY_ANGLE,MY_POS;
//First Scan next Target, then shoot it (currently deactivated)
/*
                IF (RESULT==0) {RETURN;}
                YOU=MY.ENTITY1;
                IF (MY.ENTITY1==NULL) {RETURN;}
                TRACE_MODE = IGNORE_ME + IGNORE_PASSABLE + ACTIVATE_SHOOT;
                TRACE (MY.X,YOU.X);
                MY.ENTITY1=NULL;
*/
        }
}

FUNCTION anim_hit()
{
//Emit Particles when hit (deactivated)
/*
        IF (VIDEO_DEPTH!=8) {
                EMIT 10,MY.POS,Xhit_event;
        }
*/
        MY.anim_time = MY.anim_tot+TIME;
        IF (MY.anim_time > 4) {
                MY.walkmode=1;
                MY.anim_tot=0;
//                PLAY_ENTSOUND ME,ouch_snd,500;
                RETURN;
        }
                temp = 100 * MY.anim_time/4;

                SET_FRAME ME,hit_str,temp;
                MY.anim_tot=MY.anim_time;
}

FUNCTION anim_wait()
{
        IF (MY.speed!=0 ||MY.speedRot!=0)
        {
                MY.walkmode=1;
                RETURN;
        }
        MY.anim_time = MY.anim_tot+TIME;
        IF (MY.anim_time > 6)
        {
                MY.anim_time-=6;
        }
                temp = 100 * MY.anim_time/6;

                SET_FRAME ME,wait_str,temp;
                MY.anim_tot=MY.anim_time;
}

FUNCTION anim_die()
{
        MY.anim_time = MY.anim_tot+TIME;
        IF (MY.anim_time > 4)
        {
                MY.anim_tot=0;
                MY.walkmode=-1;
                RETURN;
        }
                temp = 100 * MY.anim_time/4;

                SET_FRAME ME,wait_str,temp;
                MY.anim_tot=MY.anim_time;
}
///////////////////////////////////////////////////////////////////////////////////

FUNCTION move_camera()
{
        CAMERA.PAN += 0.1*camset.X * ANG(MY.PAN-CAMERA.PAN)*MIN(1,TIME);
        CAMERA.TILT = camset.TILT+3*SIN(timer*4);
        IF (ABS(ANG(MY.PAN-CAMERA.PAN))<0.5)
        {
                CAMERA.PAN=MY.PAN;  //to avoid flickering
        }

        IF (MY.walkmode!=1)
        {
                camdist-=(1+camdist/(camset.Z*0.7+camset.Z*0.3*camset.X/10)*3)*TIME;
                camdist=MAX(camdist,camset.Z*0.7+camset.Z*0.3*camset.X/10);
        }
        ELSE
        {
                camdist+=(1+camset.Z/camdist*3)*TIME;
                camdist=MIN(camdist,camset.Z);
        }

        temp.X=MY.X-camdist*COS(CAMERA.PAN)*COS(CAMERA.TILT)-CAMERA.X;
        temp.Y=MY.Y-camdist*SIN(CAMERA.PAN)*COS(CAMERA.TILT)-CAMERA.Y;
        temp.Z=MY.Z+40-camdist*SIN(CAMERA.TILT)-CAMERA.Z;
        MOVE_VIEW CAMERA,NULLVECTOR,temp;

}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION set_timer()
{
        WHILE(1)
        {
                timer+=TIME;
                WAIT 1;
        }
}

///////////////////////////////////////////////////////////////////////////////////

FUNCTION init_skydome()
{
        MY.PASSABLE=1;
        MY.AMBIENT=100;
        MY.UNLIT=1;
        MY.AMBIENT=100;
        WHILE(1)
        {
                VEC_SET(MY.X,YOUR.X);
                MY.PAN+=0.3*TIME;
                WAIT 1;
        }
}