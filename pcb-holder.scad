include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 100;

module top_part_projection() {
  translate([-32, -45])
    import("box-walls.svg", convexity = 3, center = true);
}

module inner_inlay() {
  hole_cover = 3.5;
  hole_x = 25.3;
  hole_y = 38.9;
  difference() {
    hull()
      top_part_projection();

    union() {
      top_part_projection();
      translate([-hole_x, -hole_y])
        circle(d = hole_cover);
      translate([hole_x, -hole_y])
        circle(d = hole_cover);
      translate([-hole_x, hole_y])
        circle(d = hole_cover);
      translate([hole_x, hole_y])
        circle(d = hole_cover);
    };
  }
}

module inner_with_top_lid() {
  inner_height = 3.5;
  lid_height = 2;

  union() {
    scale([0.99, 0.99])
      linear_extrude(height = inner_height)
        inner_inlay();

    up(inner_height)
    linear_extrude(height = lid_height)
      union() {
        top_part_projection();
        inner_inlay();
      };
  }
}

module cable_hole() {
  diameter = 3;
  distance = 3.5;
  hull() {
    back(distance / 2)
    circle(d = diameter);
    fwd(distance / 2)
    circle(d = diameter);
  }
}

module pcb() {
  usbc_width = 9.1;
  usbc_length = 7.5;
  usbc_height = 3.34;

  usbc_length_offset = 4.3;
  usbc_extends = 1;

  hole_offset = 1.7;
  hole_diameter = 1.5;

  difference() {
    color("red")
      cube(size = [pcb_length, pcb_width, pcb_height]);

    translate([hole_offset, hole_offset, -0.1])
      cylinder(h = pcb_height + 0.2, d = hole_diameter);

    translate([pcb_length - hole_offset, hole_offset, -0.1])
      cylinder(h = pcb_height + 0.2, d = hole_diameter);

    translate([pcb_length - hole_offset, pcb_width - hole_offset, -0.1])
      cylinder(h = pcb_height + 0.2, d = hole_diameter);

    translate([hole_offset, pcb_width - hole_offset, -0.1])
      cylinder(h = pcb_height + 0.2, d = hole_diameter);
  }

  color("blue")
    up(usbc_height / 2 + pcb_height + 0.1)
    right(pcb_length - usbc_height / 2 - usbc_length_offset)
    back(usbc_length - usbc_extends)
    rotate([90, 0, 0])
      hull() {
        cylinder(h = usbc_length, d = usbc_height);
        left(usbc_width - usbc_height)
        cylinder(h = usbc_length, d = usbc_height);
      }
}

module pcb_post(height, hole_diameter, post_diameter) {
  difference() {
    cylinder(h = height, d = post_diameter, center = true);
    down(0.1)
    cylinder(h = height + 0.3, d = hole_diameter, center = true);
  }
}

difference() {
  inner_with_top_lid();
  back(5)
  left(26)
  down(0.5)
  linear_extrude(height = 6.5)
    cable_hole();
}

pcb_width = 47.7;
pcb_length = 32.4;
pcb_height = 1.7;

box_width = 90;
box_length = 64;

hole_offset = 1.7;
hole_diameter = 1.5;

module pcb_holder() {
  post_height = 5;
  post_diameter = 4;
  power_post_offset = 4.5;

  translate([hole_offset, hole_offset])
    pcb_post(post_height, hole_diameter, post_diameter);

  translate([pcb_length - hole_offset, hole_offset])
    pcb_post(post_height, hole_diameter, post_diameter);

  translate([pcb_length - power_post_offset - post_diameter / 2, pcb_width, 1.5])
    cube([post_diameter, post_diameter, post_height + pcb_height * 2], center = true);
}


fwd(pcb_width / 2)
left((box_length - pcb_length) / 2) {
  up(8)
  pcb_holder();

  up(10.5)
  pcb();
}
