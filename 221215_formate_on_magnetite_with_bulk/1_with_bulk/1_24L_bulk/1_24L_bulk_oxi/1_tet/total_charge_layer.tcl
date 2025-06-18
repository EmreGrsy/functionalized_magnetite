# Symmetrical 001 layers: 17, 21, 25, 29, 33, 37, 41

package require topotools
package require pbctools

set nlayer 52

topo readlammpsdata 001-dbt_3x3_29L_fa_tet_full_11_14K.data

#set log [open "${nlayer}L_bulk_charge.data" w]

# Number of layers
set noctl [expr {($nlayer +1)/2}]
set ntetl [expr {($nlayer +1)/2-1}]

# Topmost zmin and zmax
set oct_topmost {16.2 17.3}
set tet_topmost {15.2 16.2}

# Distance between layers
set dist 2.1

# Initialize zlayer
set zlayer_oct {}
set zlayer_tet {} 

for {set x 0} {$x < $noctl} {incr x} {
	
	set zmin [expr {[lindex $oct_topmost 0] - $x*$dist}]
	set zmax [expr {[lindex $oct_topmost 1] - $x*$dist}]

	lappend zlayer_oct [list $zmin $zmax]
}	 

for {set x 0} {$x < $ntetl} {incr x} {

        set zmin [expr {[lindex $tet_topmost 0] - $x*$dist}]
        set zmax [expr {[lindex $tet_topmost 1] - $x*$dist}]

        lappend zlayer_tet [list $zmin $zmax]
}

# Count fe ions within each oct layer
for {set x 0} {$x < $noctl} {incr x} {

	set oct [atomselect top "type 6 7 8 and z>[lindex $zlayer_oct $x 0] and z<[lindex $zlayer_oct $x 1]"]
	set ch_oct [vecsum [$oct get charge]]
	puts [format "%d %.3f" [expr {2*($x +1)-1}] $ch_oct]

	if {$x< $ntetl} {
		set tet [atomselect top "type 6 7 8 and z>[lindex $zlayer_tet $x 0] and z<[lindex $zlayer_tet $x 1]"]
        	set ch_tet [vecsum [$tet get charge]]
		puts [format "%d %.3f" [expr {2*($x +1)}] $ch_tet [expr {$ch_oct+$ch_tet}]]
		puts [format "## tot_charge (oct+tet) : %.3f" [expr {$ch_oct+$ch_tet}]]
	}
	
	if {$x >= $ntetl} {
		puts [format "## tot_charge (tet) : %.3f" $ch_oct]
	}
}
