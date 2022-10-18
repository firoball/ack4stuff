/*
Transplant Returns

Online Space Shooter
Project started 12/08/01

Last Update 12/10/01
*/

path "..\\template";
var video_depth=16;
var video_mode=7;

var gameover=0;
var netmode=0; //0-offline 1-client 2-server 3-both
var players=0; //connected players

entity* player;
entity* sphere;

include <menu.wdl>;
include <shipmove.wdl>;
include <debug.wdl>;


main startup;

function startup()
{
//setup netmode
        ifdef server;
                netmode=2;
        endif;
        ifdef client;
                netmode+=1;
                players=1;
        endif;

//start level
        load_level <space.wmb>;
        wait (1);

        if (netmode>1)
        {
                str_cpy(server_str,server_name);
                str_cat(server_str,"\n(");
                str_cat(server_str,server_ip);
                str_cat(server_str,")\n");
                update_players(players);
        }
        if (netmode==1)
        {
                str_cpy(server_str,player_name);
                while (connection==0)
                {
                        wait (1);
                }
        }

//inits
        camera.tilt=-35;//-75;

        vec_set (temp,nullvector);
        you=ent_create ("ship.wmb",temp,move_ship);
        your.ambient=70;
        player=you;
        you=ent_create ("space.mdl",player.x,init_space);
        sphere=you;
        if (netmode!=0)
        {
                link_sphere();
        }
        enable_controls(); //client function
        move_camera(); //client function
}

on_server server_event;
function server_event(temp_str)
{
        if (event_type == event_join)
        {
                str_cpy(info_str,temp_str);
                str_cat(info_str," joined.");
                players+=1;
                update_players(players);
                return;
        }
        if (event_type == event_leave)
        {
                str_cpy(info_str,temp_str);
                str_cat(info_str," left.");
                players-=1;
                update_players(players);
                return;
        }
}

function update_players(temp)
{
        str_cpy(online_str,"Online:");
        str_for_num (players_str,temp);
        str_cat (online_str,players_str);
        str_cat (online_str,"\n");
        send_string (online_str);
        send_string (info_str);
}

bind <ship.wmb>;
bind <space.mdl>;