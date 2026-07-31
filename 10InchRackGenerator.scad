include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [Panel settings] */
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height of the rack in U units, can be a fraction for partial U (e.g. 1.5 for 1U plus half of the next U)
rack_height = 1.0; // [0.5:0.5:5]
// Thickness of the front panel (the flat face plate).
front_plate_thickness = 3.0;
// Guide rails show the suggested boundrys of the mounts of the rack.(guide rails will not show up in final rendering).
guide_rails_on = true;
// ========================================
/* [Component1] */
component1 = 1; // [1: Insert Mount, 2: Shelf Mount, 3: Hard Drive Mount, 4: disable]
component1_width = 110.0;
component1_depth = 122.0;
component1_height = 28.30;
component1_side_offset = 0;  // [-100:0.1:100]
component1_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component1_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component1_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air cutouts to reduce material and improve cooling.
component1_air_holes=true; // [true:Show air holes, false:Hide air holes]
// ========================================
/* [Component2] */
component2 = 4; // [1: Insert Mount, 2: Shelf Mount, 3: Hard Drive Mount, 4: disable]
component2_width = 110.0;
component2_depth = 122.0;
component2_height = 28.30;
component2_side_offset = 0;  // [-100:0.1:100]
component2_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component2_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component2_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air cutouts to reduce material and improve cooling.
component2_air_holes=true; // [true:Show air holes, false:Hide air holes]
// ========================================
/* [Component3] */
component3 = 4; // [1: Insert Mount, 2: Shelf Mount, 3: Hard Drive Mount, 4: disable]
component3_width = 110.0;
component3_depth = 122.0;
component3_height = 28.30;
component3_side_offset = 0;  // [-100:0.1:100]
component3_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component3_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component3_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air cutouts to reduce material and improve cooling.
component3_air_holes=true; // [true:Show air holes, false:Hide air holes]
// ========================================
/* [Keystone group 1] */
// Add keystone jacks to the front panel.
keystones1 = false;    // [true: Place keystone jacks, false: Remove keystone jacks]
//Rotate keystone jacks individually.
keystones1_I_rotate = 0;  // [-90:90:180]
//Move keystone group left or right. When jack is at 90 degrees recommend -91 as max offset
keystones1_side_offset = -95;  // [-95:0.1:95]
//Move keystone group up or down.
keystones1_up_offset = 0;  // [-100:0.1:100]
//increase or decrease the number of keystone jacks in the group.
keystones1_num = 1; // [1:1:10]
//increase or decrease the space between each keystone jacks in the group. When jack is at 90 degrees recommend 6.5 as min spaceing
keystones1_spaceing = 0; // [0:0.1:20]
//Enabling this feature will stack the keystones vertically instead of horazontally
keystones1_vertical = false;
// ========================================
/* [Keystone group 2] */
// Add keystone jacks to the front panel.
keystones2 = false;    // [true: Place keystone jacks, false: Remove keystone jacks]
//Rotate keystone jacks individually.
keystones2_I_rotate = 0;  // [-90:90:180]
//Move keystone group left or right. When jack is at 90 degrees recommend -91 as max offset
keystones2_side_offset = 95;  // [-95:0.1:95]
//Move keystone group up or down.
keystones2_up_offset = 0;  // [-100:0.1:100]
//increase or decrease the number of keystone jacks in the group.
keystones2_num = 1; // [1:1:10]
//increase or decrease the space between each keystone jacks in the group.
keystones2_spaceing = 0; // [0:0.1:20]
//Enabling this feature will stack the keystones vertically instead of horazontally
keystones2_vertical = false;
// ========================================
/* [Air Hole Settings] */
// size of struts between hexs.
hex_strut = 4; // [1:1:14]
// spacing determines how many hexs will fit in the space.
hex_spacing = 15;
// controls the thickness of the frame around the  hex cutout.
hex_bottom_frame = 10;  // [8:0.5:13]
// ========================================
/* [Advanced] */
// Used when rack_height is a fraction, cuts a half oval for screws, otherwise will cover up the hole
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
// Thickness of the shell that wraps around the part.
case_thickness = 6; // Thickness of case walls
// Make the front plate solid (no hole), useful to hide a part not needing to be accessed from the exterior.
front_plate_hole = true; // [true:Show front plate hole, false:Solid front plate]
// Prevent part from sliding out the front by adding a small 0.6mm lip around the front plate hole.
front_lip = true; // [true:Show front lip, false:Hide front lip]
//Changes the size of the stopper for shelfs
stopper_size=10;
// Default gap between part and print walls
tolerance = 0.42;
// ========================================
/* [Hidden] */
height = 44.45 * rack_height;
//ziptie variables
zip_tie_hole_count = 8;
zip_tie_hole_width = 1.5;
zip_tie_hole_length = 6;
zip_tie_indent_depth = 2;
zip_tie_cutout_depth = 8;
// Keystone jack dementions
keystone_width = 19.9;
keystone_height = 27.5;
keystone_depth = 9.7;
// epsilon for coplanar face fixes, fixes bug where some faces leave a thin sliver of material
e=0.01; 
// ============================================================================
//End parameters
module guide_rails(){
    
    translate([3/2 + 22, height/2, 2.9])
    color("red")
    cuboid([3, height, 6], chamfer=1, edges=["ALL"], $fn = 5);
    translate([rack_width - 3/2 - 22, height/2, 2.9])
    color("red")
    cuboid([3, height, 6], chamfer=1, edges=["ALL"], $fn = 5);
}
// Power wire cutouts: Make holes on left and/or right of the component_mount
module power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, wire_diameter) {
    
    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;
        
    mid_y = height/2 - component_up_offset; // Midplane of switch opening
    hole_spacing_x = component_width; // match rack holes
        
    if (front_wire_holes == 1 || front_wire_holes == 2){   //make left hole
        hole_left_x = (rack_width - component_width) / 2 - (wire_diameter /5) + component_side_offset;
        translate([hole_left_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter, $fn = 20);}
            }
    }
    if (front_wire_holes == 1 || front_wire_holes == 3){   //make right hole
        hole_right_x = (rack_width + component_width) / 2 + (wire_diameter /5) + component_side_offset;
        translate([hole_right_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter, $fn = 20);}
            }
    }
}

// front_panel: used to create Rack panel with mounting holes
module front_panel() {
    // Create all rack holes
    module all_rack_holes() {
        // Rack standard: 3 holes per U, with specific positioning
        // Each U is 44.45mm, holes are at specific positions within each U
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;

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
        
        for (side_x = [hole_left_x, hole_right_x]) {
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
                        translate([side_x, hole_y, front_plate_thickness/2]) {
                            cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=slot_height/2,edges=["Z"], $fn = 40);
                        }
                    }
                }
            }
        }
    }
    // Punch the full keystone footprint through the front face plate
    module keystone_front_cutout(keystone_jack_group, keystone_jack_side_offset, keystone_jack_up_offset, keystone_jack_num, keystone_jack_I_rotate, keystone_jack_spaceing, keystone_jack_vertical) {
        
        // checks if keystones should be made vertically or horazontally
        keystone_x_spacing = (keystone_jack_vertical) ? 0 : keystone_width + keystone_jack_spaceing;
        keystone_y_spacing = (keystone_jack_vertical) ? keystone_width + keystone_jack_spaceing : 0;
        
        if (keystone_jack_group) { //check if Keystone group enabled
            translate([0, 0, front_plate_thickness/2]) {
                for (i = [0:keystone_jack_num-1]) { // loop for making multible jacks
                        translate([rack_width/2 + keystone_jack_side_offset + i*(keystone_x_spacing), height/2 - keystone_jack_up_offset + i*(keystone_y_spacing), 0])
                            rotate([0,0,keystone_jack_I_rotate]) // rotate cuts for jacks individually
                                cube([keystone_width, keystone_height, front_plate_thickness + 2 * tolerance], center=true);
                }
            }
        }
    }
    module component_front_cutout(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes, component_wire_diameter ){
        blank_start = front_plate_hole ? 0 : front_plate_thickness/2;
        if (component < 4) {           
            translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, front_plate_thickness/2 + blank_start])
                cuboid([component_width + tolerance*2, component_height + tolerance*2, front_plate_thickness+1], $fn = 10);
            if (component1_wire_holes < 4){
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes,component_wire_diameter); 
            }
        }
    }
    // Making the plate
    //====================================================================================
    difference(){
        translate([rack_width/2, height/2, front_plate_thickness/2]) // this undoes the first translate in the main assembly might get rid of later. Translate Mark
        cuboid([rack_width, height, front_plate_thickness], rounding=4, edges=["Z"], $fn = 20); 
        all_rack_holes(); 
        keystone_front_cutout(keystones1,keystones1_side_offset,keystones1_up_offset,keystones1_num,keystones1_I_rotate,keystones1_spaceing, keystones1_vertical);
        keystone_front_cutout(keystones2,keystones2_side_offset,keystones2_up_offset,keystones2_num,keystones2_I_rotate,keystones2_spaceing, keystones2_vertical);

        //Cutout window in rack panel for componets. will need to change translates later Translate Mark
        component_front_cutout(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes, component1_wire_diameter );
        component_front_cutout(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes, component2_wire_diameter );
        component_front_cutout(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes, component3_wire_diameter );
    }
}
//========================================================================================
// component_mount: used to make the soild shape of the holder for each component 
// with air holes and ziptie modules inside as well.
module component_mount(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes) {
    
    //6 inch racks (mounts=152.4mm; rails=15.875mm; usable space=120.65mm)
    //10 inch racks (mounts=254.0mm; rails=15.875mm; usable space=221.5mm)
    chassis_width = min(component_width + (2 * case_thickness), (rack_width == 152.4) ? 120.65 : 221.5);
    chassis_edge_radius = 2.0;

    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness + tolerance;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;
    $fn = 64;

    // Create the main body as a separate module
    module body() {
        chassis_height = min(component_height + (2 * case_thickness), height);
        // Chassis body
        translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, chassis_depth_main/2])
            cuboid([chassis_width, chassis_height, chassis_depth_main - front_plate_thickness], rounding = chassis_edge_radius, edges=["Z"], $fn = 20);
    }
    // component_cutout: used to create cutout with optional lip for component_mount
    module component_cutout(){
 
    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;

    // Calculated dimensions
    cutout_w = component_width + (2 * tolerance);
    cutout_h = component_height + (2 * tolerance);
    cutout_x = (rack_width - cutout_w) / 2;
    cutout_y = (height - cutout_h) / 2;
        
        z_start = front_plate_hole ? -tolerance : front_plate_thickness;
        z_depth = front_plate_hole ? chassis_depth_main + 2*tolerance : chassis_depth_main - front_plate_thickness + tolerance;
        translate([((rack_width - cutout_w) / 2) + component_side_offset, ((height - cutout_h) / 2) - component_up_offset, z_start]) 
            cube([cutout_w, cutout_h, z_depth]);
}
    // Create zip tie holes and indents
    module shelf_type(){
        translate([rack_width/2 + component_side_offset,case_thickness/2 - component_up_offset, chassis_depth_main/2])
        cube([chassis_width - (case_thickness*2-tolerance*2) ,case_thickness*2,chassis_depth_main], center = true);
    }
    module zip_tie_features() {
        // Zip tie holes
        zip_z = component_depth + solid_z_offset;
        for (i = [0:zip_tie_hole_count-1]) {
            x_pos = (rack_width - component_width)/2 + component_side_offset + (component_width/(zip_tie_hole_count + 1)) * (i+1);
            translate([x_pos, 0, zip_z]) {
                cube([zip_tie_hole_width, height, zip_tie_hole_length]);
            }
        }
        // Zip tie indents (top and bottom)
        x_pos = ((rack_width - component_width)/2) + component_side_offset;
        chassis_height = min(component_height + (2 * case_thickness), height);
        // Top indent
        translate([x_pos, ((height - chassis_height)/2) - component_up_offset - e, zip_z]) {
            cube([component_width, zip_tie_indent_depth + e, zip_tie_cutout_depth + e]);
        }
        // Bottom indent
        translate([x_pos, ((height + chassis_height)/2 - zip_tie_indent_depth) + .1 - component_up_offset, zip_z]) {
            cube([component_width, zip_tie_indent_depth + e , zip_tie_cutout_depth + e]);
        }
    }
    // Simplified air holes with staggered honeycomb pattern on all faces
    module air_holes(){
        
        test_hex_fit_Y = (component_height + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
        test_hex_fit_x = (component_width + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
        test_hex_fit_z = (component_depth) - ( hex_spacing + hex_bottom_frame*2);        
        
        if(air_holes && test_hex_fit_z > 0){
            translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, component_depth/2]){
                if(test_hex_fit_x >= 0){// cut hex hole from top and bottom
                    difference(){         
                        cuboid([component_width + case_thickness*2 + e*2, component_height + case_thickness*2 + e*2, component_depth],rounding=0,edges=["Z"], $fn = 10);
                        hex_panel([component_width + case_thickness*2 + e*2, component_depth, component_height + case_thickness*2 + e*2], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=FRONT, $fn = 10); 
                    }
                }
                if (test_hex_fit_Y >= 0){//  cut hex holes form the sides
                    difference(){            
                        cuboid([component_width+ case_thickness*2 + e*2, component_height + case_thickness*2 + e*2, component_depth],rounding=0,edges=["Z"], $fn = 10);
                        hex_panel([ component_depth, component_height + case_thickness*2 + e*2, component_width+ case_thickness*2 + e*2 ], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=LEFT, $fn = 10); 
                    }
                }
            }
        }
    }
    
    // Adds a lip to each component
    module add_lip() {
        if(front_lip){
            difference() {
                translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, 0])
                    rect_tube(size=[component_width + tolerance*2,component_height + tolerance*2], wall=.6, h=.6, $fn = 10);
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter);
            }
        }
    }
    // Complete keystone with embossed triangle
    module add_stopper(){
        translate([rack_width/2 + component_side_offset - component_width/2-2, height - case_thickness - component_up_offset, chassis_depth_main-1.5])rotate([90,90,0])
            wedge([3,stopper_size,stopper_size]);
        translate([rack_width/2 + component_side_offset + component_width/2+2,height - case_thickness - component_up_offset, chassis_depth_main-4.5])rotate([90,-90,0])
            wedge([3,stopper_size,stopper_size]);
    }
    
    
    
    // Assembly - boolean structure
    // ==============================================================
    if(component < 4){
        union() {
            difference() {
                body();
                component_cutout();  
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter);
                air_holes();
                if(component == 1){
                    zip_tie_features();
                }
                if(component == 2){
                    shelf_type();                    
                }
            }
            if(component == 1){
                add_lip(); 
            }
            if(component == 2){
                add_stopper();
            }
        }
    }
}
module keystone(){
    // This module makes one cuboid then cuts it with three more and one cut for the triangle.
    
    hole_width=14.9;
    
    cut_1_height=3;
    cut_1_depth=19.3;
    cut_1_z_offset=-3.36;
    cut_1_y_offset=-.18;
    
    cut_2_height=5.35;
    cut_2_depth=24.4;
    cut_2_z_offset=.8;
    cut_2_y_offset=-.35;
    
    cut_3_height=2.35;
    cut_3_depth=19.8;
    cut_3_z_offset=4.5;
    cut_3_y_offset=-.65;

    
    translate([0, 0, keystone_depth/2])//makes the origin the face 
        difference(){
            //main body cuts are made from
            cuboid([keystone_width, keystone_height, keystone_depth], chamfer=1.25, edges=[TOP], $fn = 10);
            //cut 1
            translate([0, cut_1_y_offset,cut_1_z_offset])
                    cuboid([hole_width, cut_1_depth, cut_1_height], chamfer=3, edges=[FRONT+BOTTOM], $fn = 10);
            //cut 2
            translate([0, cut_2_y_offset, cut_2_z_offset])
                    cuboid([hole_width, cut_2_depth, cut_2_height], $fn = 10);
            //cut  3
            translate([0, cut_3_y_offset, cut_3_z_offset])
                    cuboid([hole_width, cut_3_depth, cut_3_height]);
            // cut for the triangle
            translate([0,(-keystone_height/2)+2.5 , -keystone_depth/2-.01])
                rotate([0,0,90])
                    linear_extrude(1)
                        circle(r=3, $fn=3);
        } 
}

module keystone_jack_group(keystone_jack_group, keystone_jack_side_offset, keystone_jack_up_offset, keystone_jack_num, keystone_jack_I_rotate, keystone_jack_spaceing, keystone_jack_vertical){
    
    // checks if keystones should be made vertically or horazontally
    keystone_x_spacing = (keystone_jack_vertical) ? 0 : keystone_width + keystone_jack_spaceing;
    keystone_y_spacing = (keystone_jack_vertical) ? keystone_width + keystone_jack_spaceing : 0;
    
    if (keystone_jack_group){   //check if Keystone group enabled
        for (i = [0:keystone_jack_num-1]) { // loop for making multible jacks
            translate([rack_width/2 + keystone_jack_side_offset + i*(keystone_x_spacing), height/2 - keystone_jack_up_offset + i*(keystone_y_spacing), 0]) 
                rotate([0,0,keystone_jack_I_rotate]){// rotate jacks individually
                    keystone();  
            }    
        }      
    }
}
//  make_rack(): Main assembly - boolean structure
// ==============================================================
module make_rack(){
        translate([-rack_width/2, -height/2, 0]){
                union(){
                    front_panel();
                    component_mount(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes, component1_wire_diameter, component1_air_holes);  
                    component_mount(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes, component2_wire_diameter, component2_air_holes);
                    component_mount(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes, component3_wire_diameter, component3_air_holes);
                    keystone_jack_group(keystones1,keystones1_side_offset,keystones1_up_offset,keystones1_num,keystones1_I_rotate,keystones1_spaceing, keystones1_vertical);
                    keystone_jack_group(keystones2,keystones2_side_offset,keystones2_up_offset,keystones2_num,keystones2_I_rotate,keystones2_spaceing, keystones2_vertical);
                }
            if($preview && guide_rails_on){
                guide_rails();
            }
        }
}
// ==============================================================
// Call the module
if ($preview) {
    rotate([-90,0,0])
        translate([0, -height/2, -component1_depth/2]){
            make_rack();
        }
} else {
    make_rack();
}
