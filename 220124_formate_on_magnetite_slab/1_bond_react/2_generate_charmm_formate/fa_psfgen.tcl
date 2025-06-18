package require psfgen
  
topology top_all36_cgenff.rtf

pdbalias residue FOR FORA

segment A {
pdb forh_no_h.pdb
}

coordpdb forh_no_h.pdb A

guesscoord

writepdb formate.pdb

writepsf charmm formate.psf
