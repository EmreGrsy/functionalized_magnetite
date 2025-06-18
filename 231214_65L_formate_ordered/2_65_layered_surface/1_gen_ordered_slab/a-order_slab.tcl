# Symmetrical 001 layers: 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65

package require topotools
package require pbctools

set nlayer 65

set toct3layer 5
set boct3layer [expr {$nlayer-3}] 

topo readlammpsdata 001-dbt_1x1_${nlayer}L_init.data

# Number of layers
set noctl [expr {($nlayer +1)/2}]
set ntetl [expr {($nlayer +1)/2-1}]

# Topmost zmin and zmax
set oct_topmost {76.2 76.9}
set tet_topmost {75.2 75.9}

# Distance between layers
set dist 2.12

# Initialize zlayer
set zlayer_oct {}
set zlayer_tet {} 

# Define oct-layer
for {set x 0} {$x < $noctl} {incr x} {
	set zmin [expr {[lindex $oct_topmost 0] - $x*$dist}]
	set zmax [expr {[lindex $oct_topmost 1] - $x*$dist}]
	lappend zlayer_oct [list $zmin $zmax]
}	 

# Define tet-layer
for {set x 0} {$x < $ntetl} {incr x} {
        set zmin [expr {[lindex $tet_topmost 0] - $x*$dist}]
        set zmax [expr {[lindex $tet_topmost 1] - $x*$dist}]
        lappend zlayer_tet [list $zmin $zmax]
}

# Dummy indice for assigining oct3+ and oct2+
set dcounter 0

# Count fe ions within each oct layer
for {set x 0} {$x < $noctl} {incr x} {
	set loct [expr {2*($x+1)-1}]
	set oct [atomselect top "type 6 7 and z>[lindex $zlayer_oct $x 0] and z<[lindex $zlayer_oct $x 1]"]
	set oct_3 [atomselect top "type 7 and z>[lindex $zlayer_oct $x 0] and z<[lindex $zlayer_oct $x 1]"]
        set oct_2 [atomselect top "type 6 and z>[lindex $zlayer_oct $x 0] and z<[lindex $zlayer_oct $x 1]"]

	# First 3 oct-layers are 3+
	if {$loct<=$toct3layer} {$oct set charge 1.575; $oct set type 7; set otype "3+"}	

	# Oxidation state-layering 2+/3+
	if {$loct>$toct3layer && $loct<$boct3layer && $dcounter==0} {$oct set charge 1.050; $oct set type 6; set dcounter 1; set otype "2+"
	   } elseif {$loct>$toct3layer && $loct<$boct3layer && $dcounter==1} {$oct set charge 1.575; $oct set type 7; set dcounter 0; set otype "3+"}

	# Last 3 oct-layers are 3+
        if {$loct>=$boct3layer} {$oct set charge 1.575; $oct set type 7; set otype "3+"}

	set ch_oct [vecsum [$oct get charge]]
	puts [format "%d oct %d %.3f %s" $loct [$oct num] $ch_oct $otype]

	if {$x< $ntetl} {
		set tet [atomselect top "type 6 7 and z>[lindex $zlayer_tet $x 0] and z<[lindex $zlayer_tet $x 1]"]
		
		# All tet layers are 3+ 
		$tet set charge 1.575
		set ch_tet [vecsum [$tet get charge]]
		puts [format "%d tet %d %.3f" [expr {2*($x +1)}] [$tet num] $ch_tet]	
	}
}

puts "total charge : [vecsum [[atomselect top all] get charge]]"
topo writelammpsdata a-001-dbt_1x1_${nlayer}L_ordered.data
