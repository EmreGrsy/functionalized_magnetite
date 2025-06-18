# Symmetrical 001 layers: 17, 21, 25, 29, 33, 37, 41

package require topotools
package require pbctools

set nlayer 41

topo readlammpsdata 001-dbt_3x3_${nlayer}L_swp_old.data

set log [open "${nlayer}L_info_2.data" w]

# Number of oct layers
set noctl [expr {($nlayer +1)/2}]

# Topmost fe_oct ions zmin and zmax
set topmost {16.2 17.3}

# Distance between fe oct layers
set oct_oct 2.1

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
	
	puts $log "[expr {$x +1}] [$oct_3 num] [$oct_2 num] [expr {[$oct_3 num]+[$oct_2 num]}]"

}
