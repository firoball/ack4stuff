/*
Transplant Returns

Ship Movement Routine
Built 12/08/01

Last Update: 12/10/01
*/

/*
Bit 0: Fire
Bit 1: Special Fire
Bit 2: Strafe
Bit 3: Left Arrow
Bit 4: Right Arrow
Bit 5: Up Arrow
Bit 6: Down Arrow
*/

var control[7];
var speed[3];
var aspeed[3];
var campos[3];
var bit;
var camera_dist=350;

var t0;
var t1;
var t2;
var t3;
var t4;
var t5;
var t6;
var keys;

//controls
define Kfire,key_ctrl;
define KSfire,key_shift;
define Kstrafe,key_ins;
define Kleft,key_cul;
define Kright,key_cur;
define Kup,key_cuu;
define Kdown,key_cud;

//other defines

define ctrl,skill30;
define speedX,skill31;
define speedY,skill32;
define speedZ,skill33;
define strspeedX,skill37;
define strspeedY,skill38;
define speedPAN,skill39;
define forceX,skill34;
define forceY,skill35;
define forceZ,skill36;
define ptrhandle,skill40;

entity* tempent;

function init_space()
{
        my.unlit=1;
        my.ambient=100;
        my.passable=1;
        my.hidden=1;
        my.ptrhandle=handle(me);
        while (netmode>1 && my.ptrhandle!=0)
        {
                send (my.ptrhandle);
                wait (1);
        }
}

function link_sphere()
{
        while (sphere.ptrhandle==0)
        {
                wait (1);
        }
        player.ptrhandle=sphere.ptrhandle;
        sphere.ptrhandle=0;
        while (player.ptrhandle!=0)
        {
                send (player.ptrhandle);
                wait (1);
        }
}

function ship_event()
{
//following code does not work - why?
        if (event_type==event_disconnect)
        {
                wait (1);
                tempent=my.entity1;
                ent_remove(tempent);
                ent_remove(me);
        }
}

function move_ship()
{
        wait (1);
//        greet_client();
        my.z-=300;
        my.event=ship_event;
        while (my.ptrhandle==0)
        {
                wait (1);
        }
        my.entity1=ptr_for_handle(my.ptrhandle);
        my.ptrhandle=0;
        send (my.ptrhandle);
        while (gameover!=1)
        {
                bit=6;
                keys=my.ctrl;
                while (bit>=0)
                {
                        control[bit]=0;
                        temp=1<<bit;
                        if(keys >= temp)
                        {
                                keys-=temp;
                                control[bit]=1;
                        }
                        bit-=1;
                }

//debug panel
                t0=control[0];
                t1=control[1];
                t2=control[2];
                t3=control[3];
                t4=control[4];
                t5=control[5];
                t6=control[6];
//////////


//disable pan and forward movement while strafing
                if (control[2]==0)
                {
                        my.forceX=2*(control[6]-control[5]);
                        my.forceZ=1.5*(control[4]-control[3])*sign(0.1+my.forceX);

                }
                my.forceY=6*(control[4]-control[3])*control[2];
//ship rolling
                my.roll-=(control[4]-control[3])*2*time;//*sign(0.1+my.forceX);
                if (my.roll<0) {
                        my.roll=max(-30,my.roll);
                }
                else
                {
                        my.roll=min(30,my.roll);
                }
                if ((control[4]-control[3])==0 && my.roll!=0)
                {
                        my.roll-=my.roll*0.3*time;
                        if (abs(my.roll)<1)
                        {
                                my.roll=0;
                        }
                }

//calculate different speeds
                temp = min(time*0.2,1);
                my.speedX += (time * my.forceX*cos(my.pan)) - (temp * my.speedX);
                my.speedY += (time * my.forceX*sin(my.pan)) - (temp * my.speedY);
                my.strspeedX += (time * my.forceY*cos(my.pan+90))- (temp * my.strspeedX);
                my.strspeedY += (time * my.forceY*sin(my.pan+90))- (temp * my.strspeedY);
                my.speedPAN += (time * my.forceZ) - (temp * my.speedPAN);
                speed.X=(my.speedX+my.strspeedX)*time;
                speed.Y=(my.speedY+my.strspeedY)*time;
                speed.Z=0;
                aspeed.pan=my.speedPan*time;
                aspeed.tilt=0;
                aspeed.roll=0;
                move me,nullvector,speed;
                my.pan+=aspeed;

                tempent=my.entity1;
                tempent.pan=-0.3*my.pan;
                vec_set (tempent.x,my.x);

                wait (1);
        }
}

function move_camera()
{
        while (gameover!=1)
        {
                wait (1);
//                proc_late(); //makes one ship move faster than the other
                camera.pan=player.pan;//+=0.15*ang(player.pan-camera.pan);//*min(time,1);
                if (abs(ang(player.pan-camera.pan))<0.5)
                {
                        camera.pan=player.pan;  //to avoid hysteresis
                }
                campos.X=1*(player.x-camera_dist*cos(player.pan)*cos(camera.tilt) -camera.x);
                campos.Y=1*(player.y-camera_dist*sin(player.pan)*cos(camera.tilt) -camera.y);
                campos.Z=1*(player.z-camera_dist*sin(camera.tilt)-camera.z+70);

                move_view camera,nullvector,campos;
        }
}

function enable_controls()
{
        while(gameover!=1)
        {
                player.ctrl=0;
                if(Kfire!=0)
                {
                        player.ctrl+=1<<0;
                }
                if(KSfire!=0)
                {
                        player.ctrl+=1<<1;
                }
                if(Kstrafe!=0)
                {
                        player.ctrl+=1<<2;
                }
                if(Kright!=0)
                {
                        player.ctrl+=1<<3;
                }
                if(Kleft!=0)
                {
                        player.ctrl+=1<<4;
                }
                if(Kdown!=0)
                {
                        player.ctrl+=1<<5;
                }
                if(Kup!=0)
                {
                        player.ctrl+=1<<6;
                }

                if (netmode==1)
                {
                        send (player.ctrl);
                }
                wait (1);
        }
}