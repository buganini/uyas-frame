explode_z = 0;
explode_xy = 0;

fn = 128;
gap = 1.5;
body_w = 369;
body_h = 255.5;
body_zheight = 38;
cylinder_zheight = 24.6;
sponge_thickness = 38;
board_thickness = 20;
margin = 30;
eva_cube = 30;
eva_thickness = 5;
support_zheight = cylinder_zheight + sponge_thickness + 20 - eva_thickness;
support_length = 100;
support_thickness = 40 + eva_thickness;
support_w = support_length * cos(45);
box_w = body_w + margin*2 + sponge_thickness*2 + board_thickness*2 + support_w;
box_h = body_h + margin*2 + sponge_thickness*2 + board_thickness*2 + support_w;
box_base_zheight = board_thickness+support_zheight + eva_thickness + body_zheight;
body_offset_x = (box_w-body_w)/2;
body_offset_y = (box_h-body_h)/2;

module uyas()
translate(){
    trench = 4;
    pillar = 9.6/2;
    stand_length = 185.5;
    cylinder_r = 57/2;
    translate([0,0,support_zheight+eva_thickness]){
        difference(){
            union(){
                cube([body_w, body_h, body_zheight]);
                translate([0,0,-cylinder_zheight])
                for(p = [
                    [52,61,0],
                    [132,61,0],
                    [237,61,0],
                    [318,61,0],
                    [52,193,0],
                    [132,193,0],
                    [237,193,0],
                    [318,193,0],
                ]){
                    translate(p)
                    cylinder(h=cylinder_zheight,r1=cylinder_r,r2=cylinder_r,$fn=fn);
                }
            };
            translate([0,(body_h-trench)/2,body_zheight-trench]) cube([body_w, trench, trench]);
            translate([(body_w-trench)/2,0,body_zheight-trench]) cube([trench, body_h, trench]);
            translate([0,(body_h-trench)/2,0]) cube([body_w, trench, trench]);
            translate([(body_w-trench)/2,body_h/2,0]) cube([trench, body_h/2, trench]);
            translate([(body_w)/2,0,0]) rotate([0,90,90]) cylinder(h=body_h/2,r1=pillar, r2=pillar, $fn=fn);
            translate([(body_w-stand_length)/2,(body_h-pillar)/2+pillar/2,0]) rotate([0,90,0]) cylinder(h=stand_length,r1=pillar, r2=pillar, $fn=fn);
            translate([(body_w-stand_length)/2,pillar,0]) rotate([0,90,0]) cylinder(h=stand_length,r1=pillar, r2=pillar, $fn=fn);
            translate([(body_w-stand_length)/2,0,0]) cube([stand_length,pillar,pillar]);
            
            translate([0,(body_h-trench)/2,0]) cube([trench, trench, body_zheight]);
            translate([body_w-trench,(body_h-trench)/2,0]) cube([trench, trench, body_zheight]);
            translate([(body_w-trench)/2,0,0]) cube([trench, trench, body_zheight]);
            translate([(body_w-trench)/2,body_h-trench,0]) cube([trench, trench, body_zheight]);
        };
    };
}

module box_base()
translate(){
    translate([0,0,-board_thickness])
    cube([box_w, box_h, board_thickness]);
    
    // bottom-right
    translate([box_w-body_offset_x-support_w/2+eva_thickness,body_offset_y-support_w/2-eva_thickness,0]) rotate([0,0,45]) cube([support_length,support_thickness,support_zheight]);
    translate([box_w-body_offset_x+eva_thickness-eva_cube,body_offset_y-eva_thickness,support_zheight]) difference(){
        hollow_size = eva_cube - eva_thickness + gap;
        cube([eva_cube,eva_cube,eva_cube]);
        translate([0,eva_thickness-gap,eva_thickness-gap]) cube([hollow_size,hollow_size,hollow_size]);
    };

    // top-right
    translate([box_w-body_offset_x+support_w/2+eva_thickness,box_h-body_offset_y-support_w/2+eva_thickness,0]) rotate([0,0,135]) cube([support_length,support_thickness,support_zheight]);
    translate([box_w-body_offset_x+eva_thickness-eva_cube,box_h-body_offset_y+eva_thickness-eva_cube,support_zheight]) difference(){
        hollow_size = eva_cube - eva_thickness + gap;
        cube([eva_cube,eva_cube,eva_cube]);
        translate([0,0,eva_thickness-gap]) cube([hollow_size,hollow_size,hollow_size]);
    };
    
    // top-left
    translate([body_offset_x+support_w/2-eva_thickness,box_h-body_offset_y+support_w/2+eva_thickness,0]) rotate([0,0,225]) cube([support_length,support_thickness,support_zheight]);
    translate([body_offset_x-eva_thickness,box_h-body_offset_y+eva_thickness-eva_cube,support_zheight]) difference(){
        hollow_size = eva_cube - eva_thickness + gap;
        cube([eva_cube,eva_cube,eva_cube]);
        translate([eva_thickness-gap,0,eva_thickness-gap]) cube([hollow_size,hollow_size,hollow_size]);
    };
    
    // bottom-left
    translate([body_offset_x-support_w/2-eva_thickness,body_offset_y+support_w/2-eva_thickness,0]) rotate([0,0,315]) cube([support_length,support_thickness,support_zheight]);
    translate([body_offset_x-eva_thickness,body_offset_y-eva_thickness,support_zheight]) difference(){
        hollow_size = eva_cube - eva_thickness + gap;
        cube([eva_cube,eva_cube,eva_cube]);
        translate([eva_thickness-gap,eva_thickness-gap,eva_thickness-gap]) cube([hollow_size,hollow_size,hollow_size]);
    };
    
    translate([0,-explode_xy,0]) cube([box_w, board_thickness, box_base_zheight-board_thickness]);
    translate([-explode_xy,0,0]) cube([board_thickness, box_h, box_base_zheight-board_thickness]);
    translate([0,box_h-board_thickness+explode_xy,0]) cube([box_w, board_thickness, box_base_zheight-board_thickness]);
    translate([box_w-board_thickness+explode_xy,0,0]) cube([board_thickness, box_h, box_base_zheight-board_thickness]);
};

translate([body_offset_x,body_offset_y,explode_z]) uyas();
box_base();