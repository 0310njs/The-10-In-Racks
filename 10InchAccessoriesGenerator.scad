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
hook_length=50;
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

module hook(){
    alignment_offset=2;
    
    translate([0,0,hook_length/2])  //hook body
        cuboid([hook_width, hook_height, hook_length],rounding=hook_rounding,edges=["ALL"]);
    translate([0,hook_length/6-alignment_offset,hook_length-alignment_offset/2])  //hook end
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
if ($preview) {
    if(Accessories==1){
        tsproot();
    }
    if(Accessories==2){
        claw();
    }
}
 else {
    if(Accessories==1){
        tsproot();
    }
    if(Accessories==2){
        claw();
    }
}
