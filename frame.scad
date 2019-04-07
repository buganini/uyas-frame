explosion_z = 50;
flip = 0;
e = 0.00000001;

gap = 1.0;
stand_gap = 0.1;
pcb_gap_xy = 1.5;
screen_gap = 1.0;
screen_gap_z = 0.05;
keypad_gap = 0.5;

thickness = 3;
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
screen_top_support_inset = 35;
screen_glass_thickness = 1.5 + 0.25;
screen_buckle_width = 35;
screen_buckle_height = 3;
buckle_height=4;

top_pcb_stopper_length = 6;
bottom_pcb_stopper_length = 12;

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
stand_width = 8;
stand_thickness = 2.5;
stand_slot_offset = 6; // toward top

back_frame_level = explosion_z*0;
screen_base_level = pcb_zheight + explosion_z*1;
screen_holder_level = screen_base_level + screen_base_stack_zheight + explosion_z;
dummy_screen_level = screen_holder_level + screen_holder_stack_zheight + explosion_z*0.5;
screen_cover_level = screen_holder_level + screen_holder_stack_zheight + e + explosion_z;
stand_level = pcb_zheight - stand_length - explosion_z;
dummy_keypad_level = screen_base_level+screen_base_zheight + explosion_z*0.5;

module screen_cover()
translate([0,0,screen_cover_level]){
    rotate([180*flip,0,0]){
        // cover
        translate([0,0,screen_glass_thickness+screen_module_zheight+screen_gap_z*2]){
            difference(){
                cube([outer_width, outer_height, screen_cover_thickness]);
                // visible area
                translate([(outer_width-screen_visible_width)/2,(outer_height-screen_visible_height)/2,0]){
                    cube([screen_visible_width, screen_visible_height, screen_cover_thickness]);
                };
            };
        };
        
        // border
        translate([0,0,0]){
            difference(){
                cube([outer_width, outer_height, screen_glass_thickness+screen_module_zheight+screen_gap_z*2]);
                translate([thickness,thickness,0]){
                    cube([screen_width+screen_gap*2, screen_height+screen_gap*2, screen_glass_thickness+screen_module_zheight+screen_gap_z*2]);
                };
            };
        };

        // top buckle
        translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
            cube([screen_buckle_width,screen_buckle_height,screen_cover_stack_zheight]);
        };
        translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
            cube([screen_buckle_width+thickness*2,thickness,screen_cover_stack_zheight]);
        };
        
        // bottom buckle
        translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
            cube([screen_buckle_width,screen_buckle_height,screen_cover_stack_zheight]);
        };
        translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
            cube([screen_buckle_width+thickness*2,thickness,screen_cover_stack_zheight]);
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
    translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_holder_stack_zheight]);
    };
    translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
        cube([screen_buckle_width+thickness*2,thickness,screen_holder_stack_zheight]);
    };
    
    // bottom buckle
    translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_holder_stack_zheight]);
    };
    translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
        cube([screen_buckle_width+thickness*2,thickness,screen_holder_stack_zheight]);
    };
};

module screen_base()
translate([0,0,screen_base_level]){
    hollow_width = pcb_width+pcb_gap_xy*2;
    hollow_height = pcb_height+pcb_gap_xy*2;

    // border
    difference(){
        cube([outer_width, outer_height, screen_base_zheight]);
        
        translate([(outer_width-hollow_width)/2,(outer_height-hollow_height)/2,0]){
            cube([
                hollow_width,
                hollow_height,
                screen_base_zheight]);
        };
    };


    difference(){
        translate([0,0,screen_base_zheight]){
            screen_support_zheight = screen_elevation+screen_gap_z;
            top_support_width = pcb_width-screen_top_support_inset*2;
            bottom_support_width = screen_width-gap*2;
            
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
        // screen holder space
        translate([(outer_width-screen_buckle_width)/2-gap,0,screen_base_stack_zheight]){
            cube([screen_buckle_width+gap*2, outer_height, screen_elevation-gap]);
        };
    };

    // top pcb stopper
    translate([(outer_width-pcb_support_r*2)/2,(outer_height-hollow_height)/2+hollow_height-top_pcb_stopper_length-pcb_gap_xy,0]){
        cube([pcb_support_r*2,top_pcb_stopper_length+pcb_gap_xy,screen_base_zheight]);
    };

    // bottom pcb stopper
    translate([(outer_width-pcb_support_r*2)/2,(outer_height-hollow_height)/2,0]){
        cube([pcb_support_r*2,bottom_pcb_stopper_length+pcb_gap_xy,screen_base_zheight]);
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
        cube([screen_buckle_width+thickness*2,thickness,screen_base_stack_zheight]);
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
        cube([screen_buckle_width+thickness*2,thickness,screen_base_stack_zheight]);
    };
    
    // left buckle
    translate([-buckle_height,(outer_height-thickness*4)/2,0]){
        cube([buckle_height,thickness*4,screen_base_zheight]);
    };
    translate([-buckle_height-thickness, (outer_height-thickness*6)/2, 0]){
        cube([thickness,thickness*6,screen_base_zheight]);
    }

    // right buckle
    translate([outer_width,(outer_height-thickness*4)/2,0]){
        cube([buckle_height,thickness*4,screen_base_zheight]);
    };
    translate([outer_width+buckle_height, (outer_height-thickness*6)/2, 0]){
        cube([thickness,thickness*6,screen_base_zheight]);
    }

    // keypad support
    // back
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, thickness+gap-keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_offset+keypad_width+keypad_stop_thickness+keypad_gap*2-thickness-gap, keypad_support_zheight]);
    };
    // top
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset+keypad_width+keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness*2+keypad_thickness+keypad_gap*2, keypad_stop_thickness, keypad_support_zheight]);
    };
    // bottom
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset-keypad_stop_thickness-keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness*2+keypad_thickness+keypad_gap*2, keypad_stop_thickness, keypad_support_zheight]);
    };
    // front - top
    translate([outer_width-keypad_stop_thickness, keypad_offset+keypad_width-keypad_stop_thickness,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_stop_thickness*2+keypad_gap, keypad_support_zheight]);
    };
    // front - bottom
    translate([outer_width-keypad_stop_thickness, keypad_offset-keypad_stop_thickness-keypad_gap,screen_base_zheight]){
        cube([keypad_stop_thickness, keypad_stop_thickness*2, keypad_support_zheight]);
    };
    // bump
    translate([outer_width-keypad_thickness-keypad_stop_thickness*2-keypad_gap*2, keypad_offset+keypad_width/2-keypad_stop_thickness/2,screen_base_zheight]){
        cube([keypad_stop_thickness+keypad_gap+keypad_bump, keypad_stop_thickness, keypad_support_zheight*0.75]);
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
            cube([outer_width, outer_height-back_frame_inset*2, back_frame_stack_zheight]);
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
        translate([(outer_width-stand_width-stand_gap*2)/2,stand_slot_offset, -dc_jack_zheight]){
            cube([stand_width+stand_gap*2, stand_thickness+stand_gap*2, back_frame_stack_zheight]);
        };

        stand_room_depth = stand_length-thickness*1.5;
        // stand room - top
        translate([gap*1.5,back_frame_height-stand_room_depth, -stand_width-stand_gap]){
            cube([stand_thickness+stand_gap*2, stand_room_depth, back_frame_stack_zheight]);
        };

        // stand room - right
        translate([outer_width-stand_room_depth,stand_slot_offset, -stand_width-stand_gap]){
            cube([stand_room_depth, stand_thickness+stand_gap*2, back_frame_stack_zheight]);
        };
        
    };
    
    // pcb support
    translate([(outer_width-dc_jack_width)/2+dc_jack_width/2,(back_frame_height-dc_jack_height)/2+dc_jack_height/2+dc_jack_offset,-dc_jack_zheight]){ // anchor to center of dc jack
        support_height = dc_jack_zheight;
        pin_height = dc_jack_zheight+pcb_zheight;
        
        h_offset = 68.4;
        top_offset = dc_jack_height/2 + 31.68;
        bottom_offset = -dc_jack_height/2 - 29.5;
        left_offet = -dc_jack_width/2 - h_offset;
        right_offet = dc_jack_width/2 + h_offset;
        
        for(pos = [
            [0, top_offset],
            [0, bottom_offset],
        ]){
            translate(pos){
                cylinder(h=support_height*0.7, r1=pcb_support_r*1.5, r2=pcb_support_r*1.5,$fn=64);
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
                    cube([pcb_support_r*4,pcb_support_r*2,dc_jack_zheight-smt_zheight]);
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
                cylinder(h=support_height, r1=pcb_support_r, r2=pcb_support_r,$fn=64);
                cylinder(h=pin_height, r1=pcb_pin_r, r2=pcb_pin_r,$fn=64);
            };
        };
    };
        
    // left buckle
    translate([-buckle_height,(outer_height-back_frame_inset*2-thickness*4)/2,-dc_jack_zheight]){
        cube([buckle_height,thickness*4,back_frame_stack_zheight]);
    };
    translate([-buckle_height-thickness, (outer_height-back_frame_inset*2-thickness*6)/2, -dc_jack_zheight]){
        cube([thickness,thickness*6,back_frame_stack_zheight]);
    }

    // right buckle
    translate([outer_width,(outer_height-back_frame_inset*2-thickness*4)/2,-dc_jack_zheight]){
        cube([buckle_height,thickness*4,back_frame_stack_zheight]);
    };
    translate([outer_width+buckle_height, (outer_height-back_frame_inset*2-thickness*6)/2, -dc_jack_zheight]){
        cube([thickness,thickness*6,back_frame_stack_zheight]);
    }
};

module stand()
translate([(outer_width-stand_width-stand_gap*2)/2+stand_gap,back_frame_inset+stand_slot_offset+stand_gap, stand_level]){
    rotate([90*flip,0,0]){
        // stand
        translate([0,0,0]){
            cube([stand_width, stand_thickness, stand_length]);
        };

        // handle
        translate([-thickness,0,0]){
            cube([stand_width+thickness*2, stand_thickness, thickness]);
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
                        cylinder(h=1.5, r1=button_r, r2=button_r,$fn=32);
                    };
                };
            };
        };
    }
};

module interference(){
    for(i=[0:$children-2]){
        for(j=[i+1:$children-1]){
            echo(i,j);
            intersection(){
                children(i);
                children(j);
            };
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
//};