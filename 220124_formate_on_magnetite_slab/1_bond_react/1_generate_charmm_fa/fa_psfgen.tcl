package require psfgen
  
topology top_all36_cgenff.rtf

pdbalias residue FOR FORH

segment A {
pdb forh_no_h.pdb
}

coordpdb forh_no_h.pdb A

guesscoord

writepdb formic-acid.pdb

writepsf charmm formic-acid.psf
