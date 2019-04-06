explosion_z = 50;
flip = 0;

gap = 1.5;
stand_gap = 0.1;
pcb_gap_xy = 1.5;

thickness = 4;
screen_width = 177.5 + 1.0;
screen_height = 120.9 + 1.0;
outer_width = screen_width + thickness*2;
outer_height = screen_height + thickness*2;
screen_cover_thickness = 2;
screen_visible_width = 160;
screen_visible_height = 105;
screen_holder_zheight = 2;
screen_base_zheight = 5;
screen_module_zheight = 3.82;
screen_module_holder_zheight = 1;
screen_module_support_thickness = 5;
screen_elevation = 17 - screen_module_zheight; // number measured from pcb top to screen glass bottom
screen_support_thickness = 5; // max 9
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

screen_cover_stack_zheight = screen_cover_thickness+screen_glass_thickness+screen_module_zheight;
screen_holder_stack_zheight = screen_holder_zheight;
screen_base_stack_zheight = screen_elevation-screen_holder_zheight;
back_frame_stack_zheight = dc_jack_zheight + pcb_zheight;

stand_length = 30 + back_frame_stack_zheight;
stand_width = 8;
stand_thickness = 2.5;
stand_slot_offset = 6; // toward top

module screen_cover()
translate([0,0,screen_base_stack_zheight+screen_holder_stack_zheight+explosion_z*3]){
    rotate([180*flip,0,0]){
        // cover
        translate([0,0,screen_glass_thickness+screen_module_zheight]){
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
                cube([outer_width, outer_height, screen_glass_thickness+screen_module_zheight]);
                translate([thickness,thickness,0]){
                    cube([screen_width, screen_height, screen_glass_thickness+screen_module_zheight]);
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
translate([0,0,screen_base_stack_zheight+explosion_z*2]){
    difference(){
        union(){
            // base
            translate([(outer_width-screen_buckle_width)/2,0,0]){
                cube([screen_buckle_width, outer_height, screen_holder_zheight]);
            };
            
            // module support
            translate([(outer_width-screen_buckle_width)/2,thickness+gap,screen_holder_zheight]){
                cube([screen_buckle_width, screen_height-gap, screen_module_zheight-gap]);
            };
        };
        // hollow
        hollow_ratio_x = 0.50;
        hollow_ratio_y = 0.75;
        translate([(outer_width-screen_buckle_width)/2+(screen_buckle_width-screen_buckle_width*hollow_ratio_x)/2,(outer_height-screen_height*hollow_ratio_y)/2,0]){
            cube([screen_buckle_width*hollow_ratio_x, screen_height*hollow_ratio_y, screen_holder_zheight+screen_module_zheight-gap]);
        };
    };
    
    // top buckle
    translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_holder_zheight]);
    };
    translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
        cube([screen_buckle_width+thickness*2,thickness,screen_holder_zheight]);
    };
    
    // bottom buckle
    translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_holder_zheight]);
    };
    translate([(outer_width-(screen_buckle_width+thickness*2))/2,-screen_buckle_height-thickness,0]){
        cube([screen_buckle_width+thickness*2,thickness,screen_holder_zheight]);
    };
};

module screen_base()
translate([0,0,explosion_z*1]){
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
        union(){
            top_support_width = screen_width-gap*2-thickness*16;
            bottom_support_width = screen_width-gap*2;
            
            // top screen support
            translate([(outer_width-top_support_width)/2,thickness+screen_height-screen_support_thickness-gap,0]){
                cube([top_support_width, screen_support_thickness, screen_elevation-gap]);
            };

            // bottom screen support
            translate([(outer_width-bottom_support_width)/2,thickness+gap,0]){
                cube([bottom_support_width , screen_support_thickness, screen_elevation-gap]);
            };
        };
        translate([(outer_width-screen_buckle_width)/2-gap,0,screen_base_stack_zheight]){
            cube([screen_buckle_width+gap*2, outer_height, screen_elevation-gap]);
        };
    };

    // top pcb stopper
    translate([(outer_width-pcb_support_r*2)/2,(outer_height-hollow_height)/2+hollow_height-top_pcb_stopper_length,0]){
        cube([pcb_support_r*2,top_pcb_stopper_length,screen_base_zheight]);
    };

    // bottom pcb stopper
    translate([(outer_width-pcb_support_r*2)/2,(outer_height-hollow_height)/2,0]){
        cube([pcb_support_r*2,bottom_pcb_stopper_length,screen_base_zheight]);
    };


    // top buckle
    translate([(outer_width-screen_buckle_width)/2,screen_height+thickness-gap,0]){
        cube([screen_buckle_width,screen_buckle_height+gap,screen_base_stack_zheight]);
    };
    translate([(outer_width-screen_buckle_width)/2,outer_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_base_stack_zheight]);
    };
    translate([(outer_width-(screen_buckle_width+thickness*2))/2,outer_height+screen_buckle_height,0]){
        cube([screen_buckle_width+thickness*2,thickness,screen_base_stack_zheight]);
    };
    
    // bottom buckle
    translate([(outer_width-screen_buckle_width)/2,0,0]){
        cube([screen_buckle_width,screen_buckle_height+gap,screen_base_stack_zheight]);
    };
    translate([(outer_width-screen_buckle_width)/2,-screen_buckle_height,0]){
        cube([screen_buckle_width,screen_buckle_height,screen_base_stack_zheight]);
    };
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
};

module back_frame()
translate([0,back_frame_inset,explosion_z*0]){
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
        louver_width = screen_width/2-thickness*10;
        translate([0, (screen_height-thickness*louver_num*2)/2+thickness, -dc_jack_zheight]){
            for(i=[0:louver_num-1]){
                translate([thickness*6, thickness*i*2, 0]){
                    cube([louver_width, thickness, dc_jack_zheight-smt_zheight]);
                };
                translate([outer_width-back_frame_inset-thickness*6-louver_width, thickness*i*2, 0]){
                    cube([louver_width, thickness, dc_jack_zheight-smt_zheight]);
                };
            };
        };
        
        // stand slot
        translate([(outer_width-stand_width-stand_gap*2)/2,stand_slot_offset, -dc_jack_zheight]){
            cube([stand_width+stand_gap*2, stand_thickness+stand_gap*2, back_frame_stack_zheight]);
        };

        // stand room - top
        translate([gap*1.5,back_frame_height-stand_length-stand_gap, -stand_width-stand_gap]){
            cube([stand_thickness+stand_gap*2, stand_length+stand_gap, back_frame_stack_zheight]);
        };

        // stand room - right
        translate([outer_width-stand_length-stand_gap,stand_slot_offset, -stand_width-stand_gap]){
            cube([stand_length+stand_gap, stand_thickness+stand_gap*2, back_frame_stack_zheight]);
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
            [left_offet, top_offset],
            [left_offet, bottom_offset],
            [right_offet, top_offset],
            [right_offet, bottom_offset],
        ]){
            translate(pos){
                cylinder(h=support_height, r1=pcb_support_r, r2=pcb_support_r);
                cylinder(h=pin_height, r1=pcb_pin_r, r2=pcb_pin_r);
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
translate([(outer_width-stand_width-stand_gap*2)/2+stand_gap,back_frame_inset+stand_slot_offset+stand_gap, pcb_zheight-stand_length-explosion_z]){
    rotate([90*flip,0,0]){
        // stand
        translate([0,0,0]){
            cube([stand_width, stand_thickness, stand_length]);
        };

        // stopper
        translate([-thickness,0,thickness*2]){
            cube([stand_width+thickness*2, stand_thickness, thickness]);
        };

        // handle
        translate([-thickness,0,0]){
            cube([stand_width+thickness*2, stand_thickness, thickness]);
        };
    };
};


//intersection(){
screen_cover();
screen_holder();
screen_base();
back_frame();
stand();
//};
