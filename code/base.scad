$fn = 32;

// The primary grid size
grid_size = 36;

// Configurable options
include_screws = true;
include_magnets = true;
include_cutouts = true;
include_mounts = true;

base_x = 3;
base_y = 3;
base_height = 5.2;

interface_height = 2;
interface_size = grid_size/2;

base_border = 2;
base_excess_space = grid_size - interface_size - 3*base_border;

screw_clearance = 3.4;
screw_head = 5;

total_height = interface_height + base_height;
magnet_height = 2.2;
magnet_diameter = 6.1;

module draw_one_interface( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2;
    y_pos = y * grid_size + (grid_size - interface_size)/2; 
    
    translate( [ x_pos, y_pos, base_height ] ) {
        color( "white" ) cube( [ interface_size, interface_size, interface_height] );
    }
}

module draw_magnet( x, y ) {
    x_pos = x * grid_size + (grid_size - interface_size)/2 + interface_size/2;
    y_pos = y * grid_size + (grid_size - interface_size)/2 + interface_size/2; 
    
    translate( [ x_pos, y_pos, ( total_height - interface_height ) ] ) {
        color( "red" ) cylinder( h = interface_height, r = 10/2 );
    }
    
    if ( include_magnets ) {
        translate( [ x_pos, y_pos, ( total_height - interface_height - magnet_height ) ] ) {
            color( "black" ) cylinder( h = magnet_height, r = magnet_diameter/2 );
        }
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
        cube( [ base_excess_space, interface_size, base_height ] );
    }
    
    translate( [ x_pos + interface_size + base_border, y_pos, 0 ] ) {
        cube( [ base_excess_space, interface_size, base_height ] );
    }
    
    translate( [ x_pos, y_pos - base_excess_space - base_border, 0 ] ) {
        cube( [ interface_size, base_excess_space, base_height ] );
    }
    
    translate( [ x_pos, y_pos + interface_size + base_border, 0 ] ) {
        cube( [ interface_size, base_excess_space, base_height ] );
        
    }
}

module draw_outside_border() {
    difference() {
        color( "grey" ) cube( [ grid_size * base_x, grid_size * base_y, base_height ] );
        translate( [ base_border, base_border, 0 ] ) {
            cube( [ grid_size * base_x - 2*base_border, grid_size * base_y - 2*base_border, base_height ] );
        }
    }
}

module draw_main_base() {
    for ( i = [ 0:1:( base_x - 1 ) ] ) {
        for ( j = [ 0:1:( base_y - 1 ) ] ) {
            difference() {
                draw_positive_base( i, j );
                if ( include_cutouts ) {
                    draw_negative_base( i, j );
                }
                draw_magnet( i, j );
            }
        
            draw_outside_border();
        }
    }
}

module draw_screw_holes() {
    if ( base_x > 1 ) {
        for ( i = [ 0:1:( base_x - 2 ) ] ) {
            translate( [ grid_size + i*grid_size, 0, base_height/2 ] ) {
                rotate( [ 270, 0, 0 ] ) cylinder( h = 10, r = screw_clearance/2 );
            }
            
            translate( [ grid_size + i*grid_size, base_y*grid_size, base_height/2 ] ) {
                rotate( [ 90, 0, 0 ] ) cylinder( h = 10, r = screw_clearance/2 );
            }
        }
    }
    
    if ( base_y > 1 ) {
         for ( i = [ 0:1:( base_y - 2 ) ] ) {
            translate( [ 0, grid_size + i*grid_size, base_height/2 ] ) {
                rotate( [ 0, 90, 0 ] ) cylinder( h = 10, r = screw_clearance/2 );
            }
            
            translate( [ base_x*grid_size, grid_size + i*grid_size, base_height/2 ] ) {
                rotate( [ 0, 270, 0 ] ) cylinder( h = 10, r = screw_clearance/2 );
            }
        }   
    }
}

module draw_one_mount( x, y ) {
    translate( [ x, y, 0 ] ) {
        cylinder( h=base_height, r=screw_clearance/2 );
        
        translate( [ 0, 0, base_height - 2 ] ) {
            cylinder( h=2, r=screw_head/2 );
        }
    }
}

module draw_mount_holes() { 
    offset = ( grid_size - interface_size - base_border*4 ) / 4;

    draw_one_mount( base_border + offset, base_border + offset );
    draw_one_mount( base_border + offset, base_y*grid_size - base_border - offset );
    
    draw_one_mount( base_x*grid_size - base_border - offset, base_border + offset );
    draw_one_mount( base_x*grid_size - base_border - offset, base_y*grid_size - base_border - offset );
}

module remove_excess() {
   excess = grid_size - base_border*2 - interface_size;
   if ( base_x > 1 && base_y > 1 ) {
        for ( i = [ 0:1:( base_x - 2 ) ] ) {
            for ( j = [ 0:1:( base_y - 2 ) ] ) { 
                translate( [ grid_size + i*grid_size, grid_size + j*grid_size, 0] ) {
                    cylinder( h=total_height, r=(excess)/2 );
                    //cube( [d , d , total_height+3 ], true );
                }
            }
         }
   }
}
           

difference() {
    draw_main_base();
    draw_screw_holes();
    
    if ( include_mounts ) {
        draw_mount_holes();
    }
    
    remove_excess();
}

