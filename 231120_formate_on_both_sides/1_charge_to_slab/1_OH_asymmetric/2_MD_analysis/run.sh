#!/bin/bash


#layer=25;
#type=tet;
#coverage=half;

for layer in 9 17 25 33 41 49; do	
	for type in tet int; do
		for coverage in half full; do
			echo $layer $type $coverage
		done
	done
done

#mpirun -np 8 lmp_mpi -in nvt_mc.lmp -var layer $layer -var type $type -var coverage $coverage
