$fn = 32;

// The primary grid size
grid_size = 36;

bin_x = 2;
bin_y = 2;
bin_u = 1;
bin_h = bin_u*20;
bin_border = 1.5;
bin_clearance = 0;
base_base = 1.5;
interface_height = 2.2;
interface_size = grid_size/2;
interface_play = 0.25;

total_base = base_base + interface_height;
circular_interface=10;

magnet_diameter=6.1;
magnet_height = 2.2;

stack_slop = 0.2;

module draw_outer_bin() {
    cube( [ bin_x * grid_size - bin_clearance*2, bin_y*grid_size - bin_clearance*2, bin_h ] );
}

module draw_inner_bin() {
    translate( [bin_border, bin_border, total_base ] ) {
        cube( [ bin_x * grid_size - 2*bin_border - 2*bin_clearance, bin_y*grid_size - 2*bin_border - 2*bin_clearance, bin_h ] );
    }
}

module draw_interface( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2 - interface_play;
    y_pos = y * grid_size + (grid_size - interface_size)/2 - interface_play; 
    
    translate( [ x_pos, y_pos, 0 ] ) {
        color( "white" ) cube( [ interface_size + 2*interface_play, interface_size + 2*interface_play, interface_height] );
    }
}
  
module add_magnet( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2 + interface_size/2;
    y_pos = y * grid_size + (grid_size - interface_size)/2 + interface_size/2; 
    
    has_magnet = ( x == 0 && y == 0 ) || ( x == (bin_x-1) && y == 0 ) || 
                ( x == (bin_x-1) && y == (bin_y-1) ) || ( x == 0 && y == (bin_y-1) );
    
    if ( has_magnet ) {
        translate( [ x_pos, y_pos, 0 ] ) {
            difference() {

                color( "red" ) cylinder( h = interface_height + 0.1, r = (circular_interface - interface_play )/2 );
            
                cylinder( h = magnet_height, r = magnet_diameter/2 );
   
            }
        }
    }
}

module make_stackable() {
    difference() {
        cube( [ bin_x*grid_size, bin_y*grid_size, total_base ] );
        translate( [ bin_border+stack_slop, bin_border+stack_slop, 0 ] ) {
            cube( [ bin_x*grid_size - bin_border*2 - 2*stack_slop, bin_y*grid_size - bin_border*2 - 2*stack_slop, total_base  ] );
        }
    }
}

 difference() {

     translate( [ bin_clearance, bin_clearance, 0 ] ) {
        difference() {
        hull() {
            difference() {
                draw_outer_bin();
                make_stackable();
            }  
        }
            draw_inner_bin();
        }
     }
     
     for ( i = [ 0:1:( bin_x - 1 ) ] ) {
        for ( j = [ 0:1:( bin_y - 1 ) ] ) {
            draw_interface( i, j );
        }
     }
     
     //make_stackable();
}

     
     for ( i = [ 0:1:( bin_x - 1 ) ] ) {
        for ( j = [ 0:1:( bin_y - 1 ) ] ) {
            add_magnet( i, j );
        }
     }
