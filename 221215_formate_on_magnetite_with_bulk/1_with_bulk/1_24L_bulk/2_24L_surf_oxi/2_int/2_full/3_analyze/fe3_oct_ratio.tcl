# In 3x3x3 001-DBT surfaces, each oct layer has 36 fe_oct ions.

package require topotools
package require pbctools

set fe3oct_ratio {}

set nlayer 52
set over_head 001-dbt_3x3_29L_fa_tet_full

# Number of oct layers
set noctl [expr {($nlayer +1)/2}]

# Topmost fe_oct ions zmin and zmax
set topmost {16.2 17.3}

# Distance between fe oct layers
set oct_oct 2.1

set info_data [open "info.data" r]

set log [open "${nlayer}L_full_info.data" w]

while {[gets ${info_data} line] != -1} {
	
#	set step [lindex [split $line "_*K.data"] 0]
#	set mc_temp [lindex [split $line "_*K.data"] 1]
	
	topo readlammpsdata 001-dbt_3x3_21L_fa_int_full_qeq.data

	set dummy_ratio {}
	
	# Zmin and zmax of each fe_oct layer
	set zlayer {}

	lappend dummy_ratio "qeq"

	# Sanity check
	#puts "$step $mc_temp"

	for {set x 0} {$x < $noctl} {incr x} {

        	set zmin [expr {[lindex $topmost 0] - $x*$oct_oct}]
        	set zmax [expr {[lindex $topmost 1] - $x*$oct_oct}]

        	lappend zlayer [list $zmin $zmax]
	}

	# Count fe_oct ion of each oct layer
	for {set x 0} {$x < $noctl} {incr x} {

        	set oct3 [atomselect top "type 7 and z>[lindex $zlayer $x 0] and z<[lindex $zlayer $x 1]"]
        	set oct2 [atomselect top "type 6 and z>[lindex $zlayer $x 0] and z<[lindex $zlayer $x 1]"]

        	set toct [expr [$oct3 num] + [$oct2 num]]

        	if {$toct!=36} {
                	puts "ERROR: missing fe_oct ion at [expr {$x+1}] layer"
        	}

		# Sanity check
        	#puts "[expr {$x+1}] [$oct3 num]"

        	lappend dummy_ratio [$oct3 num]

		# Cleanup
		$oct3 delete
		$oct2 delete
	}

	lappend fe3oct_ratio $dummy_ratio
	#puts "$fe3oct_ratio"
}

foreach temp_ratio $fe3oct_ratio {
	puts $log "$temp_ratio"
}

exit
