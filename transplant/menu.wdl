/*
Transplant Returns

Text Messages and Menu
Built 12/10/01

Last Update: 12/10/01
*/


string server_str[50];
string info_str[50];
string temp_str[50];
string online_str="Online:1  \n";
string players_str="   ";

font menufont, <menufont.pcx>,12,15;

text server_txt
{
        font menufont;
        pos_x=3;
        pos_y=3;
        strings=3;
        string online_str,server_str,info_str;
        flags visible;
}

entity radar_ent
{
        type=<radar.tga>;
        x=500;
        z=-170;
        tilt=-60;
        flags oriented,visible;
}

function greet_client()
{
        str_cpy (my.string1,"Welcome at ");
        str_cat (my.string1,server_name);
        set_string info_str,my.string1;
        send_string (info_str);
}