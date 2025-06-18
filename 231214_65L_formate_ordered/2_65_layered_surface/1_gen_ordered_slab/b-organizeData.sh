#!/bin/bash
# This script corrects mixed parameters caused VMD::TopoTools:: module.
# This script assumes that the input file includes; atoms, bonds, angles, dihedrals and impropers. 
# If this is not the case, delete the unnecessary entries.

# Input file.

infile="$PWD/a-001-dbt_1x1_65L_ordered.data"


# Structural information.

sed '/ Atoms # full/Q' $infile>.tmp_initial


# Parse the number of atoms, bonded terms and increment them by 1.
# Number of atoms and bonded terms are incremented to include "\n" after each section such as "Atoms # full". 
# Number of types are incremented to include "#", this is required for coefficient array indexing. 

atom_number=$(($(grep " atoms" $infile | awk '{print $1}')+1)) 
bond_number=$(($(grep " bonds" $infile | awk '{print $1}')+1))
angle_number=$(($(grep " angles" $infile | awk '{print $1}')+1))
dihedral_number=$(($(grep " dihedrals" $infile | awk '{print $1}')+1))
improper_number=$(($(grep " impropers" $infile | awk '{print $1}')+1))

atom_type_number=$(($(grep " atom types" $infile | awk '{print $1}')+1))
bond_type_number=$(($(grep " bond types" $infile | awk '{print $1}')+1))
angle_type_number=$(($(grep " angle types" $infile | awk '{print $1}')+1))
dihedral_type_number=$(($(grep " dihedral types" $infile | awk '{print $1}')+1))
improper_type_number=$(($(grep " improper types" $infile | awk '{print $1}')+1))


# Initialize coefficient arrays (coefficient arrays start with 0).

pair_coeffs=($(sed -n "/# Pair Coeffs/,+${atom_type_number}p" $infile | sed -e '1,2d' | awk '{print $3}'))
bond_coeffs=($(sed -n "/# Bond Coeffs/,+${bond_type_number}p" $infile | sed -e '1,2d' | awk '{print $3}'))
angle_coeffs=($(sed -n "/# Angle Coeffs/,+${angle_type_number}p" $infile | sed -e '1,2d' | awk '{print $3}'))
dihedral_coeffs=($(sed -n "/# Dihedral Coeffs/,+${dihedral_type_number}p" $infile | sed -e '1,2d' | awk '{print $3}'))
improper_coeffs=($(sed -n "/# Improper Coeffs/,+${improper_type_number}p" $infile | sed -e '1,2d' | awk '{print $3}'))


# Change TopoTools assigned parameters back to original parameters by using Coefficient array mapping.

grep -A $atom_number " Atoms # full" $infile | sed -e '1,2d' | 
awk -v arr1="${pair_coeffs[*]}" '{split(arr1,arr2);for(a in arr2){if($3==a){$3=arr2[a]; print}}}' | awk '!a[$1]++'>.tmp_atom

grep -A $bond_number " Bonds" $infile | sed -e '1,2d' |   
awk -v arr1="${bond_coeffs[*]}" '{split(arr1,arr2);for(a in arr2){if(a==$2){$2=arr2[a]; print $0}}}' | awk '!a[$1]++'>.tmp_bond 

grep -A $angle_number " Angles" $infile | sed -e '1,2d' |
awk -v arr1="${angle_coeffs[*]}" '{split(arr1,arr2);for(a in arr2){if(a==$2){$2=arr2[a]; print $0}}}' | awk '!a[$1]++'>.tmp_angle

grep -A $dihedral_number " Dihedrals" $infile | sed -e '1,2d' |
awk -v arr1="${dihedral_coeffs[*]}" '{split(arr1,arr2);for(a in arr2){if(a==$2){$2=arr2[a]; print $0}}}' | awk '!a[$1]++'>.tmp_dihedral

grep -A $improper_number " Impropers" $infile | sed -e '1,2d' |
awk -v arr1="${improper_coeffs[*]}" '{split(arr1,arr2);for(a in arr2){if(a==$2){$2=arr2[a]; print $0}}}' | awk '!a[$1]++'>.tmp_improper


# Combine temp files.

cat .tmp_initial>>.tmp_data

echo " Atoms # full">>.tmp_data
echo -en '\n'>>.tmp_data
cat .tmp_atom>>.tmp_data
echo -en '\n'>>.tmp_data

echo " Bonds">>.tmp_data
echo -en '\n'>>.tmp_data
cat .tmp_bond>>.tmp_data
echo -en '\n'>>.tmp_data

echo " Angles">>.tmp_data
echo -en '\n'>>.tmp_data
cat .tmp_angle>>.tmp_data
echo -en '\n'>>.tmp_data

echo " Dihedrals">>.tmp_data
echo -en '\n'>>.tmp_data
cat .tmp_dihedral>>.tmp_data
echo -en '\n'>>.tmp_data

echo " Impropers">>.tmp_data
echo -en '\n'>>.tmp_data
cat .tmp_improper>>.tmp_data
echo -en '\n'>>.tmp_data


# Write the final structure.

cat .tmp_data>b-001-dbt_1x1_65L_ordered.data


# Remove temp file.

rm .tmp*
