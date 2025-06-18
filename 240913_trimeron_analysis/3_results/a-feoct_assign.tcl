package require topotools
package require pbctools

topo readlammpsdata 001-dbt_3x3_33L_fa_tet_half_qeq_min.data

topo guessatom lammps data

## Define oct-coordinated Fe ions
# Number of oct layers
set noctl 17

# Topmost fe_oct ions zmin and zmax
set topmost {16.5 17.7}

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
	
	$oct_3 set type 11
	$oct_2 set type 12
}

topo writelammpsdata a_feoct_assigned.data
