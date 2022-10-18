

var video_mode=7;
var video_depth=16;
var fps_max=30;

var camera_dist=300;
var campos[3];
var cam[3];
var timer;


path "..\\template";

//main startup;

function main()
{
        init_timer();
        camera.pos_x=0;
        camera.pos_y=screen_size.y/6;
        camera.size_x=screen_size.x;
        camera.size_y=screen_size.y/3*2;
        load_level <dream.wmb>;
}

function init_timer()
{
        exclusive_global;
        timer=0;
        while(1)
        {
                timer+=time;
                wait 1;
        }
}

entity face_ent
{
        type=<face.pcx>;
        x=314;
        y=0;
        z=0;
        scale_x=1.5;
        scale_y=2;
        flags transparent,bright;
}


function show_face()
{
        while(1)
        {
                face_ent.visible=1;
                face_ent.alpha=max(0,face_ent.skill8*sin(timer*3));
                face_ent.skill8=min(100,face_ent.skill8+0.02);
                wait (1);
        }
}

function init_space()
{
        my.passable=1;
        my.ambient=100;
//        my.unlit=1;
}

entity* space;
action spin_earth
{
        my.passable=1;
        show_face();
        space=ent_create("space.mdl",camera.x,init_space);
        wait 1;
                campos.x=(my.x-camera_dist*cos(cam.pan)*cos(cam.tilt)-camera.x);
                campos.y=(my.y-camera_dist*sin(cam.pan)*cos(cam.tilt)-camera.y);
                campos.z=(my.z-camera_dist*sin(cam.tilt)-camera.z);
                move_view camera,nullvector,campos;
        while(1)
        {
//                my.pan-=time;
//                space.pan=-my.pan;
                cam.pan+=0.5*time;
                cam.tilt=10*sin(timer);
                camera.pan+=0.1*ang((cam.pan-15)-camera.pan);
                camera.tilt=cam.tilt;

                campos.x=0.6*(my.x-camera_dist*cos(cam.pan)*cos(cam.tilt)-camera.x);
                campos.y=0.6*(my.y-camera_dist*sin(cam.pan)*cos(cam.tilt)-camera.y);
                campos.z=0.6*(my.z-camera_dist*sin(cam.tilt)-camera.z);
                move_view camera,nullvector,campos;

                space.pan=-camera.pan;
                space.tilt=-camera.tilt;
                vec_set(space.x,camera.x);
                wait (1);
        }
}
