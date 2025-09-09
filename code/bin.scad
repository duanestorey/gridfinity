$fn = 32;

// The primary grid size
grid_size = 25;

bin_x = 2;
bin_y = 3;
bin_h = 30;
bin_border = 1.5;
bin_clearance = 1;
base_base = 1.2;
interface_height = 2;
interface_size = grid_size/2;
interface_play = 0.1;

total_base = base_base + interface_height;

module draw_bin() {
    difference() {
        cube( [ bin_x * grid_size - bin_clearance*2, bin_y*grid_size - bin_clearance*2, bin_h ] );
        translate( [bin_border, bin_border, total_base ] ) {
        cube( [ bin_x * grid_size - 2*bin_border - 2*bin_clearance, bin_y*grid_size - 2*bin_border - 2*bin_clearance, bin_h ] );
        }
    }
}

module draw_interface( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2 - interface_play;
    y_pos = y * grid_size + (grid_size - interface_size)/2 - interface_play; 
    
    translate( [ x_pos, y_pos, 0 ] ) {
        color( "white" ) cube( [ interface_size + 2*interface_play, interface_size + 2*interface_play, interface_height] );
    }
}
  


 difference() {
     translate( [ bin_clearance, bin_clearance, 0 ] ) {
        draw_bin();
     }
        for ( i = [ 0:1:( bin_x - 1 ) ] ) {
            for ( j = [ 0:1:( bin_y - 1 ) ] ) {
                draw_interface( i, j );
            }
        }
 
}