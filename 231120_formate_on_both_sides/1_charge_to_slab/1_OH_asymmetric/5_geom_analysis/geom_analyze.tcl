package require topotools
package require pbctools

set info_data [open "data_files.txt" r]

set log [open "geom_analyze_results1.csv" w]

puts $log "layer,coverage,binding_site,nFe2,nFe3,avg_thickness,max_thickness,avg_O_Feoct_dist,avg_zC_cooh_avg_zFe3O4_dist,avg_Fe_oct_bonding_avg_Fe_oct_all"

while {[gets ${info_data} line] != -1} {

	set layer [lindex [split $line "_"] 2]
	set layer [lindex [split $layer "L"] 0]
        set coverage [lindex [split $line "_"] 5]
        set binding_site [lindex [split $line "_"] 4]

	topo readlammpsdata $line
	
	
	# Also added magnetite oxygen, type 8, if only Fe is interested, delete it.
	set Fe [atomselect top "type 7 6 8"]
	
	set nFe3 [[atomselect top "type 7"] num]
	set nFe2 [[atomselect top "type 6"] num]
	
	######
	###### Average surface thickness and max surface thickness
	######
	
	# top oct layer Fe ions
	set top_oct [atomselect top "type 7 6 8 and z>[expr {[lindex [measure minmax $Fe] 1 2]-0.5}]"]
	
	# bottom oct layer Fe ions
	set bottom_oct [atomselect top "type 7 6 8 and z<[expr {[lindex [measure minmax $Fe] 0 2]+0.5}]"]
	
	# top oct layer
	set total_zcoord 0
	set avg_zcoord 0
	set nfe 0
	
	foreach fe_index [$top_oct get index] {
		incr nfe
		set fe [atomselect top "index $fe_index"]
		set zfe [$fe get z]
		set total_zcoord [expr {$total_zcoord + $zfe}]
		set avg_zcoord [expr {$total_zcoord /$nfe}]
	}
	
	set top_avg_zcoord $avg_zcoord
	
	# bottom oct layer
	set total_zcoord 0
	set avg_zcoord 0
	set nfe 0
	
	foreach fe_index [$bottom_oct get index] {
	        incr nfe
	        set fe [atomselect top "index $fe_index"]
	        set zfe [$fe get z]
	        set total_zcoord [expr {$total_zcoord + $zfe}]
	        set avg_zcoord [expr {$total_zcoord /$nfe}]
	}
	
	set bottom_avg_zcoord $avg_zcoord
	
	set avg_thickness [expr {$top_avg_zcoord-$bottom_avg_zcoord}]
	set max_thickness [expr {[lindex [measure minmax $Fe] 1 2]-[lindex [measure minmax $Fe] 0 2]}]
	
	######
	###### Average distance between O_cooh and Fe_oct bonding pairs
	######
	
	set O [atomselect top "type 3"]
	
	set total_bond_dist 0
	set avg_bond_dist 0
	set nbond 0
	
	foreach O_index [$O get index] {
		
		set Fe_bonding_index [[atomselect top "type 7 and pbwithin 2 of index $O_index"] get index]
		set bond_dist [measure bond [list $O_index $Fe_bonding_index]]
	
		# exclude the stretching bonds at PBs
		if {$bond_dist<2.5} {
			set nbond [expr {$nbond +1}]
			set total_bond_dist [expr {$total_bond_dist + $bond_dist}]
			set avg_bond_dist [expr {$total_bond_dist /$nbond}]
		}
	}
	
	set avg_O_Feoct_dist $avg_bond_dist
	
	######
	###### Height (z) between average C_cooh and average Fe3O4 surface ions
	######
	
	# top layer C_cooh
	set top_C [atomselect top "type 1 and z>[expr {[lindex [measure minmax $Fe] 1 2]-1}]"]
	
	# bottom layer C_cooh
	set bottom_C [atomselect top "type 1 and z<[expr {[lindex [measure minmax $Fe] 0 2]+1}]"]
	
	# top layer Fe3O4 ions
	set top_Fe3O4 [atomselect top "type 7 6 8 9 and z>[expr {[lindex [measure minmax $Fe] 1 2]-1}]"]
	
	# bottom layer Fe3O4 ions
	set bottom_Fe3O4 [atomselect top "type 7 6 8 9 and z<[expr {[lindex [measure minmax $Fe] 0 2]+1}]"]
	
	# top layer C_cooh
	set total_zcoord 0
	set avg_zcoord 0
	set nC 0
	
	foreach C_index [$top_C get index] {
	        incr nC
	        set C_cooh [atomselect top "index $C_index"]
	        set zC_cooh [$C_cooh get z]
	        set total_zcoord [expr {$total_zcoord + $zC_cooh}]
	        set avg_zcoord [expr {$total_zcoord /$nC}]
	}
	
	set avg_zC_cooh_top $avg_zcoord
	
	# bottom layer C_cooh
	set total_zcoord 0
	set avg_zcoord 0
	set nC 0
	
	foreach C_index [$bottom_C get index] {
	        incr nC
	        set C_cooh [atomselect top "index $C_index"]
	        set zC_cooh [$C_cooh get z]
	        set total_zcoord [expr {$total_zcoord + $zC_cooh}]
	        set avg_zcoord [expr {$total_zcoord /$nC}]
	}
	
	set avg_zC_cooh_bottom $avg_zcoord
	
	# top layer Fe3O4 ions
	set total_zcoord 0
	set avg_zcoord 0
	set nC 0
	
	foreach C_index [$top_Fe3O4 get index] {
	        incr nC
	        set C_cooh [atomselect top "index $C_index"]
	        set zC_cooh [$C_cooh get z]
	        set total_zcoord [expr {$total_zcoord + $zC_cooh}]
	        set avg_zcoord [expr {$total_zcoord /$nC}]
	}
	
	set avg_zFe3O4_top $avg_zcoord
	
	# bottom layer Fe3O4 ions
	set total_zcoord 0
	set avg_zcoord 0
	set nC 0
	
	foreach C_index [$bottom_Fe3O4 get index] {
	        incr nC
	        set C_cooh [atomselect top "index $C_index"]
	        set zC_cooh [$C_cooh get z]
	        set total_zcoord [expr {$total_zcoord + $zC_cooh}]
	        set avg_zcoord [expr {$total_zcoord /$nC}]
	}
	
	set avg_zFe3O4_bottom $avg_zcoord
	
	set avg_zC_cooh_zFe3O4_dist [expr {(($avg_zC_cooh_top-$avg_zFe3O4_top)+($avg_zFe3O4_bottom-$avg_zC_cooh_bottom)*0.50)}]
	
	######
	###### Distance between average bonding Fe and average Fe surface ions (top_oct)
	######
	
	set top_O [atomselect top "type 3 and z>[expr {[lindex [measure minmax $Fe] 1 2]-1}]"]
	set bottom_O [atomselect top "type 3 and z<[expr {[lindex [measure minmax $Fe] 0 2]+1}]"]
	
	# top layer bonding Fe
	set total_zcoord 0
	set avg_zcoord 0
	set nFe 0
	
	foreach O_index [$top_O get index] {
		incr nFe
	        set Fe_bonding_index [[atomselect top "type 7 and pbwithin 2 of index $O_index"] get index]
		set zFe_bonding [[atomselect top "index $Fe_bonding_index"] get z]
	        set total_zcoord [expr {$total_zcoord + $zFe_bonding}]
	        set avg_zcoord [expr {$total_zcoord /$nFe}]
	}
	
	set top_layer_Fe_bonding $avg_zcoord

	# puts "top layer Fe bonding: $top_layer_Fe_bonding"
	
	# bottom layer bonding Fe
	set total_zcoord 0
	set avg_zcoord 0
	set nFe 0
	
	foreach O_index [$bottom_O get index] {
	        incr nFe
	        set Fe_bonding_index [[atomselect top "type 7 and pbwithin 2 of index $O_index"] get index]
	        set zFe_bonding [[atomselect top "index $Fe_bonding_index"] get z]
	        set total_zcoord [expr {$total_zcoord + $zFe_bonding}]
	        set avg_zcoord [expr {$total_zcoord /$nFe}]
	}
	set bottom_layer_Fe_bonding $avg_zcoord

	# puts "bottom layer Fe bonding: $bottom_layer_Fe_bonding, bottom_avg: $bottom_avg_zcoord" 

	
	# top layer Fe surface ions -> $top_avg_zcoord
	# bottom layer Fe suface ions -> $bottom_avg_zcoord
	
	set avg_Fe_oct_bonding_Fe_oct_all [expr {(($top_layer_Fe_bonding-$top_avg_zcoord)+($bottom_avg_zcoord-$bottom_layer_Fe_bonding))*0.5}]
	
	# sanity check
	# puts "undulation: $avg_Fe_oct_bonding_Fe_oct_all, >0 means there is surface undulation, =0 means no undulation"
	
	puts $log "${layer},${coverage},${binding_site},${nFe2},${nFe3},${avg_thickness},${max_thickness},${avg_O_Feoct_dist},${avg_zC_cooh_zFe3O4_dist},${avg_Fe_oct_bonding_Fe_oct_all}"

}
exit
