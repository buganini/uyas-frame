flip = 0;

e = 0.0001;
fn = 128;

width = 165;
angle = 23.5;
pillar_r = 6/2;
outer_r = (9.8 - 0.2)/2;
inner_r = 6/2;
trench_width = 4 - 0.2;
trench_depth = 4;
trench_gap = 0.5;
indent_depth = 3;
pin_length = 56.5;
stub_handle = 6.5;
stub_size = 7;
stub_pading_size = 1;
stub_r_gap = 0.1;
stub_handle_gap = 0.2;
vslit_size = 3;
vslit_angle = 35;
pin_length_gap = 1;
pick_slit_width = 2;
pick_slit_length = pin_length + stub_size*2 + pin_length_gap;
sleeve_length = 20 + outer_r + 5;
upper_stop_length = 25;
lower_stop_length = sleeve_length;
support_width = 20;
pillar_hole_depth = 20;

foot_width = 30;
foot_sleeve_length = 20;

module stand()
rotate([angle+90*flip-angle*flip,180*flip,0]){
    difference(){
        union(){
            difference(){
                union(){
                    // upper stop
                    translate([-trench_width/2,0,0]) cube([trench_width, trench_depth, upper_stop_length]);
                    hull(){
                        translate([-trench_width/2,0,0]) cube([trench_width, e, upper_stop_length]);
                        translate([-outer_r,0,outer_r]) cube([outer_r*2, e, e]);
                        translate([-outer_r,-outer_r,0]) cube([outer_r*2, e, e]);
                    };
                    
                    hull(){
                        // lower stop
//                        translate([0,0,-lower_stop_length]) cylinder(h=lower_stop_length, r1=outer_r, r2=outer_r, $fn=fn);

                        // pillar sleeve
                        rotate([-angle,0,0]) translate([0,0,-sleeve_length]) cylinder(h=sleeve_length, r1=outer_r, r2=outer_r, $fn=fn);
                    };
                    // stick
                    rotate([0,90,0]) cylinder(h=width, r1=outer_r, r2=outer_r, $fn=fn, center=true);
                };
                // pick slit
                rotate([0,0,0]){
                    translate([-width/2,-outer_r,-pick_slit_width/2]) cube([pick_slit_length, outer_r, pick_slit_width]);
                    translate([width/2-pick_slit_length,-outer_r,-pick_slit_width/2]) cube([pick_slit_length, outer_r, pick_slit_width]);
                };
                // vertical slit
                translate([width/2-pick_slit_length,0,0]) hull(){
                    translate([0,0,0]) cube([vslit_size,e,e]);
                    translate([0,-outer_r*2]) cube([vslit_size,e,e]);
                    rotate([vslit_angle,0,0]) translate([0,-outer_r*2]) cube([vslit_size,e,e]);
                };
                translate([-width/2+pick_slit_length-vslit_size,0,0]) hull(){
                    translate([0,0,0]) cube([vslit_size,e,e]);
                    translate([0,-outer_r*2]) cube([vslit_size,e,e]);
                    rotate([vslit_angle,0,0]) translate([0,-outer_r*2]) cube([vslit_size,e,e]);
                };
                // pillar hole
                rotate([-angle,0,0]) translate([0,0,-sleeve_length-e-sleeve_length]) cylinder(h=pillar_hole_depth+sleeve_length, r1=pillar_r, r2=pillar_r, $fn=fn);
                // through hole
                rotate([0,90,0]) cylinder(h=width, r1=inner_r, r2=inner_r, $fn=fn, center=true);
            };
            // solid fill
            fill_width = width - pick_slit_length*2;
            translate([-fill_width/2,0,0]) rotate([0,90,0]) cylinder(h=fill_width, r1=outer_r, r2=outer_r, $fn=fn);
        };
        // center indent
        translate([-(trench_width+trench_gap*2)/2,outer_r-indent_depth,-(trench_width+trench_gap*2)/2]) cube([trench_width+trench_gap*2,indent_depth,trench_width+trench_gap*2]);
    };
};

module stub()
rotate([0,-90*flip,0]) translate([width/2-pin_length-stub_size-pin_length_gap,0,0]){
    rotate([angle-90,0,0]) rotate([0,90,0]){
        cylinder(h=stub_size-stub_handle_gap, r1=inner_r-stub_r_gap, r2=inner_r-stub_r_gap, $fn=fn);
        translate([0,-(pick_slit_width-stub_handle_gap*2)/2,0]) cube([stub_handle, pick_slit_width-stub_handle_gap*2,stub_size-stub_handle_gap]);
    };
};

module foot()
translate([0,0,-100]){
    difference(){
        union(){
            translate([0,0,outer_r]) hull(){
                translate([-foot_width/2,0,0]) rotate([0,90,0]) cylinder(h=1,r1=outer_r,r2=outer_r,$fn=fn);
                translate([foot_width/2-1,0,0]) rotate([0,90,0]) cylinder(h=1,r1=outer_r,r2=outer_r,$fn=fn);
            };
            translate([0,0,outer_r]) cylinder(h=foot_sleeve_length, r1=outer_r, r2=outer_r, $fn=fn);
        };
        translate([0,0,outer_r*2]) cylinder(h=foot_width, r1=pillar_r, r2=pillar_r, $fn=fn);
    };
};

stand();
stub();
foot();