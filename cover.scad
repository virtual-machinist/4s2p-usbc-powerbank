include <BOSL2/std.scad>
include <BOSL2/screws.scad>

module bottom_contour() {
    import("bottom-contour.svg", convexity=3, center=true);
}

module mid_contour() {
  back(7.7)
    import("mid-contour.svg", convexity=3, center=true);
}

linear_extrude(height=5)
  bottom_contour();

color("red")
linear_extrude(height=20)
  mid_contour();

//todo chamfer radius top = 3mm
