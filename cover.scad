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


difference() {
  cover_hull();
  cover_fillet(0.92);
  holes();
};
