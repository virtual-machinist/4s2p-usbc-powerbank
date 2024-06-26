include <BOSL2/std.scad>

// smoothness
$fn = 100;

height = 10;
wire_diameter = 2.5;
cell_hole_offset = 21.5;

module cover_hull() {
  rotate([90, 0, 0])
    import("18650_4s2p.3mf", convexity = 3);
}

module holes() {
  hole_height = height + 1;

  cylinder(h = hole_height, d = wire_diameter);
  left(cell_hole_offset)
  cylinder(h = hole_height, d = wire_diameter);
  right(cell_hole_offset)
  cylinder(h = hole_height, d = wire_diameter);
}

difference() {
  cover_hull();
  union() {
    down(height / 2 + 0.5)
    holes();
    up(4.25)
    cube([cell_hole_offset * 2 + wire_diameter, wire_diameter, wire_diameter], center = true);
  }
}

