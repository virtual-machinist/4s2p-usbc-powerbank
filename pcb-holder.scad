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

module inner_with_top_lid(tight_fit) {
  inner_height = 3.5;
  lid_height = 2;

  scale_factor = tight_fit ? 1 : 0.99;

  union() {
    scale([scale_factor, scale_factor])
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
  width = 5.5;
  length = 10.5;
  square([width, length], center = true);
}

pcb_width = 47.7;
pcb_length = 32.4;
pcb_thickness = 1.7;

pcb_hole_offset = 1.7;

module pcb(with_usb, thickness) {
  usbc_width = 9.1;
  usbc_length = 7.5;
  usbc_height = 3.34;

  usbc_length_offset = 4.3;
  usbc_extends = 1;

  pcb_hole_diameter = 2;

  difference() {
    color("red")
      cube(size = [pcb_length, pcb_width, thickness]);

    translate([pcb_hole_offset, pcb_hole_offset, -0.1])
      cylinder(h = thickness + 0.2, d = pcb_hole_diameter);

    translate([pcb_length - pcb_hole_offset, pcb_hole_offset, -0.1])
      cylinder(h = thickness + 0.2, d = pcb_hole_diameter);

    translate([pcb_length - pcb_hole_offset, pcb_width - pcb_hole_offset, -0.1])
      cylinder(h = thickness + 0.2, d = pcb_hole_diameter);

    translate([pcb_hole_offset, pcb_width - pcb_hole_offset, -0.1])
      cylinder(h = thickness + 0.2, d = pcb_hole_diameter);
  }

  if (with_usb) {
    color("blue")
      up(usbc_height / 2 + thickness + 0.1)
      right(pcb_length - usbc_height / 2 - usbc_length_offset)
      back(usbc_length - usbc_extends)
      rotate([90, 0, 0])
        hull() {
          cylinder(h = usbc_length, d = usbc_height);
          left(usbc_width - usbc_height)
          cylinder(h = usbc_length, d = usbc_height);
        }
  }
}

module pcb_post(height, hole_diameter, post_diameter) {
  difference() {
    cylinder(h = height, d = post_diameter, center = true);
    down(0.1)
    cylinder(h = height + 0.3, d = hole_diameter, center = true);
  }
}

module pcb_clamp(height, hole_diameter, post_diameter, overlap) {
  difference() {
    cylinder(h = height, d = post_diameter, center = true);
    union() {
      down(0.1)
      cylinder(h = height + 0.3, d = hole_diameter, center = true);
      fwd(post_diameter / 2)
      left(post_diameter / 2)
      down(height / 2 + 0.1)
      cube([overlap - 0.4, post_diameter, pcb_thickness + 0.1]);
    }
  }
}

difference() {
  inner_with_top_lid(true);
  back(5)
  left(25)
  down(0.5)
  linear_extrude(height = 6.5)
    cable_hole();
}

box_width = 90;
box_length = 64;

module pcb_holder() {
  post_height = 5;

  front_hole_diameter = 1.5;
  front_diameter = 4;

  back_hole_diameter = 3;
  back_hole_bolt_margin = -0.2;
  back_diameter = 6;

  back_overlap = 1.7;
  back_offset_x = 6.5;
  back_offset_y = 11;

  clamp_height = 4;

  translate([pcb_hole_offset, pcb_hole_offset])
    pcb_post(post_height, front_hole_diameter, front_diameter);

  translate([pcb_length - pcb_hole_offset, pcb_hole_offset])
    pcb_post(post_height, front_hole_diameter, front_diameter);

  translate([pcb_length - back_offset_x, pcb_width + back_overlap])
    pcb_post(post_height, back_hole_diameter + back_hole_bolt_margin, back_diameter);

  translate([-back_overlap, pcb_width - back_offset_y])
    pcb_post(post_height, back_hole_diameter + back_hole_bolt_margin, back_diameter);

  translate([pcb_length + back_overlap, pcb_width - back_offset_y])
    pcb_post(post_height, back_hole_diameter + back_hole_bolt_margin, back_diameter);

  translate([pcb_length - back_offset_x, pcb_width + back_overlap, 10])
    zrot(90)
    pcb_clamp(clamp_height, back_hole_diameter, back_diameter, back_overlap);

  translate([-back_overlap, pcb_width - back_offset_y, 10])
    zrot(180)
    pcb_clamp(clamp_height, back_hole_diameter, back_diameter, back_overlap);

  translate([pcb_length + back_overlap, pcb_width - back_offset_y, 10])
    pcb_clamp(clamp_height, back_hole_diameter, back_diameter, back_overlap);
}

fwd(pcb_width / 2 + 9.75)
left((box_length - pcb_length) / 2) {
  color("purple")
  up(8)
  pcb_holder();

  %up(10.5)
  %pcb(true, pcb_thickness);
}
