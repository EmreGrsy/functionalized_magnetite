#!/bin/bash

mkdir -p extracted

# Loop through all slurm files
for file in slurm*; do

	# Extract the coverage and temperature
	info=$(grep -B 1 "LAMMPS" "$file" | grep -v "LAMMPS" | awk -F "[‘’]" '{print $2}' | awk -F'/' '{print $NF}' | \
		awk -F '_' '{print $2, $3}')

	read coverage temp <<< "$info"

	# Read the slurm file, extract the results and with the relavent coverage and temperature
	sed -n '/   Step        v_ftemp/,/Loop time/p' "$file" | sed '1d; $d' | \
		awk -v p1="$coverage" -v p2="$temp" '{$1=$1; print p1 "," p2 "," $0}' OFS="," > extracted/"${coverage}_${temp}.csv"

	echo "Results to ${coverage}_${temp}.csv file: $file"
done
