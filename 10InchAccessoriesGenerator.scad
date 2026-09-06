include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [General Rack Settings] */
//Choose to generate a part of the frame or one of the many smaller parts call accessories.
show_me=1; // [1: Rack Frame Parts, 2: Rack Accessories]
//Choose which part of the frame to generate
rack_frame_part=1; // [1: Rack Feet, 2: Rack Rails, 3: Rack Handles, 4: Rack Panel, 5: Side Panel, 6: Top Plate, 7: Display Rack]
//Choose which type of accessorie to generate
accessories=1; // [1: Tsprout, 2: Claw, 3: Top Plate Holder, 4: Connection Parts]
//Currentlly not full supported need more input from users of 6in racks.
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height of the rack in U units, can be a fraction for partial U (e.g. 1.5 for 1U plus half of the next U)
rack_height = 1.0; // [0.5:0.5:5]
rack_depth = 2; // [1: Half Depth, 2: Full Depth]
// Thickness of the front panel (the flat face plate).
front_plate_thickness = 3.0;
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]

/* [Top plate settings] */
// Adds hexagon air cutouts to reduce material and improve cooling.
air_holes = true; // [true:Show air holes, false:Hide air holes]
hex_strut = 4; // [1:1:14]
// spacing determines how many hexs will fit in the space.
hex_spacing = 15;
// controls the thickness of the frame around the  hex cutout.
hex_bottom_frame = 10;  // [8:1:50]

/* [Connection Parts]  */
//Choose which type of connection part to generate
connection_part = 1; // [1: Connector Plate, 2: Hex Plate, 3: Bolt, 4: Nut]
//Choose to make the Connector Plate or Hex Plate double instead of single.
doubled = false;
//Choose to chamfer the corners of the hex plate
hex_chamfered = false;

/* [Hidden] */
height = 44.45 * rack_height;
depth = 100 * rack_depth;
e=0.01; // epsilon for coplanar face fixes, fixes faces that leave a thin sliver of material
$fn = 50; // how fine the shapes are.
tolerance = 0.42;

hook_width=10;
hook_height=10;
hook_length=40;
hook_end_length=17;
hook_rounding=2;

// used for makeing the front panel and alot of translate command in Accessories Modules
plate_width=17;

frame_part_width=32;
//***********************************Helper Modules*********************************//

// Makes mounting holes per the U size. "thickness" change to allow a long enough hole to cut the whole matterial. "slot" t/f control if the holes are round or slots.
module mount_holes(thickness,type,cut,height_change) {
 
    height = height_change;
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
                        if(type == 1){
                            linear_extrude(thickness + e*2,center = true, $fn = 15)
                                circle(d=6.5);
                        }
                        if(type == 2){
                            cuboid([slot_len, slot_height, thickness + e*2],rounding=slot_height/2,edges=["Z"], $fn = 30);
                        }
                        if(type == 3){
                            translate([-side_x, 0, 0])
                            bolt_hole(cut);
                        }
                    }
                }
            }
        }
    }
}
// Module used to make the mounting points with holes the will line up with the U size on the rack.
module connector_plate(change_height, hole_type){ 
    height = change_height;
    difference(){
        cuboid([plate_width, height, front_plate_thickness], rounding=4, edges=["Z"]); 
        translate([-plate_width/2, -height/2, 0])
            mount_holes(front_plate_thickness,hole_type,true,height); 
    }
}
// if cut is true bolt holt will make a bolt shape used with diffrence() to make a cut for the hole else it will make a whole bolt hole  15mmx15mmx6mm.
module bolt_hole(cut){
    difference(){
        if(!cut){
            translate([0,0,1])
                cuboid([15, 15, 6],rounding=1,edges=["ALL"]);
        }
        union(){
            linear_extrude(4+e)
                circle(r=11.6/2, $fn=6);
            translate([0,0,-2-e])
                linear_extrude(2.1)
                    circle(r=3.1, $fn=20);
        }
    }
}
module rail_connection_bump(){
        prismoid(size1=[8,8], size2=[4,4], h=3);
}
// Module used to make the tsproot and the claw
module hook(){
    alignment_offset=2;
    
    translate([0,0,hook_length/2])  //hook body
        cuboid([hook_width, hook_height, hook_length],rounding=hook_rounding,edges=["ALL"]);
    translate([0,hook_end_length/2-alignment_offset,hook_length-alignment_offset/2])  //hook end
        cuboid([hook_height, hook_end_length-alignment_offset, hook_width],rounding=hook_rounding,edges=["ALL"]);
    translate([0,alignment_offset/2,hook_length-alignment_offset])  // hook bend
        xcyl(l=hook_width, d=hook_height+hook_rounding, rounding=hook_rounding);
}
//***********************************Helper Modules*********************************//
//*******************************Rack Accessories Modules*************************//
module tsproot(){
    translate([0,0,plate_width/2])rotate([0,90,0]){
        connector_plate(height, 2);
        translate([(hook_width/4)+(hook_rounding/2),0,-front_plate_thickness/2]){
            hook();
            rotate([0,0,180])
                hook();
        }
    }
}
module claw(){
    translate([0,0,plate_width/2])rotate([0,90,0]){
        connector_plate(height, 2);
        translate([(hook_width/4)+(hook_rounding/2),0,-front_plate_thickness/2]){
            if(rack_height != .5){
                translate([0,height/2-hook_height/2,0])rotate([0,0,180])
                    hook(); 
            }
            translate([0,-height/2+hook_height/2,0])
                hook();
        }
        if(rack_height != .5){
            translate([0,height/2-6.3,0])
                cuboid([10.5, 7.5, front_plate_thickness],rounding=7.5/2,edges=["Z"]);
        }
        translate([0,-height/2+6.3,0])
            cuboid([10.5, 7.5, front_plate_thickness],rounding=7.5/2,edges=["Z"]);
        if(rack_height % 1){
            translate([0,-height/2+7.5/2,0])
                cuboid([17, 7.5, front_plate_thickness],rounding=7.5/2,edges=["Z"]);
        }
    }
}
module top_plate_holder(){
    
    bridge_len=54;
    bolt_plate_width=20;
    bolt_plate_length=50;
    height = 44.45;
    
    connector_plate(height, 2);
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
module connector_plate_doubled(){
    //Make the plates with holes next to each other
    translate([-plate_width/2,0,0])
        connector_plate(height,1);
    translate([plate_width/2,0,0])
        connector_plate(height,1);
    //Cover the gap at the top
    translate([0,height/2-4/2,0])
        cuboid([plate_width/2+1.5, 4, front_plate_thickness], rounding=1, edges=["Z"]);
    //Cover the gap at the bottom
    translate([0,-height/2+4/2,0])
        cuboid([plate_width/2+1.5, 4, front_plate_thickness], rounding=1, edges=["Z"]);
}
module hex_plate(){
    limit = 12;
    if(doubled){
        difference(){
            union(){
                translate([8,0,0])
                    intersection(){
                        cube([limit,limit,limit],center=true);
                        bolt_hole(false);
                    }
                translate([-8,0,0])
                    intersection(){
                        cube([limit,limit,limit],center=true);
                        bolt_hole(false);
                    }
                cube([4, limit, 4], center = true);
            }
            if(hex_chamfered){
                translate([-8.5-8,8.5,0])rotate([0,0,45])
                    cube([limit,limit,limit],center=true);
                translate([8.5+8,8.5,0])rotate([0,0,45])
                    cube([limit,limit,limit],center=true);
                }
        }
    }else{
        difference(){
            intersection(){
                
                cube([limit,limit,limit],center=true);
                bolt_hole(false);
            }
            if(hex_chamfered){
                translate([-8.5,8.5,0])rotate([0,0,45])
                    cube([limit,limit,limit],center=true);
                translate([8.5,8.5,0])rotate([0,0,45])
                    cube([limit,limit,limit],center=true);
                }
        }
    }
}
//*******************************Rack Accessories Modules*************************//
//*******************************Rack Frame Parts Modules*************************//
module rack_feet(){
    feet_height=8;
    feet_length=40;
    
    translate([0,0,feet_height/2]){
        difference(){
            union(){
                //Main Body
                translate([0,0,feet_height/2-5/2])
                    cube([frame_part_width,depth,5],center = true);
                // Stand off feet
                translate([0,depth/2-feet_length/2,0])
                    cube([frame_part_width, feet_length, feet_height],center = true);
                translate([0,-depth/2+feet_length/2,0])
                    cube([frame_part_width, feet_length, feet_height],center = true);
                // Rail connection point
                translate([0,-depth/2+16/2,feet_height/2+17/2])
                    cube([frame_part_width, 16, 17],center = true);
                translate([0,depth/2-16/2,feet_height/2+17/2])
                    cube([frame_part_width, 16, 17],center = true);
                // Rail connection point bumps
                translate([8,depth/2-15/2,feet_height/2+17])
                    rail_connection_bump();
                translate([-8,depth/2-15/2,feet_height/2+17])
                    rail_connection_bump();
                translate([8,-depth/2+15/2,feet_height/2+17])
                    rail_connection_bump();
                translate([-8,-depth/2+15/2,feet_height/2+17])
                    rail_connection_bump();
            }
            //Cutouts for bolt holes
            translate([0,depth/2-feet_length/2,feet_height/2+3]) 
                    cube([frame_part_width-3,35,15],center = true);
            translate([0,-depth/2+feet_length/2,feet_height/2+3])
                    cube([frame_part_width-3,35,15],center = true);
            //Bolt Hole cuts
            translate([8,-depth/2+2,feet_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole(true);
            translate([-8,-depth/2+2,feet_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole(true);
            translate([8,depth/2-2,feet_height/2+17-15.5])rotate([90,0,0])
                    bolt_hole(true);
            translate([-8,depth/2-2,feet_height/2+17-15.5])rotate([90,0,0]) 
                    bolt_hole(true);
            
        }
        //Bolt Hole Mounts
        translate([8,-depth/2+2,feet_height/2+17-15.5])rotate([-90,0,0]) 
                    bolt_hole();
        translate([-8,-depth/2+2,feet_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole();
        translate([8,depth/2-2,feet_height/2+17-15.5])rotate([90,0,0])
                    bolt_hole();
        translate([-8,depth/2-2,feet_height/2+17-15.5])rotate([90,0,0]) 
                    bolt_hole();
    }
    
    
}
module rack_rails(){
    //added to the length on the rail to account for the half U and a full U?
    add_half = rack_height % 1 == 0.5 ? 8 : 8;
    //used for postioning the mounting holes
    offset_half = rack_height % 1 == 0.5 ? 7 : -5;
    
    union(){
        difference(){
            //Main Body
            translate([0,0,6/2])
                cube([frame_part_width,height+add_half,6],center = true);
            //Bolt Hole Cuts
            translate([8,-height/2 - offset_half - add_half/2,4/2])
                mount_holes(6, 3, true, height);
            translate([-8,-height/2 - offset_half - add_half/2,4/2])
                mount_holes(6, 3, true, height);
            if(rack_height % 1 == 0.5){
                translate([-8,height/2 - 5,4/2])
                    bolt_hole(true);
                translate([8,height/2 - 5,4/2])
                    bolt_hole(true);
            }
        }
        difference(){
            union(){
                //Sides of main body
                translate([0,height/2 + 7/2 + add_half/2, 16/2])
                    cube([frame_part_width, 7, 16], center = true);
                translate([0,-height/2 - 7/2 - add_half/2, 16/2])
                    cube([frame_part_width, 7, 16], center = true);
                // Rail connection point bumps
                translate([8,height/2 + 7 + add_half/2 - e,16/2])rotate([-90,0,0])
                    rail_connection_bump();
                translate([-8,height/2 + 7 + add_half/2 - e,16/2])rotate([-90,0,0])
                    rail_connection_bump();
            } 
            // Rail connection point bumps
            translate([8,-height/2 - 7 - add_half/2 - e,16/2])rotate([-90,0,0])
                rail_connection_bump();
            translate([-8,-height/2 - 7 - add_half/2 - e,16/2])rotate([-90,0,0])
                rail_connection_bump();
        }
    }
}
module rack_handles(){
    Mounting_height=10;
    Handle_height=45;
    
    translate([0,0,18]){
        difference(){
            union(){
                //Main Body
                translate([0,0,Mounting_height/2-5/2])
                    cube([frame_part_width,depth,5],center = true);
                // Rail connection point
                translate([0,-depth/2+15/2,Mounting_height/2-23/2])
                    cube([frame_part_width, 15, 23],center = true);
                translate([0,depth/2-15/2,Mounting_height/2-23/2])
                    cube([frame_part_width, 15, 23],center = true);
                //Handle
                translate([0,0,Mounting_height/2+Handle_height/2])
                    cuboid([frame_part_width, depth, Handle_height],rounding=3,edges=[TOP]);
                
            }
            // Handle Cuts
            translate([0,0,Mounting_height/2+13/2+e])
                cuboid([frame_part_width+e*2, depth-30, 13],rounding=3,edges=[FRONT+BOTTOM, BACK+BOTTOM]);
            translate([0,0,Mounting_height/2+13])
                prismoid(size1=[frame_part_width+e*2,depth-30], size2=[frame_part_width+e*2,depth-60], h=17);
            // Handle side chamfers
            translate([0,-depth/2+Handle_height/4-e,Mounting_height/2+Handle_height/2+Handle_height/4+e])rotate([-90,0,0])
                    wedge([frame_part_width+e*2,Handle_height/2,Handle_height/2],center = true);
            translate([0,depth/2-Handle_height/4+e,Mounting_height/2+Handle_height/2+Handle_height/4+e])rotate([180,0,0])
                    wedge([frame_part_width+e*2,Handle_height/2,Handle_height/2],center = true);
            translate([frame_part_width/2-Handle_height/2+1.5,0,Mounting_height/2+Handle_height/2])rotate([180,0,90])
                    wedge([depth+e*2,Handle_height/2,Handle_height+e],center = true);
            // Rail connection point bumps
            translate([8,depth/2-15/2,-Mounting_height/2-23/2-3/2-e])
                rail_connection_bump();
            translate([-8,depth/2-15/2,-Mounting_height/2-23/2-3/2-e])
                rail_connection_bump();
            translate([8,-depth/2+15/2,-Mounting_height/2-23/2-3/2-e])
                rail_connection_bump();
            translate([-8,-depth/2+15/2,-Mounting_height/2-23/2-3/2-e])
                rail_connection_bump();
            //Bolt Hole cutouts
            translate([0,depth/2-40/2,-Mounting_height/2]) 
                    cube([frame_part_width-3,35,15],center = true);
            translate([0,-depth/2+40/2,-Mounting_height/2])
                    cube([frame_part_width-3,35,15],center = true);
            //Bolt Hole cuts
            translate([8,-depth/2+2,-Mounting_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole(true);
            translate([-8,-depth/2+2,-Mounting_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole(true);
            translate([8,depth/2-2,-Mounting_height/2+17-15.5])rotate([90,0,0])
                    bolt_hole(true);
            translate([-8,depth/2-2,-Mounting_height/2+17-15.5])rotate([90,0,0]) 
                    bolt_hole(true);
        }
        //Bolt Hole Mounts
        translate([8,-depth/2+2,-Mounting_height/2+17-15.5])rotate([-90,0,0]) 
                    bolt_hole();
        translate([-8,-depth/2+2,-Mounting_height/2+17-15.5])rotate([-90,0,0])
                    bolt_hole();
        translate([8,depth/2-2,-Mounting_height/2+17-15.5])rotate([90,0,0])
                    bolt_hole();
        translate([-8,depth/2-2,-Mounting_height/2+17-15.5])rotate([90,0,0]) 
                    bolt_hole();
    }
}
module top_plate(){
    plate_width=220;
    plate_depth=depth+7;
    
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
        translate([(pos1)*plate_width/2+(-pos1)*cutout_width/2, (-pos2)*plate_depth/2+(pos2)*slot_height/2+(pos2)*18, 0]){
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
        
        test_hex_fit_Y = (plate_depth -20*2) - ( hex_spacing + hex_bottom_frame*2 + hex_strut*2);
        test_hex_fit_x = (plate_width -20*2) - ( hex_spacing + hex_bottom_frame*2 + hex_strut*2);
        
        if(air_holes && test_hex_fit_Y > 0 && test_hex_fit_x > 0){
            difference(){         
                cuboid([plate_width-20, plate_depth-20, front_plate_thickness + e*2],rounding=0,edges=["Z"]);
                hex_panel([plate_width-20, plate_depth-20, front_plate_thickness + e*2], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=TOP, $fn = 10); 
            }
        }
    }
}
module side_panel(){
    difference(){
        union(){
            //Main Body
            translate([0,0,4/2])
                cube([height, depth, 4], center = true);
            //Sides of main body
            translate([0,depth/2+4/2,18/2])
                cube([height, 4, 18], center = true);
            translate([0,-depth/2-4/2,18/2])
                cube([height, 4, 18], center = true);
        }
        //Mount Holes
        mount_spaceing = (depth >= 200) ? 16 : 15;
        translate([-height/2,-depth/2+18/2,4/2])rotate([0,0,-90])
            for (i=[12:mount_spaceing:depth]){
                translate([-i,0,0])
                    mount_holes(4, 1, true, height);
            }
        // Rack mount holes
        translate([-height/2,-depth/2-4/2,4/2])rotate([0,-90,-90])
            mount_holes(4, 2, true, height);
        translate([-height/2,depth/2+4/2,4/2])rotate([0,-90,-90])
            mount_holes(4, 2, true, height);
    }
}
module rack_panel(){
    difference(){
        union(){
            //Main Body
            translate([0,0,4/2])
                cube([height, (rack_width-30), 4], center = true);
            //Sides of main body
            translate([0,(rack_width-30)/2+15/2,4/2])
                cube([height, 15, 4], center = true);
            translate([0,-(rack_width-30)/2-15/2,4/2])
                cube([height, 15, 4], center = true);
        }
        //Mount Holes
        //mount_spaceing = (depth >= 200) ? 16 : 15;
        translate([-height/2,-(rack_width-30)/2+18/2,4/2])rotate([0,0,-90])
            for (i=[6.5:16:(rack_width-30)]){
                translate([-i,0,0])
                    mount_holes(4, 1, true, height);
            }
        // Rack mount holes
        translate([-height/2,-(rack_width-30)/2+1,4/2])rotate([0,0,-90])
            mount_holes(4, 2, true, height);
        translate([-height/2,(rack_width-30)/2-1,4/2])rotate([0,180,-90])
            mount_holes(4, 2, true, height);
    }
}
module display_rack(){
    
    translate([rack_width/2,0,0])
        rack_feet();
    translate([-rack_width/2,0,0])
        rack_feet();
    rotate([90,0,0])translate([0,height/2+7,0]){
        translate([-rack_width/2,29,-depth/2])
            rack_rails();
        translate([rack_width/2,29,-depth/2])
            rack_rails();
    }
    rotate([90,0,180])translate([0,height/2+7,0]){
        translate([-rack_width/2,29,-depth/2])
            rack_rails();
        translate([rack_width/2,29,-depth/2])
            rack_rails();
    }
    translate([rack_width/2,0,33+height+14])
        rack_handles();
    translate([-rack_width/2,0,33+height+14])rotate([0,0,180])
        rack_handles();
    translate([0,0,front_plate_thickness/2+height+73])
        top_plate();
    
    translate([rack_width/2+8,-depth/2-front_plate_thickness/2,front_plate_thickness/2+29+height+15.5])rotate([-90,0,0]){
        top_plate_holder();
        translate([-rack_width-16,0,0])mirror([1,0,0])
        top_plate_holder();
        }
    
}
//*******************************Rack Frame Parts Modules*************************//
//*******************************Switch Case Modules*************************//
module make_accessories(){
    if(accessories==1){
        tsproot();
    }
    if(accessories==2){
        claw();
    }
    if(accessories==3){
        translate([-20,0,0])
        top_plate_holder();
        translate([20,0,0])mirror([1,0,0])
        top_plate_holder();
    }
    if(accessories==4){
        make_connection_parts();
    }
    
}
module make_frame_parts(){
    if(rack_frame_part==1){
        rack_feet();
    }
    if(rack_frame_part==2){
        rack_rails();
    }
    if(rack_frame_part==3){
        rack_handles();
    }
    if(rack_frame_part==4){
        rack_panel();
    }    
    if(rack_frame_part==5){
        side_panel();
    }
    if(rack_frame_part==6){
        top_plate();
    }
    if(rack_frame_part==7){
        display_rack();
    }
    
}
module make_connection_parts(){
    if(connection_part==1){
        if(doubled){
            connector_plate_doubled();
        }else{
            connector_plate(height, 1);
        }
    }
    if(connection_part==2){
        hex_plate();
    }
    if(connection_part==3){
        
    }
    if(connection_part==4){
        
    }
}
//*******************************Switch Case Modules*************************//
//*******************************Exacuted code*************************//
if ($preview) {
    if(show_me==1){
        make_frame_parts();
    }
    if(show_me==2){
        make_accessories();
    }
}
 else {
    if(show_me==1){
        make_frame_parts();
    }
    if(show_me==2){
        make_accessories();
    }
}