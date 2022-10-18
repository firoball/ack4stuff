///////////////////////////////////////////////////////////////////////////////////
// ~ Shadows of the Lost Citadel ~ Invventory WDL
//
// created by Firoball  2/10/2001
// last modified  2/10/2001 by Firoball
///////////////////////////////////////////////////////////////////////////////////

////////// Inventory stuff //////////

FONT inv_font, <invfont.pcx>,8,11;
FONT standard_font,<basefont.pcx>,9,9;
DEFINE ITEM_ID,SKILL1;
DEFINE _INV_UP, ON_PGUP;
DEFINE _INV_DOWN, ON_PGDN;
DEFINE _INV_USE, ON_ENTER;

VAR panel_id[3] = 0,0,0;
VAR item_amount[3];

VAR player_inv[41];
//set max_amount for each item here
VAR max_amount[41] = 0,100,100,100,100,100,100,100,100,100,100, 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100, 100,100,100,100,100,100,100,100,100,100,100,100,100,100;
//set value for each item here
VAR value[41] = 0,100,100,100,100,100,100,100,100,100,100, 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100, 100,100,100,100,100,100,100,100,100,100,100,100,100,100;
VAR cur_slot = 1;
VAR sel_slot = 1;
VAR sel_amount = 0;

STRING type1_str,"id1";
STRING type2_str,"id2";
STRING type3_str,"id3";
STRING type4_str,"id4";
STRING type5_str,"id5";
STRING type6_str,"id6";
STRING type7_str,"id7";
STRING type8_str,"id8";
STRING type9_str,"id9";
STRING type10_str,"id10";
STRING type11_str,"id11";
STRING type12_str,"id12";
STRING type13_str,"id13";
STRING type14_str,"id14";
STRING type15_str,"id15";
STRING type16_str,"id16";
STRING type17_str,"id17";
STRING type18_str,"id18";
STRING type19_str,"id19";
STRING type20_str,"id20";
STRING type21_str,"Key1";
STRING type22_str,"Key2";
STRING type23_str,"Key3";
STRING type24_str,"Key4";
STRING type25_str,"Key5";
STRING type26_str,"Key6";
STRING type27_str,"Key7";
STRING type28_str,"Key8";
STRING type29_str,"id29";
STRING type30_str,"id30";
STRING type31_str,"id31";
STRING type32_str,"id32";
STRING type33_str,"id33";
STRING type34_str,"id34";
STRING type35_str,"id35";
STRING type36_str,"id36";
STRING type37_str,"id37";
STRING type38_str,"id38";
STRING type39_str,"id39";
STRING type40_str,"id40";

STRING desc1_str,"(Add Description here)";
STRING desc2_str,"(Add Description here)";
STRING desc3_str,"(Add Description here)";
STRING desc4_str,"(Add Description here)";
STRING desc5_str,"(Add Description here)";
STRING desc6_str,"(Add Description here)";
STRING desc7_str,"(Add Description here)";
STRING desc8_str,"(Add Description here)";
STRING desc9_str,"(Add Description here)";
STRING desc10_str,"(Add Description here)";
STRING desc11_str,"(Add Description here)";
STRING desc12_str,"(Add Description here)";
STRING desc13_str,"(Add Description here)";
STRING desc14_str,"(Add Description here)";
STRING desc15_str,"(Add Description here)";
STRING desc16_str,"(Add Description here)";
STRING desc17_str,"(Add Description here)";
STRING desc18_str,"(Add Description here)";
STRING desc19_str,"(Add Description here)";
STRING desc20_str,"(Add Description here)";
STRING desc21_str,"(Add Description here)";
STRING desc22_str,"(Add Description here)";
STRING desc23_str,"(Add Description here)";
STRING desc24_str,"(Add Description here)";
STRING desc25_str,"(Add Description here)";
STRING desc26_str,"(Add Description here)";
STRING desc27_str,"(Add Description here)";
STRING desc28_str,"(Add Description here)";
STRING desc29_str,"(Add Description here)";
STRING desc30_str,"(Add Description here)";
STRING desc31_str,"(Add Description here)";
STRING desc32_str,"(Add Description here)";
STRING desc33_str,"(Add Description here)";
STRING desc34_str,"(Add Description here)";
STRING desc35_str,"(Add Description here)";
STRING desc36_str,"(Add Description here)";
STRING desc37_str,"(Add Description here)";
STRING desc38_str,"(Add Description here)";
STRING desc39_str,"(Add Description here)";
STRING desc40_str,"(Add Description here)";

STRING inv_item_str,"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
STRING inv_temp1_str,"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
STRING inv_temp2_str,"123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
STRING newline_str,"\n";

TEXT inv_type_txt {
        FONT inv_font;
        STRINGS 41;
        STRING NULL,type1_str,type2_str,type3_str,type4_str,type5_str,type6_str,type7_str,type8_str,type9_str,type10_str,type11_str,type12_str,type13_str,type14_str,type15_str,type16_str,type17_str,type18_str,type19_str,type20_str,type21_str,type22_str,type23_str,type24_str,type25_str,type26_str,type27_str,type28_str,type29_str,type30_str,type31_str,type32_str,type33_str,type34_str,type35_str,type36_str,type37_str,type38_str,type39_str,type40_str;
}

TEXT inv_desc_txt {
        FONT inv_font;
        STRINGS 41;
        STRING NULL,desc1_str,desc2_str,desc3_str,desc4_str,desc5_str,desc6_str,desc7_str,desc8_str,desc9_str,desc10_str,desc11_str,desc12_str,desc13_str,desc14_str,desc15_str,desc16_str,desc17_str,desc18_str,desc19_str,desc20_str,desc21_str,desc22_str,desc23_str,desc24_str,desc25_str,desc26_str,desc27_str,desc28_str,desc29_str,desc30_str,desc31_str,desc32_str,desc33_str,desc34_str,desc35_str,desc36_str,desc37_str,desc38_str,desc39_str,desc40_str;
}

TEXT inv_txt {
        FONT standard_font;
        STRING inv_item_str;
        LAYER 9;
        FLAGS CONDENSED;
}

BMAP item_map, <items.pcx>;
PANEL inventory_pan {
        LAYER 10;
        WINDOW 2,2,64,64,item_map,0,panel_id;
        FLAGS REFRESH,VISIBLE,OVERLAY;
}

PANEL inventorystat_pan {
        LAYER 11;
        DIGITS 0,53,2,inv_font,1,sel_amount;
        FLAGS REFRESH,VISIBLE;
}

//////////Applied to Items in WED//////////

ACTION temp_item {
        SET MY.ENABLE_PUSH,ON;
        SET MY.ENABLE_IMPACT,ON;
        SET MY.EVENT,collect_item;
}

/////////Functions//////////

FUNCTION collect_item()
{
        cur_slot = MY.ITEM_ID;
        IF (player_inv[cur_slot] < max_amount[cur_slot])
        {
                player_inv[cur_slot]+=1;
                set_slots();
                WAIT 1;
                REMOVE ME;
                RETURN;
        }
}

FUNCTION scroll_up()
{
redo:
        sel_slot.X-=1;
        IF (sel_slot.X<1) {sel_slot.X=40;}

        IF (player_inv[sel_slot.X]==0)
        {
                GOTO redo;
        }

        set_slots();
}

FUNCTION scroll_down()
{
redo:
        sel_slot.X+=1;
        IF (sel_slot.X>40) {sel_slot.X=1;}

        IF (player_inv[sel_slot.X]==0)
        {
                GOTO redo;
        }

        set_slots();
}

FUNCTION use_inv_item()
{
        player_inv[sel_slot]-=1;
        scroll_up();
        IF (sel_slot==1)
        {
                RETURN;
        }
        IF (sel_slot==2)
        {
                RETURN;
        }
        IF (sel_slot==3)
        {
                RETURN;
        }
        IF (sel_slot==4)
        {
                RETURN;
        }
        IF (sel_slot==5)
        {
                RETURN;
        }
        IF (sel_slot==6)
        {
                RETURN;
        }
        IF (sel_slot==7)
        {
                RETURN;
        }
        IF (sel_slot==8)
        {
                RETURN;
        }
        IF (sel_slot==9)
        {
                RETURN;
        }
        IF (sel_slot==10)
        {
                RETURN;
        }
        IF (sel_slot==11)
        {
                RETURN;
        }
        IF (sel_slot==12)
        {
                RETURN;
        }
        IF (sel_slot==13)
        {
                RETURN;
        }
        IF (sel_slot==14)
        {
                RETURN;
        }
        IF (sel_slot==15)
        {
                RETURN;
        }
        IF (sel_slot==16)
        {
                RETURN;
        }
        IF (sel_slot==17)
        {
                RETURN;
        }
        IF (sel_slot==18)
        {
                RETURN;
        }
        IF (sel_slot==19)
        {
                RETURN;
        }
        IF (sel_slot==20)
        {
                RETURN;
        }
        IF (sel_slot==21)
        {
                RETURN;
        }
        IF (sel_slot==22)
        {
                RETURN;
        }
        IF (sel_slot==23)
        {
                RETURN;
        }
        IF (sel_slot==24)
        {
                RETURN;
        }
        IF (sel_slot==25)
        {
                RETURN;
        }
        IF (sel_slot==26)
        {
                RETURN;
        }
        IF (sel_slot==27)
        {
                RETURN;
        }
        IF (sel_slot==28)
        {
                RETURN;
        }
        IF (sel_slot==29)
        {
                RETURN;
        }
        IF (sel_slot==30)
        {
                RETURN;
        }
        IF (sel_slot==31)
        {
                RETURN;
        }
        IF (sel_slot==32)
        {
                RETURN;
        }
        IF (sel_slot==33)
        {
                RETURN;
        }
        IF (sel_slot==34)
        {
                RETURN;
        }
        IF (sel_slot==35)
        {
                RETURN;
        }
        IF (sel_slot==36)
        {
                RETURN;
        }
        IF (sel_slot==37)
        {
                RETURN;
        }
        IF (sel_slot==38)
        {
                RETURN;
        }
        IF (sel_slot==39)
        {
                RETURN;
        }
        IF (sel_slot==40)
        {
                RETURN;
        }
}

FUNCTION set_slots()
{
        panel_id.X=64*sel_slot.X;
        sel_amount=player_inv[sel_slot.X];
        gen_description();
        inv_txt.POS_X=70;
        inv_txt.POS_Y=SCREEN_SIZE.Y-70;
        inventory_pan.POS_X=1;
        inventory_pan.POS_Y=SCREEN_SIZE.Y-70;
        inventorystat_pan.POS_X=3;
        inventorystat_pan.POS_Y=SCREEN_SIZE.Y-70;
        inv_txt.VISIBLE=1;
}

FUNCTION gen_description()
{
        STR_CPY (inv_temp1_str,inv_type_txt.STRING[sel_slot.X]);
        STR_CPY (inv_temp2_str,inv_desc_txt.STRING[sel_slot.X]);
        STR_CAT (inv_temp1_str,newline_str);
        STR_CAT (inv_temp1_str,inv_temp2_str);
        STR_CPY (inv_item_str,inv_temp1_str);
}

_INV_DOWN scroll_down;
_INV_UP scroll_up;
_INV_USE use_inv_item;