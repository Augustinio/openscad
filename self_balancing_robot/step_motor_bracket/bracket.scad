//facet number
$fn=50;

outer_cylinder_radius = 23;
inner_cylinder_radius = 14;
thickness = 6;
bracket_width = 2 * outer_cylinder_radius;
bracket_height = 50;
bracket_length = 45;
screw_hole_radius = 2.1;
motor_screw_hole_distance = 17;
mounting_screw_hole_offset = 8;

//create cube
module top_cube() {
    cube_width = 15;
    translate([outer_cylinder_radius - cube_width, -cube_width/2, -cube_width/2])
    cube(cube_width);
}

//horizontal_bracket_piece
module horizontal_bracket_piece() {
    translate([-bracket_length, -bracket_width/2, -thickness/2])
    cube([1, bracket_width, thickness]);
    
}

//vertical_bracket_piece
module vertical_bracket_piece() {
    translate([-bracket_length, -bracket_width/2, -thickness/2])
    cube([thickness, bracket_width, bracket_height]);
}

//screw_hole
module screw_hole() {
    cylinder(thickness + 2, screw_hole_radius, screw_hole_radius);
}

//motor screw holes
module left_motor_scew_hole(){
    translate([0, motor_screw_hole_distance, -thickness/2 - 1])
    screw_hole();
}

module motor_screw_holes(){
    left_motor_scew_hole();
    mirror([0, 1, 0])
    left_motor_scew_hole();
}

//mounting screw holes
module get_to_bracket_center() {
    translate([-bracket_length -1 , 0, bracket_height / 2])
    children();
}

module mounting_screw_hole(alpha, beta) {
    translate([-bracket_length -1 , 0, bracket_height / 2])
    translate([0, cos(alpha) * motor_screw_hole_distance, (bracket_height / 2 - mounting_screw_hole_offset) * sin(beta)])
    rotate([0, 90, 0])
    screw_hole();
}

module mounting_screw_holes() {
    mounting_screw_hole(0, 90);
    mounting_screw_hole(180, 90);
    mounting_screw_hole(0, 270);
    mounting_screw_hole(180, 270);
    
}

//main cylinder
module main_cylinder() {
    cylinder(thickness, outer_cylinder_radius, outer_cylinder_radius, center=true);
}

module bracket_and_cylinder(){
     hull(){
        main_cylinder();
        horizontal_bracket_piece();
        }
    vertical_bracket_piece();
}

//ring
module bracket(){
    difference() {
        bracket_and_cylinder();
                
        cylinder(thickness+1, inner_cylinder_radius, inner_cylinder_radius, center=true);
        top_cube();
        motor_screw_holes();
        mounting_screw_holes();
    }
}
bracket();