explosion_z = 50;
flip = 0;
e = 0.00000001;
fn = 128;

gap = 1.0;
stand_room_gap = 0.1;
stand_slot_gap = 0.25;
pcb_gap_xy = 2.0;
screen_gap = 1.0;
screen_gap_z = 0.05;
keypad_gap = 0.5;
micpad_gap_xy = 0.25;
micpad_gap_z = 0.5;

thickness = 3;
r = thickness;

h_anchor_width = 16;
v_anchor_width = 4;
anchor_thickness = 3;
anchor_gap = 0.5;

screen_width = 177.5;
screen_height = 120.9;
outer_width = screen_width + screen_gap*2 + thickness*2;
outer_height = screen_height + screen_gap*2 + thickness*2;
screen_cover_thickness = 1.2;
screen_visible_width = 160;
screen_visible_height = 105;
screen_holder_zheight = 2;

screen_base_zheight = 3;
screen_module_zheight = 3.8;
screen_module_inset = 10;
screen_module_support_thickness = 5;
screen_elevation = 30 - screen_module_zheight; // number measured from pcb top to screen glass bottom, min 17 for pcb, min 28 for usb
screen_support_thickness = 5; // max 9
screen_glass_thickness = 1.5 + 0.25;
screen_buckle_width = 35;
screen_buckle_height = 3;
buckle_height=4;

screen_support_zheight = screen_elevation+screen_gap_z;
top_support_width = 100 - 34; // make room for mic pad
bottom_support_width = screen_width-gap*2;

micpad_connector_width = 6.3;
micpad_connector_height = 3.2;
micpad_connector_left_margin = 22;
micpad_connector_top_margin = 7.5;
micpad_connector_gap = 0.5;

pcb_width = 163.4792;
pcb_height = 97.05;
pcb_zheight = 1.7 + 0.25;
back_frame_inset = 2;
dc_jack_width = 9 + 0.5;
dc_jack_height = 11 + 0.5;
dc_jack_zheight = 14;
dc_jack_offset = 2.2; // toward top 2.2
smt_zheight = 11; // min 5.3
pcb_support_r = 7 / 2;
pcb_pin_r = 3.5 / 2;

top_pcb_stopper_length = 6;
bottom_pcb_stopper_length = 12;
pcb_stopper_width = pcb_support_r*1.5;

keypad_width = 96.4;
keypad_height = 26;
keypad_thickness = 1;
keypad_stop_thickness = 3;
keypad_offset = outer_height-keypad_width-keypad_stop_thickness-keypad_gap;
keypad_support_zheight = 17;
keypad_bump = 1.2;

screen_cover_stack_zheight = screen_cover_thickness+screen_glass_thickness+screen_module_zheight + screen_gap_z*2;
screen_holder_stack_zheight = screen_holder_zheight;
screen_base_stack_zheight = screen_elevation - screen_holder_zheight;
back_frame_stack_zheight = dc_jack_zheight + pcb_zheight;

stand_length = 30 + back_frame_stack_zheight;
stand_width = 12;
stand_thickness = 3;
stand_slot_offset = 6; // toward top

micpad_width = 100;
micpad_height = 18.2;
micpad_thickness = 1.0;

back_frame_level = explosion_z*0;
screen_base_level = pcb_zheight + explosion_z*1;
screen_holder_level = screen_base_level + screen_base_stack_zheight + explosion_z;
dummy_screen_level = screen_holder_level + screen_holder_stack_zheight + explosion_z*0.5;
screen_cover_level = screen_holder_level + screen_holder_stack_zheight + e + explosion_z;
stand_level = pcb_zheight - stand_length - explosion_z;
dummy_keypad_level = screen_base_level + screen_base_zheight + explosion_z*0.4;
dummy_micpad_level = screen_base_level + screen_base_stack_zheight + explosion_z*0.6;

module rcube(x,y,z,r){
    hull(){
        translate([r,r,0]) cylinder(h=z,r1=r,r2=r,$fn=fn);
        translate([x-r,r,0]) cylinder(h=z,r1=r,r2=r,$fn=fn);
        translate([r,y-r,0]) cylinder(h=z,r1=r,r2=r,$fn=fn);
        translate([x-r,y-r,0]) cylinder(h=z,r1=r,r2=r,$fn=fn);
    };
};

module screen_cover()
translate([0,0,screen_cover_level]){
    rotate([180*flip,0,0]){
        // cover
        translate([0,0,screen_glass_thickness+screen_module_zheight+screen_gap_z*2]){
            difference(){
                rcube(outer_width, outer_height, screen_cover_thickness, r);
                // visible area
                translate([(outer_width-screen_visible_width)/2,(outer_height-screen_visible_height)/2,0]){
                    cube([screen_visible_width, screen_visible_height, screen_cover_thickness]);
                };
            };
        };

        // border
        translate([0,0,0]){
            difference(){
                rcube(outer_width, outer_height, screen_glass_thickness+screen_module_zheight+screen_gap_z*2,r);
                translate([thickness,thickness,0]){
                    cube([screen_width+screen_gap*2, screen_height+screen_gap*2, screen_glass_thickness+screen_module_zheight+screen_gap_z*2]);
                };
            };
        };

        // top buckle
        difference(){
            union(){
                translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
                    cube([screen_buckle_width,screen_buckle_height,screen_cover_stack_zheight]);
                };
                translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
                    rcube(screen_buckle_width+thickness*2,thickness,screen_cover_stack_zheight,thickness/2);
                };
            };
            translate([(outer_width-h_anchor_width-anchor_gap*2)/2,outer_height,0]){
                cube([h_anchor_width+anchor_gap*2,anchor_thickness+anchor_gap*2,screen_cover_stack_zheight]);
            };
        };

        // bottom buckle
        difference(){
            union(){
                translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
                    cube([screen_buckle_width,screen_buckle_height,screen_cover_stack_zheight]);
                };
                translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
                    rcube(screen_buckle_width+thickness*2,thickness,screen_cover_stack_zheight,thickness/2);
                };
            };
            translate([(outer_width-h_anchor_width-anchor_gap*2)/2,-anchor_thickness-anchor_gap*2,0]){
                cube([h_anchor_width+anchor_gap*2,anchor_thickness+anchor_gap*2,screen_cover_stack_zheight]);
            };
        };
    };
};

module screen_holder()
translate([0,0,screen_holder_level]){
    difference(){
        translate([(outer_width-screen_buckle_width)/2,0,0]){
            cube([screen_buckle_width, outer_height, screen_holder_stack_zheight]);
        };

        // hollow
        hollow_ratio_x = 0.50;
        hollow_ratio_y = 0.75;
        translate([(outer_width-screen_buckle_width)/2+(screen_buckle_width-screen_buckle_width*hollow_ratio_x)/2,(outer_height-screen_height*hollow_ratio_y)/2,0]){
            cube([screen_buckle_width*hollow_ratio_x, screen_height*hollow_ratio_y, screen_holder_zheight]);
        };
    };

    // top buckle
    difference(){
        union(){
            translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
                cube([screen_buckle_width,screen_buckle_height,screen_holder_stack_zheight]);
            };
            translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
                rcube(screen_buckle_width+thickness*2,thickness,screen_holder_stack_zheight,thickness/2);
            };
        };
        translate([(outer_width-h_anchor_width-anchor_gap*2)/2,outer_height,0]){
            cube([h_anchor_width+anchor_gap*2,anchor_thickness+anchor_gap*2,screen_holder_stack_zheight]);
        };
    };

    // bottom buckle
    difference(){
        union(){
            translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
                cube([screen_buckle_width,screen_buckle_height,screen_holder_stack_zheight]);
            };
            translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
                rcube(screen_buckle_width+thickness*2,thickness,screen_holder_stack_zheight,thickness/2);
            };
        };
        translate([(outer_width-h_anchor_width-anchor_gap*2)/2,-anchor_thickness-anchor_gap*2,0]){
            cube([h_anchor_width+anchor_gap*2,anchor_thickness+anchor_gap*2,screen_holder_stack_zheight]);
        };
    };
};

module screen_base()
translate([0,0,screen_base_level]){
    hollow_width = pcb_width+pcb_gap_xy*2;
    hollow_height = pcb_height+pcb_gap_xy*2;

    // border
    difference(){
        rcube(outer_width, outer_height, screen_base_zheight,r);

        translate([(outer_width-hollow_width)/2,(outer_height-hollow_height)/2,0]){
            cube([
                hollow_width,
                hollow_height,
                screen_base_zheight]);
        };
    };


    difference(){
        union(){
            translate([0,0,screen_base_zheight]){
                // top screen support
                translate([(outer_width-top_support_width)/2,outer_height-thickness-screen_support_thickness-gap,0]){
                    cube([top_support_width, screen_support_thickness, screen_support_zheight]);
                };

                // bottom screen support
                translate([(outer_width-bottom_support_width)/2,thickness+gap,0]){
                    cube([bottom_support_width , screen_support_thickness, screen_support_zheight]);
                };

                echo("screen_support_zheight", screen_support_zheight);
            };

            // top buckle
            // fill
            translate([(outer_width-screen_buckle_width)/2,outer_height-thickness-gap,0]){
                cube([screen_buckle_width,thickness+gap,screen_base_stack_zheight]);
            };
            // buckle
            translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
                cube([screen_buckle_width,screen_buckle_height,screen_base_stack_zheight]);
            };
            // stop
            translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
                rcube(screen_buckle_width+thickness*2,thickness,screen_base_stack_zheight,thickness/2);
            };
            // anchor
            translate([(outer_width-h_anchor_width)/2,outer_height+anchor_gap,0]){
                cube([h_anchor_width,anchor_thickness,screen_base_stack_zheight+screen_holder_stack_zheight+screen_cover_stack_zheight+screen_gap*2]);
            };

            // bottom buckle
            // fill
            translate([(outer_width-screen_buckle_width)/2,0,0]){
                cube([screen_buckle_width,thickness+gap,screen_base_stack_zheight]);
            };
            // buckle
            translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
                cube([screen_buckle_width,screen_buckle_height,screen_base_stack_zheight]);
            };
            // stop
            translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
                rcube(screen_buckle_width+thickness*2,thickness,screen_base_stack_zheight,thickness/2);
            };
            // anchor
            translate([(outer_width-h_anchor_width)/2,-anchor_thickness-anchor_gap,0]){
                cube([h_anchor_width,anchor_thickness,screen_base_stack_zheight+screen_holder_stack_zheight+screen_cover_stack_zheight+screen_gap*2]);
            };
        };

        // screen holder space
        translate([(outer_width-screen_buckle_width)/2-gap,0,screen_base_stack_zheight]){
            cube([screen_buckle_width+gap*2, outer_height, screen_elevation-gap]);
        };

        // micpad space
        // pad
        translate([(outer_width-micpad_width-micpad_gap_xy*2)/2,outer_height-thickness-gap,screen_base_stack_zheight-micpad_height-micpad_gap_xy*2]){
            cube([micpad_width+micpad_gap_xy*2,micpad_thickness+micpad_gap_z*2,micpad_height+micpad_gap_xy*2]);
        };

        // connector
        translate([(outer_width-micpad_width-micpad_gap_xy*2)/2+micpad_connector_left_margin,outer_height-thickness-screen_support_thickness-gap,screen_base_stack_zheight-micpad_connector_top_margin-micpad_connector_height-micpad_connector_gap*3]){
            cube([micpad_connector_width+micpad_connector_gap*2,screen_support_thickness,micpad_connector_height+micpad_connector_top_margin+micpad_connector_gap*3+(screen_support_zheight+screen_base_zheight-screen_base_stack_zheight)]);
        };
    };

    // top pcb stopper
    translate([(outer_width-pcb_stopper_width)/2,(outer_height-hollow_height)/2+hollow_height-top_pcb_stopper_length-pcb_gap_xy,0]){
        cube([pcb_stopper_width,top_pcb_stopper_length+pcb_gap_xy,screen_base_zheight]);
    };

    // bottom pcb stopper
    translate([(outer_width-pcb_stopper_width)/2,(outer_height-hollow_height)/2,0]){
        cube([pcb_stopper_width,bottom_pcb_stopper_length+pcb_gap_xy,screen_base_zheight]);
    };

    // left buckle
    difference(){
        union(){
            translate([-buckle_height,(outer_height-thickness*4)/2,0]){
                cube([buckle_height,thickness*4,screen_base_zheight]);
            };
            translate([-buckle_height-thickness, (outer_height-thickness*6)/2, 0]){
                rcube(thickness,thickness*6,screen_base_zheight,thickness/2);
            };
        };
        translate([-anchor_thickness-anchor_gap*2,(outer_height-anchor_thickness-anchor_gap*2)/2,0]){
            cube([anchor_thickness+anchor_gap*2,v_anchor_width+anchor_gap*2,screen_base_zheight]);
        };
    };

    // right buckle
    difference(){
        union(){
            translate([outer_width,(outer_height-thickness*4)/2,0]){
                cube([buckle_height,thickness*4,screen_base_zheight]);
            };
            translate([outer_width+buckle_height, (outer_height-thickness*6)/2, 0]){
                rcube(thickness,thickness*6,screen_base_zheight,thickness/2);
            };
        };
        translate([outer_width,(outer_height-v_anchor_width-anchor_gap*2)/2,0]){
            cube([anchor_thickness+anchor_gap*2,v_anchor_width+anchor_gap*2,screen_base_zheight]);
        };
    };

    // keypad support
    // back
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, thickness+gap,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_offset+keypad_width+keypad_stop_thickness+keypad_gap-thickness-gap, keypad_support_zheight]);
    };
    // top
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset+keypad_width+keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness*2+keypad_thickness+keypad_gap*2-r, keypad_stop_thickness, keypad_support_zheight]);
    };
    // bottom
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset-keypad_stop_thickness-keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness*2+keypad_thickness+keypad_gap*2, keypad_stop_thickness, keypad_support_zheight]);
    };
    // front - top
    translate([outer_width-keypad_stop_thickness, keypad_offset+keypad_width-keypad_stop_thickness,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_stop_thickness*2+keypad_gap-r, keypad_support_zheight]);
    };
    // front - bottom
    translate([outer_width-keypad_stop_thickness, keypad_offset-keypad_stop_thickness-keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_stop_thickness*2, keypad_support_zheight]);
    };
    // bump
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset+keypad_width/2-keypad_stop_thickness/2,screen_base_zheight]){
        cube([keypad_stop_thickness+keypad_gap+keypad_bump, keypad_stop_thickness, keypad_support_zheight*0.75]);
    };
    // rounded corner
    translate([outer_width-r, outer_height-r,screen_base_zheight]){
        intersection(){
            cylinder(h=keypad_support_zheight,r1=r,r2=r,$fn=fn);
            cube([r,r,keypad_support_zheight]);
        };
    };
    // support
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2-keypad_support_zheight, keypad_offset+keypad_width+keypad_gap,screen_base_zheight]){
        cube([keypad_support_zheight, keypad_stop_thickness, keypad_support_zheight]);
    };

    echo("screen_base_stack_zheight", screen_base_stack_zheight);
};

module back_frame()
translate([0,back_frame_inset,back_frame_level]){
    back_frame_height = outer_height-back_frame_inset*2;
    difference(){
        // body
        translate([0,0,-dc_jack_zheight]){
            rcube(outer_width, outer_height-back_frame_inset*2, back_frame_stack_zheight,r);
        };

        // smt space
        translate([(outer_width-pcb_width-pcb_gap_xy*2)/2,(back_frame_height-pcb_height-pcb_gap_xy*2)/2,-smt_zheight]){
            cube([pcb_width+pcb_gap_xy*2, pcb_height+pcb_gap_xy*2, smt_zheight+pcb_zheight]);
        }

        // dc jack
        translate([(outer_width-dc_jack_width)/2,(back_frame_height-dc_jack_height)/2+dc_jack_offset, -dc_jack_zheight]){
            cube([dc_jack_width, dc_jack_height, dc_jack_zheight-smt_zheight]);
        };

        // louver
        louver_num = floor(pcb_height / (thickness*2));
        louver_width = pcb_width/2-thickness*5;
        louver_margin = thickness*5;
        translate([0, (screen_height-thickness*louver_num*2)/2+thickness, -dc_jack_zheight]){
            for(i=[0:louver_num-1]){
                translate([louver_margin, thickness*i*2, 0]){
                    cube([louver_width, thickness, dc_jack_zheight-smt_zheight]);
                };
                translate([outer_width-louver_margin-louver_width, thickness*i*2, 0]){
                    cube([louver_width, thickness, dc_jack_zheight-smt_zheight]);
                };
            };
        };

        // stand slot
        translate([(outer_width-stand_width-stand_slot_gap*2)/2,stand_slot_offset, -dc_jack_zheight]){
            cube([stand_width+stand_slot_gap*2, stand_thickness+stand_slot_gap*2, back_frame_stack_zheight]);
        };

        stand_room_depth = stand_length-thickness*1.5;
        // stand room - top
        left_wall_thickness = (outer_width-pcb_width-+pcb_gap_xy*2)/2;
        translate([(left_wall_thickness-(stand_thickness+stand_room_gap*2))/2,back_frame_height-stand_room_depth, pcb_zheight-stand_width-stand_room_gap]){
            cube([stand_thickness+stand_room_gap*2, stand_room_depth, stand_width+stand_room_gap]);
        };

        // stand room - right
        translate([outer_width-stand_room_depth,stand_slot_offset, pcb_zheight-stand_width-stand_room_gap]){
            cube([stand_room_depth, stand_thickness+stand_room_gap*2, stand_width+stand_room_gap]);
        };

    };

    // pcb support
    translate([(outer_width-dc_jack_width)/2+dc_jack_width/2,(back_frame_height-dc_jack_height)/2+dc_jack_height/2+dc_jack_offset,-dc_jack_zheight]){ // anchor to center of dc jack
        support_height = dc_jack_zheight;
        pin_height = dc_jack_zheight+pcb_zheight;
        pcb_support_skirt_zheight = support_height*0.7;

        h_offset = 69;
        top_offset = dc_jack_height/2 + 31.5;
        bottom_offset = -dc_jack_height/2 - 29;
        left_offet = -dc_jack_width/2 - h_offset;
        right_offet = dc_jack_width/2 + h_offset;

        for(pos = [
            [0, top_offset],
            [0, bottom_offset],
        ]){
            translate(pos){
                cylinder(h=pcb_support_skirt_zheight, r1=pcb_support_r*1.5, r2=pcb_support_r*1.5,$fn=fn);
            };
        };
        for(pos = [
            [left_offet, top_offset],
            [left_offet, bottom_offset],
            [right_offet, top_offset],
            [right_offet, bottom_offset],
        ]){
            translate(pos){
                translate([-pcb_support_r*2,-pcb_support_r]){
                    cube([pcb_support_r*4,pcb_support_r*2,pcb_support_skirt_zheight]);
                };
            };
        };
        for(pos = [
            [0, top_offset],
            [0, bottom_offset],
            [left_offet, top_offset],
            [left_offet, bottom_offset],
            [right_offet, top_offset],
            [right_offet, bottom_offset],
        ]){
            translate(pos){
                cylinder(h=support_height, r1=pcb_support_r, r2=pcb_support_r,$fn=fn);
                cylinder(h=pin_height, r1=pcb_pin_r, r2=pcb_pin_r,$fn=fn);
            };
        };
    };

    // left buckle
    translate([-buckle_height,(outer_height-back_frame_inset*2-thickness*4)/2,-dc_jack_zheight]){
        cube([buckle_height,thickness*4,back_frame_stack_zheight]);
    };
    translate([-buckle_height-thickness, (outer_height-back_frame_inset*2-thickness*6)/2, -dc_jack_zheight]){
        rcube(thickness,thickness*6,back_frame_stack_zheight,thickness/2);
    }
    // anchor
    translate([-anchor_thickness-anchor_gap,(outer_height-back_frame_inset*2-v_anchor_width)/2,-dc_jack_zheight]){
        cube([anchor_thickness,v_anchor_width,back_frame_stack_zheight+screen_base_zheight]);
    };

    // right buckle
    translate([outer_width,(outer_height-back_frame_inset*2-thickness*4)/2,-dc_jack_zheight]){
        cube([buckle_height,thickness*4,back_frame_stack_zheight]);
    };
    translate([outer_width+buckle_height, (outer_height-back_frame_inset*2-thickness*6)/2, -dc_jack_zheight]){
        rcube(thickness,thickness*6,back_frame_stack_zheight,thickness/2);
    }
    // anchor
    translate([outer_width+anchor_gap,(outer_height-back_frame_inset*2-v_anchor_width)/2,-dc_jack_zheight]){
        cube([anchor_thickness,v_anchor_width,back_frame_stack_zheight+screen_base_zheight]);
    };
};

module stand()
translate([(outer_width-stand_width-stand_slot_gap*2)/2+stand_slot_gap,back_frame_inset+stand_slot_offset+stand_slot_gap, stand_level]){
    rotate([90*flip,0,0]){
        // stand
        translate([0,0,0]){
            cube([stand_width, stand_thickness, stand_length]);
        };
    };
};

module dummy_screen()
translate([0,0,dummy_screen_level]){
    translate([0,0,screen_gap_z]){
        // module
        translate([thickness+screen_gap+screen_module_inset,thickness+screen_gap+screen_module_inset,0]){
            cube([screen_width-screen_module_inset*2, screen_height-screen_module_inset*2, screen_module_zheight]);
        };
        // glass
        translate([thickness+screen_gap,thickness+screen_gap,screen_module_zheight]){
            cube([screen_width, screen_height, screen_glass_thickness]);
        };
    };
};

module dummy_keypad()
translate([outer_width,keypad_offset, dummy_keypad_level]){
    translate([-keypad_stop_thickness-keypad_gap-keypad_thickness,0]){
        cube([keypad_thickness, keypad_width, keypad_height]);
    };

    translate([-keypad_stop_thickness-keypad_gap,0,10]){
        button_num = 5;
        button_size = 5;
        button_height = 3.3;
        button_offset = 15;
        button_r = 1.7;
        for(i=[1:button_num]){
            translate([0, button_offset*i, 0]){
                cube([button_height, button_size, button_size]);
                translate([button_height,button_size/2,button_size/2]){
                    rotate([0,90,0]){
                        cylinder(h=1.5, r1=button_r, r2=button_r,$fn=fn);
                    };
                };
            };
        };
    }
};

module dummy_micpad()
translate([(outer_width-micpad_width)/2,outer_height-thickness-gap, dummy_micpad_level]){
    translate([0,micpad_gap_z,-micpad_height-micpad_gap_xy]){
        // body
        cube([micpad_width, micpad_thickness, micpad_height]);

        // C4
        translate([4.7,-1.2,7.2]) cube([2.5, 1.2, 1.2]);

        // C2
        translate([micpad_width-15,-1.2,7.2]) cube([1.2, 1.2, 2.5]);

        // U1
        translate([9,micpad_thickness,3.3]) cube([3, 1.2, 4]);

        // U2
        translate([100-9-3,micpad_thickness,3.3]) cube([3, 1.2, 4]);

        // connector
        difference(){
            translate([micpad_connector_left_margin,-4.5,7.2]) cube([micpad_connector_width, 4.5, 3.2]);
            translate([micpad_connector_left_margin+0.5,-4.5,7.2+0.5]) cube([6.3-1, 4.5, 3.2-1]);
        };
    };
};

module interference(){
    if($children>=2){
        for(i=[0:$children-2]){
            for(j=[i+1:$children-1]){
                echo(i,j);
                intersection(){
                    children(i);
                    children(j);
                };
            }
        }
    }
};

//interference(){
screen_cover();
dummy_screen();
screen_holder();
screen_base();
back_frame();
stand();
dummy_keypad();
dummy_micpad();
//};