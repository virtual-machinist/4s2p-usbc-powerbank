include <BOSL2/std.scad>
include <BOSL2/screws.scad>

module external_box() {
  xrot(90)
    import("tarro.3mf", convexity=3);
}

module top_part_projection() {
  projection(cut=false)
    top_half(z=40)
      external_box();
}

module inner_inlay() {
  hole_cover=3.5;
  hole_x=25.3;
  hole_y=38.9;
  difference() {
    hull()
      top_part_projection();

    union() {
      top_part_projection();
      translate([-hole_x,-hole_y])
        circle(d=hole_cover,$fn=100);
      translate([hole_x,-hole_y])
        circle(d=hole_cover,$fn=100);
      translate([-hole_x,hole_y])
        circle(d=hole_cover,$fn=100);
      translate([hole_x,hole_y])
        circle(d=hole_cover,$fn=100);
    };
  }
}

module inner_with_top_lid() {
  inner_height=3.5;
  lid_height=2;  
    
  union() {
    scale([0.99,0.99])
      linear_extrude(height=inner_height)
        inner_inlay();

    up(inner_height)
      linear_extrude(height=lid_height)
        union() {
          top_part_projection();
          inner_inlay();
        };  
  }    
}

module cable_hole() {
  diameter=3;
  distance=3.5;  
  hull() {
     back(distance/2)
       circle(d=diameter,$fn=100);
     fwd(distance/2) 
       circle(d=diameter,$fn=100);
  }
}

difference() {
  inner_with_top_lid();
  back(5)
    left(26)  
      down(0.5)
        linear_extrude(height=6.5)
        cable_hole();  
}
