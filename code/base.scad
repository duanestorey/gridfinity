$fn = 32;

// The primary grid size
grid_size = 25;

// Configurable options
include_screws = true;

base_x = 3;
base_y = 3;
base_height = 5;

interface_height = 2;
interface_size = grid_size/2;

base_border = 2;
base_excess_space = grid_size - interface_size - 3*base_border;

module draw_one_interface( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2;
    y_pos = y * grid_size + (grid_size - interface_size)/2; 
    
    translate( [ x_pos, y_pos, base_height ] ) {
        color( "white" ) cube( [ interface_size, interface_size, interface_height] );
    }
}

module draw_one_base( x, y ) {
    x_pos = x * grid_size;
    y_pos = y * grid_size;
    
    translate( [ x_pos, y_pos ] ) {
        color( "grey" ) cube( [ grid_size, grid_size, base_height ] );
    }
}

module draw_positive_base( x, y ) {
    draw_one_base( x, y );  
    draw_one_interface( x, y );
}

module draw_negative_base( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2;
    y_pos = y * grid_size + (grid_size - interface_size)/2;
    
    translate( [ x_pos - base_excess_space - base_border, y_pos, 0 ] ) {
        cube( [ base_excess_space, interface_size, 5 ] );
    }
    
    translate( [ x_pos + interface_size + base_border, y_pos, 0 ] ) {
        cube( [ base_excess_space, interface_size, 5 ] );
    }
    
    translate( [ x_pos, y_pos - base_excess_space - base_border, 0 ] ) {
        cube( [ interface_size, base_excess_space, 5 ] );
    }
    
    translate( [ x_pos, y_pos + interface_size + base_border, 0 ] ) {
        cube( [ interface_size, base_excess_space, 5 ] );
        
    }
}

module draw_outside_border() {
    difference() {
        color( "white" ) cube( [ grid_size * base_x, grid_size * base_y, base_height ] );
        translate( [ base_border, base_border, 0 ] ) {
            cube( [ grid_size * base_x - 2*base_border, grid_size * base_y - 2*base_border, base_height ] );
        }
    }
}


for ( i = [ 0:1:( base_x - 1 ) ] ) {
    for ( j = [ 0:1:( base_y - 1 ) ] ) {
        difference() {
            draw_positive_base( i, j );
            draw_negative_base( i, j );
        }
        
        draw_outside_border();
    }
}

