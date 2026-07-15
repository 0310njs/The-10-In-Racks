include <BOSL2/std.scad>
include <BOSL2/walls.scad>

cross_section_preview=true;

module keystone(){
    // This module makes one cuboid then cuts it with three more and one cut for the triangle.
    keystone_width = 19.9;
    keystone_height = 9.7;
    keystone_depth = 27.5;
    
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

    
    translate([0, 0, keystone_height/2])//makes the origin the face 
        difference(){
            //main body cuts are made from
            cuboid([keystone_width, keystone_depth, keystone_height], chamfer=1.25, edges=[TOP]);
            color("red")
            //cut 1
            translate([0, cut_1_y_offset,cut_1_z_offset])
                    cuboid([hole_width, cut_1_depth, cut_1_height], chamfer=3, edges=[FRONT+BOTTOM]);
            color("blue")
            //cut 2
            translate([0, cut_2_y_offset, cut_2_z_offset])
                    cuboid([hole_width, cut_2_depth, cut_2_height]);
            color("green")
            //cut  3
            translate([0, cut_3_y_offset, cut_3_z_offset])
                    cuboid([hole_width, cut_3_depth, cut_3_height]);
            color("White")
            // cut for the triangle
            translate([0,(-keystone_depth/2)+2.5 , -keystone_height/2-.01])
                rotate([0,0,90])
                    linear_extrude(1)
                        circle(r=3, $fn=3);
        }
}
if ($preview && cross_section_preview) {
    rotate([-90,0,0])
    difference() {
        keystone();
        translate([0, -20, -1])
            cube([10, 35, 60]);
    }
} else if ($preview) {
    rotate([-90,0,0])
        keystone();
} else {
    keystone();
}
