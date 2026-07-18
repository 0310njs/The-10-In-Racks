include <BOSL2/std.scad>

/* [Panel settings] */
Accessories=1; // [1: Tsprout, 2: Claw, 3: Top Plate Holder, 4: Top Plate]
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height of the rack in U units, can be a fraction for partial U (e.g. 1.5 for 1U plus half of the next U)
rack_height = 1.0; // [0.5:0.5:5]
// Thickness of the front panel (the flat face plate).
front_plate_thickness = 3.0;
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
/* [Hidden] */
height = 44.45 * rack_height;
e=0.01; // epsilon for coplanar face fixes, fixes faces that leave a thin sliver of material
$fn = 50; // how fine the shapes are.

hook_width=10;
hook_height=10;
hook_length=40;
hook_end_length=17;
hook_rounding=2;

plate_width=17;

module front_panel(){
    
    // Create all rack holes
    module all_rack_holes() {
        // Rack standard: 3 holes per U, with specific positioning
        // Each U is 44.45mm, holes are at specific positions within each U
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;

        // 10 inch rack = 10x7mm oval
        // 6 inch rack = 3.25 x 6.5mm oval
        slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
        slot_height = (rack_width == 152.4) ? 3.25 : 7.0;

        // Standard rack hole positions within each 1U (44.45mm) unit:
        // First hole: 6.35mm from top of U
        // Second hole: 22.225mm from top of U (middle)
        // Third hole: 38.1mm from top of U (6.35mm from bottom)
        u_hole_positions = [6.35, 22.225, 38.1]; // positions within each U
        
        // Calculate how many full and partial U units we need to consider
        max_u = ceil(rack_height); // Include partial U units
        
        for (side_x = [hole_left_x]) {
            for (u = [0:max_u-1]) {
                for (hole_pos = u_hole_positions) {
                    // Calculate hole position from top of entire rack
                    hole_y = height - (u * 44.45 + hole_pos);
                    // Always show holes that are at least partially within the rack height
                    // Always show holes fully inside the rack
                    fully_inside = (hole_y >= slot_height/2 && hole_y <= height - slot_height/2);
                    // Show partial holes at edge only if half_heighc v v c  t_holes is true
                    partially_inside = (hole_y + slot_height/2 > 0 && hole_y - slot_height/2 < height);
                    show_hole = fully_inside || (half_height_holes && partially_inside && !fully_inside);
                    if (show_hole) {
                        translate([side_x, hole_y, 0]) {
                            cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=slot_height/2,edges=["Z"]);
                        }
                    }
                }
            }
        }
    }
    // Making the plate
    //====================================================================================
    translate([-plate_width/2, -height/2, 0]){
        difference(){
            translate([plate_width/2, height/2, 0])
            cuboid([plate_width, height, front_plate_thickness], rounding=4, edges=["Z"]); 
            all_rack_holes(); 
        }
    }
}
// if cut is true bolt holt will make a bolt shape used to make a cut for the hole else it will make a whole bolt hole  15x15x6.
module bolt_hole(cut){
    difference(){
        if(!cut){
            translate([0,0,1])
                cuboid([15, 15, 6],rounding=1,edges=["ALL"]);
        }
        union(){
            linear_extrude(4+e)
                circle(r=5.5, $fn=6);
            translate([0,0,-2-e])
                linear_extrude(2.1)
                    circle(r=3, $fn=20);
        }
    }
}
module hook(){
    alignment_offset=2;
    
    translate([0,0,hook_length/2])  //hook body
        cuboid([hook_width, hook_height, hook_length],rounding=hook_rounding,edges=["ALL"]);
    translate([0,hook_end_length/2-alignment_offset,hook_length-alignment_offset/2])  //hook end
        cuboid([hook_height, hook_end_length-alignment_offset, hook_width],rounding=hook_rounding,edges=["ALL"]);
    translate([0,alignment_offset/2,hook_length-alignment_offset])  // hook bend
        xcyl(l=hook_width, d=hook_height+hook_rounding, rounding=hook_rounding);
}
module tsproot(){
    translate([0,0,plate_width/2])rotate([0,90,0]){
        front_panel();
        translate([(hook_width/4)+(hook_rounding/2),0,-front_plate_thickness/2]){
            hook();
            rotate([0,0,180])
                hook();
        }
    }
}
module claw(){
    translate([0,0,plate_width/2])rotate([0,90,0]){
        front_panel();
        translate([(hook_width/4)+(hook_rounding/2),0,-front_plate_thickness/2]){
            translate([0,-height/2+hook_height/2,0])
                hook();
            translate([0,height/2-hook_height/2,0])rotate([0,0,180])
                hook();
        }
    }
}
module top_plate_holder(){
    
    bridge_len=54;
    bolt_plate_width=20;
    bolt_plate_length=50;
    
    front_panel();
    translate([-(-plate_width+bridge_len)/2,-height/2-6,0])//bridge piece
            cuboid([bridge_len, 10, front_plate_thickness],rounding=1,edges=["Z"]);
    translate([0,-height/2,0])// connector between bridge and front panel
            cuboid([plate_width, 5.5, front_plate_thickness],rounding=1,edges=["NONE"]);
    translate([(-plate_width-bridge_len)/2-7,-height/2-front_plate_thickness,0])rotate([90,0,0])
    wedge([15,15,5]);
    
    //bolt plate
    difference(){
        union(){
            translate([-bridge_len+bolt_plate_width-1.5,-height/2-front_plate_thickness+.5,bolt_plate_length/2-front_plate_thickness/2]) //the plate
                cuboid([20, front_plate_thickness, bolt_plate_length],rounding=1,edges=["Y"]);
            translate([-bridge_len+bolt_plate_width-1.5,-height/2-front_plate_thickness+2,20])rotate([90,0,180]){//bolt hole mounts
                cuboid([15, 15, 6],rounding=1,edges=["ALL"]);
                translate([0,20,0])
                cuboid([15, 15, 6],rounding=1,edges=["ALL"]);
            }
        }
        translate([-bridge_len+bolt_plate_width-1.5,-height/2-front_plate_thickness+1,20])rotate([90,0,180]){  //the cuts for the bolt holes
            bolt_hole(true);
            translate([0,20,0])
            bolt_hole(true);
        }
    }
}
module top_plate(){
    plate_width=220;
    plate_depth=207;
    
    cutout_width=20;
    cutout_depth=10;
    
    slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
    slot_height = (rack_width == 152.4) ? 3.25 : 7.0;
    
    module cutout(pos1,pos2){
        translate([(pos1)*plate_width/2+(-pos1)*cutout_width/2, (-pos2)*plate_depth/2+(pos2)*cutout_depth/2, 0]){
            cuboid([cutout_width+e*2, cutout_depth+e*2, front_plate_thickness+e*2],rounding=1,edges=["NONE"]);
        }
    }
    
    module outside_bolt_hole(pos1,pos2){
        translate([(pos1)*plate_width/2+(-pos1)*cutout_width/2, (-pos2)*plate_depth/2+(pos2)*cutout_depth/2+(pos2)*20, 0]){
            cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=slot_height/2,edges=["Z"]);
            translate([0,(pos2)*20,0])
                cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=slot_height/2,edges=["Z"]);
        }
    }
    
    difference(){
        //the base of the plate
        cuboid([plate_width, plate_depth, front_plate_thickness],rounding=1,edges=["ALL"]);
        
        //cutouts for top plate holders
        cutout(1,1);
        cutout(-1,1);
        cutout(1,-1);
        cutout(-1,-1);

        //holes for connecting top plate to toop plate holder
        outside_bolt_hole(1,1);
        outside_bolt_hole(-1,1);
        outside_bolt_hole(1,-1);
        outside_bolt_hole(-1,-1);
    }
    
    
    
}
module make_accessories(){
    if(Accessories==1){
        tsproot();
    }
    if(Accessories==2){
        claw();
    }
    if(Accessories==3){
        translate([-20,0,0])
        top_plate_holder();
        translate([20,0,0])mirror([1,0,0])
        top_plate_holder();
    }
    if(Accessories==4){
        top_plate();
    }
    
}
if ($preview) {
    make_accessories();
}
 else {
    make_accessories();
}