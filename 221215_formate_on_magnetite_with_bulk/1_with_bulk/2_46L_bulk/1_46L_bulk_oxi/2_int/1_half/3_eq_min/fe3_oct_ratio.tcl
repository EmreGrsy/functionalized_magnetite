# Symmetrical 001 layers: 17, 21, 25, 29, 33, 37, 41

package require topotools
package require pbctools

set nlayer 67
set type int_half_bulk

topo readlammpsdata 001-dbt_3x3_21L_fa_int_half_qeq_lqeq.data

set log [open "ratio.data" w]

# Number of oct layers
set noctl [expr {($nlayer +1)/2}]

# Topmost fe_oct ions zmin and zmax
set topmost {16.7 17.7}

# Distance between fe oct layers
set oct_oct 2.12

# Initialize zlayer
set zlayer {} 

for {set x 0} {$x < $noctl} {incr x} {
	
	set zmin [expr {[lindex $topmost 0] - $x*$oct_oct}]
	set zmax [expr {[lindex $topmost 1] - $x*$oct_oct}]

	lappend zlayer [list $zmin $zmax]
}	 

# Count fe ions within each oct layer
for {set x 0} {$x < $noctl} {incr x} {

	set oct_3 [atomselect top "type 7 and z>[lindex $zlayer $x 0] and z<[lindex $zlayer $x 1]"]
	set oct_2 [atomselect top "type 6 and z>[lindex $zlayer $x 0] and z<[lindex $zlayer $x 1]"]
	
	$oct_3 set type 5
        $oct_2 set type 4	

	puts $log "[$oct_3 num]"

}

close $log

# for rendering
set sel [atomselect top all]
set matrix [transaxis z 45]
$sel move $matrix

topo writelammpsdata ${nlayer}_${type}.data
