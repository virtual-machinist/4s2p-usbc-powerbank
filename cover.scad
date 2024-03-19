include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// smoothness
$fn = 100;

module cover_hull() {
  up(3)
  import("cover_hull.stl", convexity = 3, center = true);
}

module holes() {
  hole_x = 25.3;
  hole_y = 38.9;
  z_offset = 1;
  height = 4;
  translate([-hole_x, -hole_y, z_offset])
    screw_hole("M3", head = "flat", length = height);
  translate([hole_x, -hole_y, z_offset])
    screw_hole("M3", head = "flat", length = height);
  translate([-hole_x, hole_y, z_offset])
    screw_hole("M3", head = "flat", length = height);
  translate([hole_x, hole_y, z_offset])
    screw_hole("M3", head = "flat", length = height);
}

module cover_fillet(scale) {
  down(7.5)
  top_half(z = 7)
  scale([scale, scale, scale])
    import("cover_fillet.stl", convexity = 3, center = true);
}

module usbc_hole() {
  usbc_outer_width = 13;
  usbc_outer_length = 1.916;
  usbc_outer_height = 7;

  usbc_width = 9.4;
  usbc_length = 7.5;
  usbc_height = 3.6;

  rotate([90, 0, 0])
    hull() {
      cylinder(h = usbc_length, d = usbc_height);
      left(usbc_width - usbc_height)
      cylinder(h = usbc_length, d = usbc_height);
    }

  rotate([90, 0, 0])
    hull() {
      cylinder(h = usbc_outer_length, d = usbc_outer_height);
      left(usbc_outer_width - usbc_outer_height)
      cylinder(h = usbc_outer_length, d = usbc_outer_height);
    }
}

difference() {
  cover_hull();
  cover_fillet(0.94);
  holes();
  translate([-4.8, 37, 8.5])
    usbc_hole();
};
