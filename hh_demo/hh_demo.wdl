path "models";        // Path to model subdirectory - if any
path "sounds";        // Path to sound subdirectory - if any
path "bmaps";                // Path to graphics subdirectory - if any
Path "J:\\A4BETA\\template";        // Path to WDL templates subdirectory

//include <movement.wdl>;

var video_mode = 7;
var video_depth = 16;
var compatibility=0;

ifdef HICOLOR;
        var VIDEO_DEPTH=32;
endif;
ifdef VIDEO1;
        var VIDEO_MODE = 1;    // V320x200
endif;
ifdef VIDEO2;
        var VIDEO_MODE = 2;    // V320x240
endif;
ifdef VIDEO3;
        var VIDEO_MODE = 3;    // V320x400
endif;
ifdef VIDEO4;
        var VIDEO_MODE = 4;    // V400x300
endif;
ifdef VIDEO5;
        var VIDEO_MODE = 5;    // V512x384
endif;
ifdef VIDEO6;
        var VIDEO_MODE = 6;    // V640x480
endif;
ifdef VIDEO7;
        var VIDEO_MODE = 7;    // V800x600
endif;
ifdef VIDEO8;
        var VIDEO_MODE = 8;    // V1024x768
endif;
ifdef VIDEO9;
        var VIDEO_MODE = 9;    // V1280x960
endif;
ifdef VIDEO10;
        var VIDEO_MODE = 10;   // V1600x1200
endif;

bind <msg1.pcx>;
bind <msg2.pcx>;
bind <msg3.pcx>;
bind <msg4.pcx>;
bind <msg5.pcx>;
bind <msg6.pcx>;
bind <msg7.pcx>;
bind <msg8.pcx>;
bind <msg9.pcx>;
bind <msg10.pcx>;
bind <msg11.pcx>;
bind <msg12.pcx>;
bind <msg13.pcx>;
bind <msg14.pcx>;
bind <msg15.pcx>;
bind <msg16.pcx>;
bind <msg17.pcx>;
bind <msg18.pcx>;

bind <gchar1.pcx>;
bind <gchar2.pcx>;
bind <gchar3.pcx>;
bind <gchar4.pcx>;
bind <gchar5.pcx>;
bind <gchar6.pcx>;
bind <echar1.pcx>;
bind <echar2.pcx>;
bind <echar3.pcx>;
bind <echar4.pcx>;
bind <echar5.pcx>;
bind <echar6.pcx>;

bind <good1.pcx>;
bind <good2.pcx>;
bind <good3.pcx>;
bind <good4.pcx>;
bind <good5.pcx>;
bind <good6.pcx>;

bind <evil1.pcx>;
bind <evil2.pcx>;
bind <evil3.pcx>;
bind <evil4.pcx>;
bind <evil5.pcx>;
bind <evil6.pcx>;

bind <credits1.pcx>;
bind <credits2.pcx>;
bind <credits3.pcx>;
bind <credits4.pcx>;
bind <credits5.pcx>;
bind <credits6.pcx>;

bind <ackfont.pcx>; //bug?

var timer=0;
var helltimer=0;
var heaventimer=0;
var fps_max=30;
var scene=0;
var scenefade=0;
var sndhandle;
var clock_abs;
var clock;
var clock_setoff;
var warn_level=2;
var msgposx[20];
var msgposy[20];
var msgfx[20];
sound bg_music, <nb_clysm.wav>;

view heavencam
{
        arc 60;
        layer 8;
        fog=50;
}

view fadecam
{
        arc 60;
        layer 8;
        fog=50;
}

function main()
{

        if (video_depth<16)
        {
                wait 1;
                exit;
        }
        msgposx[2]=50; msgposy[2]=50; msgfx[2]=2;
        msgposx[3]=70; msgposy[3]=30; msgfx[3]=1;
        msgposx[4]=-10; msgposy[4]=-10; msgfx[4]=4;
        msgposx[5]=-30; msgposy[5]=-30; msgfx[5]=3;
        msgposx[6]=-50; msgposy[6]=-50;
        msgposx[7]=-70; msgposy[7]=-70; msgfx[7]=2;
        msgfx[8]=4;
        msgfx[9]=2;
        msgposx[10]=50; msgposy[10]=50; msgfx[10]=4;
        msgposx[11]=70; msgposy[11]=30; msgfx[11]=1;
        msgposx[12]=-10; msgposy[12]=-10; msgfx[12]=3;
        msgposx[13]=-30; msgposy[13]=-30; msgfx[13]=4;
        msgposx[14]=-50; msgposy[14]=-50;
        msgfx[15]=3;
        msgposx[16]=-70; msgposy[7]=-70; msgfx[7]=2;
        msgfx[17]=4;
        msgposx[18]=0; msgposy[18]=0; msgfx[18]=1;


        camera.pos_x=0;
        camera.pos_y=screen_size.y/6;
        camera.size_x=screen_size.x;
        camera.size_y=screen_size.y/3*2;
        camera.aspect=0.67;
        heavencam.pos_x=0;
        heavencam.pos_y=screen_size.y/6;
        heavencam.size_x=screen_size.x;
        heavencam.size_y=screen_size.y/3*2;
        heavencam.aspect=0.67;
        tex_share = on;

        wait(3);

        play_sound  (bg_music,10);
        sndhandle=result;
        wait 1;
        stop_sound (sndhandle);
        load_level(<hh_demo.WMB>);
while(1)
{
timer+=time;
helltimer+=time;
heaventimer+=time;
wait 1;
}
}

function clock_control {
        clock_abs=sys_hours*3600+sys_minutes*60+sys_seconds;
        clock_setoff=clock_abs;
        while(1)
        {
                clock_abs=sys_hours*3600+sys_minutes*60+sys_seconds;
                clock=clock_abs-clock_setoff;
                wait 1;
        }
}



/////////////////////////////////////////////////////////////////
// The following definitions are for the pro edition window composer
// to define the start and exit window of the application.
/*
WINDOW WINSTART
{
        TITLE                        "The conflict";
        SIZE                        480,320;
        MODE                        IMAGE;        //STANDARD;
        BG_COLOR                RGB(240,240,240);
        FRAME                        FTYP1,0,0,480,320;
//        BUTTON                BUTTON_START,SYS_DEFAULT,"Start",400,288,72,24;
        BUTTON                BUTTON_QUIT,SYS_DEFAULT,"Abort",400,288,72,24;
        TEXT_STDOUT        "Arial",RGB(0,0,0),10,10,460,280;
}
*/
WINDOW WINSTART
{
        TITLE                        "The Conflict";
        SIZE                        370,297;
        MODE                        IMAGE;

        BG_COLOR                RGB(0,0,0);
//        SET FONT "Courier",RGB(217,0,0);
        BG_PATTERN <logo.pcx>,OPAQUE;
}


/* no exit window at all..
WINDOW WINEND
{
        TITLE                        "Finished";
        SIZE                        540,320;
        MODE                         STANDARD;
        BG_COLOR                RGB(0,0,0);
        TEXT_STDOUT        "",RGB(255,40,40),10,20,520,270;

        SET FONT                "",RGB(0,255,255);
        TEXT                        "Any key to exit",10,270;
}*/






var speed[3];

DEFINE speedX,SKILL33;
DEFINE speedY,SKILL34;
DEFINE speedZ,SKILL35;
DEFINE targetX,SKILL43;
DEFINE targetY,SKILL44;
DEFINE targetZ,SKILL45;
DEFINE forceX,SKILL30;
DEFINE forceY,SKILL31;
DEFINE forceZ,SKILL32;

entity intro_ent
{
        type=<intro.tga>;
        x=533;
        y=0;
        z=0;
        scale_y=1.2;
        scale_x=5;
        alpha=50;
        layer=9;
        flags flare, oriented;
}

entity message_ent
{
        type=<msg1.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1;
        scale_x=1;
        alpha=35;
        layer=10;
        flags flare, oriented, bright;
}

entity acknex_ent
{
        type=<acknex.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1.2;
        scale_x=1.3;
        alpha=100;
        layer=10;
        flags transparent, oriented, bright;
}

entity conflict_ent
{
        type=<conflict.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1.1;
        scale_x=1.1;
        alpha=35;
        layer=10;
        flags flare, oriented, bright;
}

entity msg_ent
{
        type=<msg1.pcx>;
        x=450;
        y=0;
        z=0;
        scale_y=1;
        scale_x=1;
        alpha=35;
        layer=10;
        flags flare, oriented, bright;
}

entity hell_ent
{
        type=<layer.pcx>;
        x=533;
        y=250;
        scale_y=1.2;
        scale_x=0.7;
        z=0;
        alpha=40;
        flags transparent, flare, oriented;
}

entity hell2_ent
{
        type=<layer.pcx>;
        x=533;
        y=450;
        z=0;
        scale_y=-1.2;
        scale_x=0.7;
        alpha=40;
        flags transparent, flare, oriented;
}

entity hell3_ent
{
        type=<layer.pcx>;
        x=533;
        y=350;
        z=0;
        scale_y=1.2;
        scale_x=-0.7;
        alpha=40;
        flags transparent, flare, oriented;
}

entity hell4_ent
{
        type=<layer.pcx>;
        x=533;
        y=350;
        z=0;
        scale_y=-1.2;
        scale_x=-0.7;
        alpha=40;
        flags transparent, flare, oriented;
}

function swap_layers()
{
        while (scene<=2)
        {
                hell_ent.scale_Y*=-1;
                hell2_ent.scale_Y*=-1;
                hell3_ent.scale_Y*=-1;
                hell4_ent.scale_Y*=-1;
                wait 4;
        }
}

function anim_layer()
{
        while (scene<2) {wait 1;}
        hell_ent.visible=1;
        hell2_ent.visible=1;
        hell_ent.alpha=40;
        hell2_ent.alpha=20;
        hell3_ent.alpha=0;
        hell4_ent.alpha=0;
        swap_layers();
        WHILE(scene==2)
        {
                hell_ent.alpha-=time+time+time;
                hell2_ent.alpha-=time+time+time;
                hell3_ent.alpha-=time+time+time;
                hell4_ent.alpha-=time+time+time;
                hell_ent.y=250+20*sin(timer*14+30);
                hell2_ent.y=250+20*cos(timer*14+60);
                hell3_ent.y=250+20*sin(timer*14+90);
                hell4_ent.y=250+20*cos(timer*14+120);
                if (hell_ent.alpha<=25 && hell2_ent.visible==0)
                {
                        hell2_ent.alpha=40;
                        hell2_ent.visible=1;
                }
                if (hell2_ent.alpha<=25 && hell3_ent.visible==0)
                {
                        hell3_ent.alpha=40;
                        hell3_ent.visible=1;
                }
                if (hell3_ent.alpha<=25 && hell4_ent.visible==0)
                {
                        hell4_ent.alpha=40;
                        hell4_ent.visible=1;
                }
                if (hell4_ent.alpha<=25 && hell_ent.visible==0)
                {
                        hell_ent.alpha=40;
                        hell_ent.visible=1;
                }

                if (hell_ent.alpha<=0) {hell_ent.visible=0;}
                if (hell2_ent.alpha<=0) {hell2_ent.visible=0;}
                if (hell3_ent.alpha<=0) {hell3_ent.visible=0;}
                if (hell4_ent.alpha<=0) {hell3_ent.visible=0;}
                wait 1;
        }
        hell_ent.visible=0;
        hell2_ent.visible=0;
        hell3_ent.visible=0;
        hell4_ent.visible=0;
}
  function vec_randomize(&vec,range)
  {
    vec[0] = random(2) - 1;#0.5;
    vec[1] = random(2) - 1;#0.5;
    vec[2] = random(20);# - 0.5;
    vec_normalize(vec,random(range));
  }

  function part_alphafade()
  {
    my.alpha -= time+time;
    if (my.alpha <= 0) { my.lifespan = 0; }
  }

  function effect_explo()
  {
    vec_randomize(temp,50);
    vec_add(my.vel_x,temp);
    my.alpha = 25 + random(25);
    my.red=150;
    my.green=110;
    my.blue=20;
    my.flare = on;
    my.bright = on;
    my.streak=on;
    my.move = on;
    my.function = part_alphafade;
  }


function particle_emitter()
{
my.invisible=1;
my.passable=1;
my.z=-200;
wait 1;
while(scene<=2)
{
//temp=300*TIME;
  vec_scale(normal,10);
  effect(effect_explo,300,my.x,normal);
waitt 48;
}
}

var count=0;
string file_str,"123456789012";
string hell_str,"hell";
string pcx_str, ".pcx";
string number_str," ";

entity hellborder_ent
{
        type=<hellbrd.pcx>;
        layer=9;
        x=533;
        y=-270;
        z=0;
        scale_y=1.2;
        flags=oriented;
}

entity hellmsg_ent
{
        type=<hell1.pcx>;
        layer=8;
        x=300;
        y=0;
        z=0;
        flags=oriented,flare,transparent;
}

bind <hell2.pcx>;
bind <hell3.pcx>;
bind <hell4.pcx>;
bind <hell5.pcx>;
bind <hell6.pcx>;
bind <hell7.pcx>;
bind <hell8.pcx>;

function hell_msg()
{
        while (scene<2) {wait 1;}
        waitt 48;
        while(scene==2 &&scenefade<3)
        {
                wait 1;
                count+=1;
                if (count>8)
                {
                        count=1;
                }
                str_for_num(number_str,count);
                str_cpy(file_str,hell_str);
                str_cat(file_str,number_str);
                str_cat(file_str,pcx_str);
                wait 1;
                ent_morph(hellmsg_ent,file_str);
                hellmsg_ent.alpha=50;
                hellmsg_ent.y=-40+(random(140)-70);
                hellmsg_ent.z=(random(100)-50);
                hellmsg_ent.visible=1;
                while(hellmsg_ent.alpha>0)
                {
                        wait 1;
                        hellmsg_ent.alpha-=time*7;
                }
                hellmsg_ent.visible=0;
                ent_purge(hellmsg_ent);
        }
        hellmsg_ent.visible=0;
        ent_purge(hellmsg_ent);

}

action terrain_center
{
while (scenefade!=2) {wait 1;}
my.invisible=1;
my.passable=1;
create <cube.wmb>,my.pos,particle_emitter();
WHILE (scene<=2)
{
my.Z=200*sin(timer*8);
temp.x = my.x - camera.x;
temp.y = my.y - camera.y;
temp.z = my.z - camera.z;
vec_to_angle(my_angle.pan,temp);
CAMERA.PAN += 0.1*ANG(MY_angle.PAN-CAMERA.PAN)*MIN(1,TIME);
CAMERA.tilt += 0.1*ANG(MY_angle.tilt-CAMERA.tilt)*MIN(1,TIME);
wait 1;
}
}

function fade_in_border()
{
//        while (scene!=2) {wait 1;}
        hellborder_ent.alpha=0;
        hellborder_ent.visible=1;
        hellborder_ent.transparent=1;
        while(hellborder_ent.alpha<100)
        {
                wait 1;
                hellborder_ent.alpha+=time+time;
        }
        hellborder_ent.alpha=50;
        hellborder_ent.transparent=0;
}


action walk_path
{
while (scenefade!=2) {wait 1;}
fade_in_hell();
hell_msg();
anim_layer();
//fog_color=1;
fade_in_border();
helltimer=0;
my.oriented=1;
my.invisible=1;
my.forcex=12;
temp.pan = 360;
temp.tilt = 180;
temp.z = 1000;
result = scan_path(my.x,temp);
if (result == 0) { return; }
ent_waypoint(my.targetx,1);
while (scene<=2)
{
my.forcex=12+7*sin(helltimer*7);
temp.x = my.targetx - my.x;
temp.y = my.targety - my.y;
temp.z = my.targetz - my.z;
result = vec_to_angle(my_angle.pan,temp);
if (result < 50) {
ent_nextpoint(my.targetx);
}
#CAMERA.tilt += 0.1*ANG(MY_angle.tilt-CAMERA.tilt)*MIN(1,TIME);
camera.roll=40*cos(helltimer*6);
my.pan=my_angle.pan;
my.tilt=my_angle.tilt;
        temp = min(TIME*0.55,1);
        MY.speedX += (TIME * MY.forceX) - (temp * MY.speedX);
        MY.speedY += (TIME * MY.forceY) - (temp * MY.speedY);
        MY.speedZ += (TIME * MY.forceZ) - (temp * MY.speedZ);
        speed.X=MY.speedX*TIME;
        speed.Y=MY.speedY*TIME;
        speed.Z=MY.speedZ*TIME;
        YOU=NULL;
        MOVE ME,speed,nullvector;
        vec_set(temp.x,my.x);
        vec_set(camera.x,temp.x);
                temp.X=0.01*(MY.X-CAMERA.X);
                temp.Y=0.01*(MY.Y-CAMERA.Y);
                temp.Z=0.01*(MY.Z-CAMERA.Z);

                MOVE_VIEW CAMERA,NULLVECTOR,temp;

wait(1);
}
hellborder_ent.visible=0;
}

function fade_in_hell()
{
        heavencam.transparent=1;
        camera.visible=1;
        camera.fog=0;
        while(heavencam.alpha>0)
        {
                wait 1;
                heavencam.alpha-=time+time;
                if (heavencam.alpha<=50)
                {
                        camera.fog+=time+time;
                        fog_color=1;
                        heavencam.fog=0;
                }
                else
                {
                        heavencam.fog-=time+time;
                }

        }
        camera.fog=50;
        heavencam.alpha=0;
        heavencam.transparent=0;
        heavencam.visible=0;
        scene=2;
}

ACTION set_sprite {
my.flare=1;
my.ambient=100;
my.scale_x=3;
my.scale_y=3;
//my.nofog=1;
temp=random(56);
my.frame=temp;
while (scenefade<2) {wait 1;}
while (scene<=2) {
MY.FRAME+=TIME*0.8;
if (MY.FRAME>MY.SKILL1-1)
{
my.invisible=1;
my.frame=0;
waitt 32;
my.invisible=0;
}
wait 1;
}
my.invisible=1;
ent_purge(me);
}

ACTION set_lava {
MY.tex_scale=1.5;
my.transparent=0;
MY.scale_z=5;
MY.ambient=0;
my.albedo=0;
my.SKILL40=my.z;
WHILE (scene<=2)
{
my.z=my.skill40+10*cos(helltimer*3);
MY.FRAME+=time/2;
if(MY.FRAME>=36)
{
        MY.FRAME-=36;
}

wait 1;
}
}

ACTION deform_me {
MY.tex_scale=1.5;
}


entity heaven_ent
{
        type=<clouds.pcx>;
        x=533;
        y=0;
        scale_y=1.2;
        scale_x=7;
        z=0;
        alpha=25;
        layer=8;
        flags flare, oriented;
}

entity heaven2_ent
{
        type=<clouds.pcx>;
        x=533;
        y=450;
        z=0;
        scale_y=-1.2;
        scale_x=-7;
        alpha=25;
        layer=10;
        flags flare, oriented;
}

entity heavenmsg1_ent
{
        type=<heaven1.pcx>;
        x=300;
        y=340;
        z=-70;
        scale_y=1.3;
        scale_x=1.3;
        layer=9;
        alpha=30;
        flags flare, oriented, bright;
}

entity heavenmsg2_ent
{
        type=<heaven2.pcx>;
        x=300;
        y=-340;
        z=70;
        scale_y=-1.3;
        scale_x=-1.3;
        layer=9;
        alpha=30;
        flags flare, oriented, bright;
}


action set_heaven
{
        while (scenefade!=1) {wait 1;}
        heaventimer=0;
        create_flowers();
        fade_in_heaven();
//        fog_color=2;
        move_layers();
        heaven_cam();
        WAITT 96;
        scroll_text();
}

function fade_in_heaven()
{
        heavencam.alpha=0;
        heavencam.transparent=1;
        heavencam.visible=1;
        heavencam.fog=0;
        while(heavencam.alpha<100)
        {
                wait 1;
                heavencam.alpha+=time+time;
                intro_ent.alpha-=time;
                if (heavencam.alpha<=50)
                {
                        camera.fog-=time+time;
                }
                else
                {
                        fog_color=2;
                        heavencam.fog+=time+time;
                        camera.fog=0;
                }
        }
        heavencam.fog=50;
        heavencam.alpha=100;
        heavencam.transparent=0;
        camera.visible=0;
        scene=1;
}

var camera_dist;
function heaven_cam()
{
        while (scene<=1)
        {
        camera_dist=400+250*sin(heaventimer*5);
        heavencam.roll=15*cos(heaventimer*6);

//        my.pan=my_angle.pan;
//        my.tilt=my_angle.tilt;
        heavencam.pan+=3*time*(0.2+abs(sin(heaventimer)));
        heavencam.tilt=-15-5*sin(heaventimer*2);
                temp.X=MY.X-camera_dist*COS(heavencam.PAN)*COS(heavencam.TILT)-heavencam.X;
                temp.Y=MY.Y-camera_dist*SIN(heavencam.PAN)*COS(heavencam.TILT)-heavencam.Y;
                temp.Z=MY.Z-camera_dist*SIN(heavencam.TILT)-heavencam.Z+70;
                MOVE_VIEW heavencam,NULLSKILL,temp;
                wait 1;
        }
}


function scroll_text()
{
        heavenmsg1_ent.visible=1;
        heavenmsg2_ent.visible=1;
        heavenmsg1_ent.forcey=-6;
        heavenmsg2_ent.forcey=6;

        while(scene<=1)
        {
                WAIT 1;
                speed.X=0;
                speed.Y=0;
                speed.Z=0;
                temp = min(TIME*0.55,1);
                heavenmsg1_ent.speedY += (TIME * heavenmsg1_ent.forceY) - (temp * heavenmsg1_ent.speedY);
                speed.Y=heavenmsg1_ent.speedY*TIME;
                MOVE heavenmsg1_ent,NULLVECTOR,speed;
                heavenmsg2_ent.speedY += (TIME * heavenmsg2_ent.forceY) - (temp * heavenmsg2_ent.speedY);
                speed.Y=heavenmsg2_ent.speedY*TIME;
                MOVE heavenmsg2_ent,NULLVECTOR,speed;

                if (heavenmsg1_ent.y>340)
                {
                        heavenmsg1_ent.speedY=0;
                        heavenmsg2_ent.speedY=0;
                        heavenmsg1_ent.y=340;
                        heavenmsg1_ent.z=-70;
                        heavenmsg1_ent.forceY*=-1;
                        heavenmsg1_ent.scale_x*=-1;
                        heavenmsg1_ent.scale_y*=-1;
                        heavenmsg2_ent.y=-340;
                        heavenmsg2_ent.z=70;
                        heavenmsg2_ent.forceY*=-1;
                        heavenmsg2_ent.scale_x*=-1;
                        heavenmsg2_ent.scale_y*=-1;
                        waitt 96;
                }
                if (heavenmsg1_ent.y<-340)
                {
                        heavenmsg1_ent.speedY=0;
                        heavenmsg2_ent.speedY=0;
                        heavenmsg2_ent.y=340;
                        heavenmsg2_ent.z=-70;
                        heavenmsg2_ent.forceY*=-1;
                        heavenmsg2_ent.scale_x*=-1;
                        heavenmsg2_ent.scale_y*=-1;
                        heavenmsg1_ent.y=-340;
                        heavenmsg1_ent.z=70;
                        heavenmsg1_ent.forceY*=-1;
                        heavenmsg1_ent.scale_x*=-1;
                        heavenmsg1_ent.scale_y*=-1;
                        waitt 64;
                }
        }
        heavenmsg1_ent.visible=0;
        heavenmsg2_ent.visible=0;
        ent_purge (heavenmsg1_ent);
        ent_purge (heavenmsg2_ent);

}

function move_layers()
{
        heaven_ent.visible=1;
        heaven2_ent.visible=1;
        heaven_ent.alpha=0;
        heaven2_ent.alpha=0;
        while(heaven_ent.alpha<20)
        {
                heaven_ent.alpha+=time;
                heaven2_ent.alpha+=time;
                wait 1;
        }
        while (scenefade<2)
        {
                heaven_ent.y=300*sin(heaventimer);
                heaven2_ent.y=300*cos(heaventimer*1.5);
                heaven_ent.alpha=20+5*sin(heaventimer*4);
                heaven2_ent.alpha=30+5*cos(heaventimer*6);
                wait 1;
        }
        while (heaven_ent.alpha>0 || heaven2_ent.alpha>0)
        {
                wait 1;
                heaven_ent.alpha-=time;
                heaven_ent.alpha=max(0,heaven_ent.alpha);
                heaven2_ent.alpha-=time;
                heaven2_ent.alpha=max(0,heaven_ent.alpha);
        }
        heaven_ent.visible=0;
        heaven2_ent.visible=0;
        ent_purge (heaven_ent);
        ent_purge (heaven2_ent);

}

var flowercount=0;
function create_flowers
{
// BAD STYLE!!!

//        while (flowercount<50)
//        {
                loop:
                temp.x=2600+(random(1600)-800);
                temp.y=-130+(random(1600)-800);
                if (!(temp.y <170 && temp.y>-430 && temp.x <2900 && temp.x>2300))
                {

                        temp.z=0;

                        create <flower01.mdl>,temp,place_flower;
                        flowercount+=1;
                }
//                wait 1;
                if (flowercount<50) {goto loop;}
//        }
}

function place_flower()
{
        sonar me, 500;
        my.z-=result;
        my.pan=random(360);
}


var turb_speed=0.3;

function move_waterpart()
{
        my.vel_z-=0.1*time;
}

bmap blue_particle_map <part_blu.pcx>;
FUNCTION Xparticle_event() {
                MY.RED=62;
                MY.GREEN=80;
                MY.BLUE=180;
                MY.bMAP=blue_particle_map;
                MY.SIZE=2;
                MY.vel_Z=3.5+RANDOM(1.5);
                MY.vel_X=-1+RANDOM(2);
                MY.vel_Y=-1+RANDOM(2);
                my.move=on;
                my.beam=on;
                my.flare=on;
                my.alpha=45;
                my.lifespan=60;
                my.function=move_waterpart;
}

action set_water
{
        my.transparent=1;
        my.alpha=95;
        my.ambient=100;
        while (scene<=1&& scenefade<=1)
        {
                temp=15*TIME;
                vec_set(my_pos,my.x);
                my_pos.z+=30;
                effect(xparticle_event,temp,my_pos,nullvector);
                waitt 5;
        }
}

bmap white_particle_map, <part_whi.pcx>;
function effect_snow()
{
        my.x += random(220) - 110;
        my.y += random(1400) - 700;
        my.vel_z=8+random(4);
        my.alpha = 20 + random(10);
        my.red=255;
        my.green=255;
        my.blue=255;
        my.bmap=white_particle_map;
        my.size=2;
        my.flare = on;
        my.bright = on;
        my.beam = on;
        my.move = on;
        my.function = null;
}

function effect_snow2()
{
        my.x += random(220) - 110;
        my.y += random(1400) - 700;
        my.vel_z=-8-random(4);
        my.alpha = 20 + random(10);
        my.red=255;
        my.green=255;
        my.blue=255;
        my.bmap=white_particle_map;
        my.size=2;
        my.flare = on;
        my.bright = on;
        my.beam = on;
        my.move = on;
        my.function = null;
}

function effect_intro()
{
        my_pos.x = random(2) - 1;
        my_pos.y = random(2) - 1;
        my_pos.z = random(2) - 1;
        vec_normalize(my_pos.x,random(150));
        vec_add(my.vel_x,my_pos.x);
        my.alpha = 25 + random(25);
        my.red=255;
        my.green=255;
        my.blue=255;
        my.size=2;
        my.flare = on;
        my.bright = on;
        my.streak=on;
        my.function = part_alphafade;
}

var campos[3];
var particlepos[3];
ACTION set_intro_coords
{
        my.invisible=1;
        my.passable=1;
        vec_set (campos,my.x);
        vec_set (camera.x,my.x);
        vec_set(particlepos.x,my.x);
        particlepos.z-=800;
        while(clock<10) {wait 1;}
        while(scene==0)
        {
                temp=10*time;
                vec_scale(normal,10);
                effect(effect_intro,temp,particlepos,nullvector);
                temp=6*time;
                effect(effect_snow,temp,particlepos,nullvector);
                waitt 3;
        }
        while (scene!=4) {wait 1;}
        particlepos.z+=800;
        while (scene==4)
        {
                particlepos.z-=800;
                temp=10*time;
                vec_scale(normal,10);
                effect(effect_intro,temp,particlepos,nullvector);
                particlepos.z+=800;
                temp=6*time;
                effect(effect_snow2,temp,particlepos,nullvector);
                waitt 3;
        }
}

ACTION set_intro
{
        wait 1;
        fog_color=1;
        intro_ent.visible=1;
        timer=0;
        MY.AMBIENT=0;
        camera.z=campos.z;
        show_msg();
        WHILE(scene==0)
        {
                MY.V+=18*TIME;
                CAMERA.X=campos.x+70*SIN(3*timer);
                CAMERA.Y=campos.y+70*COS(3*timer);
                CAMERA.PAN=50*(SIN(2*timer));
                CAMERA.TILT=-90+15*COS(3*timer);
                WAIT 1;
        }
        intro_ent.visible=0;
        set_extro();
}


var msgcount=0;
var msgbase=0;
var msgtotal=0;
string msgfile_str,"123456789012";
string msg_str,"msg";
string msgnumber_str,"  ";
//synonym msg_ent {type entity;}

function show_message(msgcount)
{
        while(msgtotal<msgbase+msgcount)
        {
                msgtotal+=1;

                str_for_num(msgnumber_str,msgtotal);
                str_cpy(msgfile_str,msg_str);
                str_cat(msgfile_str,msgnumber_str);
                str_cat(msgfile_str,pcx_str);
                wait 1;
                ent_morph(msg_ent,msgfile_str);
                msg_ent.alpha=0;
                msg_ent.y=msgposx[msgtotal];#-40+(random(140)-70);
                msg_ent.z=msgposy[msgtotal];#(random(100)-50);
                msg_ent.x=533;
                msg_ent.scale_x=1;
                msg_ent.scale_y=1;
                msg_ent.visible=1;
                while(msg_ent.alpha<35)
                {
                        wait 1;
                        msg_ent.alpha+=time+time;
                }
                msg_ent.alpha=35;
                while(msg_ent.alpha>0)
                {
                        wait 1;
                        msg_ent.alpha-=time;
                        if (msgfx[msgtotal]==4)
                        {
                                msg_ent.scale_x+=0.2*time;
                                msg_ent.x+=15*time;
                        }
                        if (msgfx[msgtotal]==1)
                        {
                                msg_ent.x-=10*time;
                        }
                        if (msgfx[msgtotal]==2)
                        {
                                msg_ent.x+=10*time;
                        }
                        if (msgfx[msgtotal]==3)
                        {
                                msg_ent.scale_x-=0.02*time;
                        }
                }
                msg_ent.visible=0;
                ent_purge(msg_ent);
                waitt 16;
        }
        msg_ent.visible=0;
        ent_purge(msg_ent);
        msgbase=msgtotal;
/*
        if (my.skill10==1) {my.x=600;}
        if (my.skill10==2) {my.x=200;}
        if (my.skill10==3) {my.scale_x=4;}
        if (my.skill10==0)
        {
                my.alpha=0;
                while (my.alpha<50)
                {
                        wait 1;
                        my.alpha+=time*1.5;
                }
                my.alpha=50;
        }
        waitt 16;
        while (my.alpha>0)
        {
                wait 1;
                my.alpha-=time*1.5;
                if (my.skill10==1) {my.x-=10*time;}
                if (my.skill10==2) {my.x+=10*time;}
                if (my.skill10==3) {my.scale_x-=0.2*time;}
                if (my.skill10==4) {my.scale_x+=0.2*time; my.x+=15*time;}


        }
        my.visible=0;
        my.alpha=35;
        ent_purge (me);
*/
}

function show_msg()
{
        acknex_ent.visible=1;
        waitt 32;
        play_sound  (bg_music,80);
        sndhandle=result;
        clock_control();
        while (acknex_ent.alpha>0)
        {
                wait 1;
                acknex_ent.alpha-=time+time+time;
                acknex_ent.scale_x+=time*0.05;
                acknex_ent.scale_y-=time*0.02;
        }
        acknex_ent.alpha=0;
        acknex_ent.visible=0;
        ent_purge (acknex_ent);
        WAITT 32;

        conflict_ent.visible=1;
        while (conflict_ent.skill12<16)
        {
                waitt 3;
                conflict_ent.skill12+=time;
                conflict_ent.scale_x=1+random(1)-0.5;
                conflict_ent.scale_y=1+random(1)-0.5;
        }
        conflict_ent.scale_x=1;
        conflict_ent.scale_y=1;
        waitt 8;
        while (conflict_ent.alpha>0)
        {
                wait 1;
                conflict_ent.alpha-=time+time;
        }
        conflict_ent.alpha=0;
        conflict_ent.visible=0;
        ent_purge (conflict_ent);
        waitt 32;
        show_message(8);
        while (clock<47)
        {
                wait 1;
        }
        scenefade=1;
        while (clock<85)
        {
                wait 1;
        }
        scenefade=2;
        while (clock<122)
        {
                wait 1;
        }

        scenefade= 3;
        while (clock<197)
        {
                wait 1;
        }

       scenefade=4;
}

function set_extro()
{
        while (scenefade<4) {wait 1;}
        fade_in_extro();
        helltimer=0;
        MY.AMBIENT=0;
        camera.z=campos.z;
        show_credits();
        WHILE(scene<=4)
        {
                MY.V-=18*TIME;
                CAMERA.X=campos.x+70*SIN(3*helltimer);
                CAMERA.Y=campos.y+160*COS(3*helltimer);
                CAMERA.PAN+=3*time;
                CAMERA.TILT=-90+15*COS(3*helltimer);
                WAIT 1;
        }
        intro_ent.visible=0;
}

string crdfile_str,"123456789012";
string crd_str,"credits";
string crdnumber_str,"  ";
var credits=0;
function show_credits()
{
        waitt 96;
        while(credits<6)
        {
                credits+=1;

                str_for_num(crdnumber_str,credits);
                str_cpy(crdfile_str,crd_str);
                str_cat(crdfile_str,crdnumber_str);
                str_cat(crdfile_str,pcx_str);
                wait 1;
                ent_morph(msg_ent,crdfile_str);
                msg_ent.alpha=0;
                msg_ent.y=0;
                msg_ent.z=0;
                msg_ent.x=533;
                msg_ent.scale_x=1;
                msg_ent.scale_y=1;
                msg_ent.visible=1;
                while(msg_ent.alpha<35)
                {
                        wait 1;
                        msg_ent.alpha+=time+time;
                }
                msg_ent.alpha=35;
                waitt 96;
                while(msg_ent.alpha>0)
                {
                        wait 1;
                        msg_ent.alpha-=time;
                }
                msg_ent.visible=0;
                ent_purge(msg_ent);
                waitt 16;
        }
        msg_ent.visible=0;
        ent_purge(msg_ent);
        fadecam.alpha=0;
        fadecam.transparent=1;
        fadecam.visible=1;
        while (fadecam.alpha<100)
        {
                wait 1;
                fadecam.alpha+=time+time;
        }
        fadecam.transparent=0;
        waitt 8;
        exit;
}

action set_fadecam
{
        my.invisible=1;
        my.passable=1;
        vec_set (fadecam.x, my.x);
        vec_set (fadecam.pan, nullvector);
}

var pipe_dist[2]=150,100;
var pipecenter[3];
synonym innerpipe {type entity;}

action rot_plate
{
wait 3;
        while (scene<=3)
        {
                my.pan-=10*time;
                wait 1;
        }
}

entity chao_ent
{
        type=<chao.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1;
        scale_x=1;
        layer=9;
        alpha=100;
        flags transparent, oriented, bright;
}


entity evil1_ent
{
        type=<gchar1.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=0.6;
        scale_x=0.6;
        layer=9;
        alpha=70;
        flags transparent, oriented, bright;
}

entity evil2_ent
{
        type=<gchar1.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1;
        scale_x=1;
        layer=9;
        alpha=50;
        flags flare, oriented, bright;
}
entity good1_ent
{
        type=<gchar1.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=0.6;
        scale_x=0.6;
        layer=9;
        alpha=50;
        flags transparent, oriented, bright;
}
entity good2_ent
{
        type=<gchar1.pcx>;
        x=533;
        y=0;
        z=0;
        scale_y=1;
        scale_x=1;
        layer=9;
        alpha=50;
        flags flare, oriented, bright;
}

entity scene3_ent
{
        type=<scene3.tga>;
        x=533;
        y=0;
        scale_y=1.2;
        scale_x=6;
        z=0;
        alpha=0;
        layer=7;
        flags flare, oriented;
}

action rot_innerpipe
{
        while (scenefade<3) {wait 1;}
        fade_in_scene3();
        innerpipe=me;
        my.passable=1;
//        scene3_ent.visible=1;
        vec_set (camera.x,my.x);
        vec_set (camera.x,nullvector);
        vec_set (pipecenter.x,my.x);
        while (scene<=3)
        {
//                vec_set (my_angle,nullvector);
//                my_angle.pan=5*time;
//                rotate (me,my_angle,nullvector);
                my.pan+=5*time;
                my.skill10+=5*time;
                my.ambient=70*abs(sin(timer*30));
                scene3_ent.alpha=50*abs(sin(timer*30));
                wait 1;
        }
}

action rot_outerpipe
{
        while (scenefade<3) {wait 1;}
        my.passable=1;
        show_images();
        vec_set (my.x,pipecenter);
        camera.z=pipecenter.z;
        while(scene<=3)
        {
        fog_color=0;
                pipe_dist=100+abs(100*cos(timer*2));
                pipe_dist.y=pipe_dist/2;
                temp.X=pipecenter.X+pipe_dist*cos(innerpipe.pan)-my.x;
                temp.Y=pipecenter.Y+pipe_dist*SIN(innerpipe.PAN)-my.y;
                temp.z=0;
                move me,nullvector,temp;
                pipe_dist=150+abs(150*cos(timer*2));
                temp.X=pipecenter.X+pipe_dist.y*cos(innerpipe.skill10)-heavencam.x;
                temp.Y=pipecenter.Y+pipe_dist.y*SIN(innerpipe.skill10)-heavencam.y;
                temp.z=0;
                move_view heavencam,nullvector,temp;
                my.pan+=9*time;
                my.ambient=70*abs(cos(timer*30));
                heavencam.pan-=7*time;
                heavencam.tilt=-90+35*sin(timer*5);
                heavencam.z=pipecenter.z-abs(450*cos(timer*6));
                wait 1;

        }
}

var imagenr;
var pos1[3]=533, 120, -70;
var pos2[3]=533, 120, 70;
var pos3[3]=533, -120, -70;
var pos4[3]=533, -120, 70;

string goodfile1_str,"123456789012";
string goodfile2_str,"123456789012";
string evilfile1_str,"123456789012";
string evilfile2_str,"123456789012";
string good2_str,"good";
string good1_str,"gchar";
string evil2_str,"evil";
string evil1_str,"echar";
string imgnumber_str,"  ";


function show_images()
{
        while (clock<125) {wait 1;}
        show_message(6);
        while (clock<153) {wait 1;}
                        vec_set (evil1_ent.x,pos4.x);
                        vec_set (evil2_ent.x,pos3.x);
                        vec_set (good1_ent.x,pos1.x);
                        vec_set (good2_ent.x,pos2.x);
        while(imagenr<6)
        {
                imagenr+=1;

                str_for_num(imgnumber_str,imagenr);
                str_cpy(goodfile1_str,good1_str);
                str_cpy(goodfile2_str,good2_str);
                str_cpy(evilfile1_str,evil1_str);
                str_cpy(evilfile2_str,evil2_str);
                str_cat(goodfile1_str,imgnumber_str);
                str_cat(goodfile2_str,imgnumber_str);
                str_cat(evilfile1_str,imgnumber_str);
                str_cat(evilfile2_str,imgnumber_str);
                str_cat(goodfile1_str,pcx_str);
                str_cat(goodfile2_str,pcx_str);
                str_cat(evilfile1_str,pcx_str);
                str_cat(evilfile2_str,pcx_str);
                good1_ent.x=533;
                evil1_ent.x=533;
                good2_ent.scale_x=1;
                evil2_ent.scale_x=1;

                if (evil1_ent.y==pos3.y && evil1_ent.z==pos3.z)
                {
                        vec_set (evil1_ent.x,pos4.x);
                        vec_set (evil2_ent.x,pos3.x);
                        vec_set (good1_ent.x,pos1.x);
                        vec_set (good2_ent.x,pos2.x);

                }
                else
                {
                        vec_set (evil1_ent.x,pos3.x);
                        vec_set (evil2_ent.x,pos4.x);
                        vec_set (good1_ent.x,pos2.x);
                        vec_set (good2_ent.x,pos1.x);
                }
                        wait 2;
                        ent_morph (evil1_ent,evilfile1_str);
                        wait 2;
                        ent_morph (evil2_ent,evilfile2_str);
                        wait 2;
                        ent_morph (good1_ent,goodfile1_str);
                        wait 2;
                        ent_morph (good2_ent,goodfile2_str);
                evil1_ent.visible=1;
                evil1_ent.alpha=100;
                evil2_ent.visible=1;
                evil2_ent.alpha=50;
                good1_ent.visible=1;
                good1_ent.alpha=100;
                good2_ent.visible=1;
                good2_ent.alpha=50;
                while (evil1_ent.alpha>0)
                {
                        wait 1;
                        evil1_ent.alpha-=time+time;
                        evil2_ent.alpha-=time;
                        good1_ent.alpha-=time+time;
                        good2_ent.alpha-=time;
                        good1_ent.x+=10*time;
                        evil1_ent.x+=10*time;
                        good2_ent.scale_x+=0.05*time;
                        evil2_ent.scale_x+=0.05*time;

                }
                evil1_ent.visible=0;
                evil2_ent.visible=0;
                good1_ent.visible=0;
                good2_ent.visible=0;
                ent_purge(evil1_ent);
                wait 1;
                ent_purge(evil2_ent);
                wait 1;
                ent_purge(good1_ent);
                wait 1;
                ent_purge(good2_ent);
                wait 1;
        }
        chao_ent.visible=1;
        while (chao_ent.alpha>0)
        {
                wait 1;
                chao_ent.alpha-=time+time;
                chao_ent.x+=25*time;
//                chao_ent.scale_x+=0.15*time;
        }
        chao_ent.visible=0;
        ent_purge (chao_ent);
        wait 1;
        show_message(4);
}

function fade_in_scene3()
{
        heavencam.alpha=0;
        heavencam.transparent=1;
        heavencam.visible=1;
        heavencam.fog=0;
        hellborder_ent.alpha=100;
        hellborder_ent.transparent=1;
                hell_ent.visible=0;
                hell2_ent.visible=0;
                hell3_ent.visible=0;
                hell4_ent.visible=0;
        while(heavencam.alpha<100)
        {
                wait 1;
                heavencam.alpha+=time+time;
                hellborder_ent.alpha-=4*time;
                hellborder_ent.alpha=max(0,hellborder_ent.alpha);
                if (heavencam.alpha<=50)
                {
                        camera.fog-=time+time;
                }
                else
                {
                        scene3_ent.visible=1;
                        camera.fog=0;
                }
        }
        heavencam.alpha=100;
        heavencam.transparent=0;
        camera.visible=0;
        scene=3;
}

function fade_in_extro()
{
        heavencam.transparent=1;
        heavencam.alpha=100;
        intro_ent.alpha=0;
        intro_ent.visible=1;
        camera.visible=1;
        camera.fog=0;
        camera.alpha=0;
//        scene3_ent.visible=0;
        while(heavencam.alpha>0)
        {
                wait 1;
                heavencam.alpha-=time+time;
                camera.alpha+=time+time;
                if (heavencam.alpha<=50)
                {
                        scene3_ent.visible=0;
                        camera.fog+=time+time;
                        fog_color=1;
                        intro_ent.alpha+=time;
                        intro_ent.alpha=min(50,intro_ent.alpha);

                }

        }
        camera.transparent=0;
        camera.fog=50;
        heavencam.alpha=0;
        heavencam.transparent=0;
        heavencam.visible=0;
        scene=4;
}


// block default keys

function dummy() {return;}

ON_F5 dummy;
ON_F10 dummy;
ON_TAB dummy;
ON_0 dummy;
ON_F12 dummy;