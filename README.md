# Functionalized Magnetite Surfaces: Oxidation State Swaps

[![DOI](https://img.shields.io/badge/DOI-10.1021/acs.jpclett.3c01290-blue)](https://pubs.acs.org/doi/full/10.1021/acs.jpclett.5c00679)  

This repository contains scripts and data used in the nanoparticle section of the research paper [**Atomistic Modeling of Functionalized Magnetite Surfaces with Oxidation States**](https://pubs.acs.org/doi/full/10.1021/acs.jpclett.5c00679). 

[<img src="TOC2.png" alt="Table of Contents Figure" width="30%">](https://pubs.acs.org/doi/full/10.1021/acs.jpclett.3c01290) 

## Overview

This repository contains production and analysis scripts used in the investigation of functionalized magnetite surfaces, as described in the research paper *Oxidation-State Dynamics and Emerging Patterns in Magnetite*. It includes workflows for modeling surface adsorption of formic acid and formate ions, studying binding site preferences, exploring different surface terminations with hydroxyl groups, and analyzing the structural and electronic effects of surface functionalization. The repository also contains scripts for reaction pathway sampling using bond_react, radial distribution function (RDF) analysis, and trimeron investigations at the surface.

## Repository Structure
```
220124_formate_on_magnetite_slab/
├── 1_bond_react/                       # Functionalization through LAMMPS BOND_REACT
├── 1_generate_charmm_fa/               # CHARMM FF
├── 2_generate_charmm_formate/          # CHARMM FF
├── 3_fa_tet_on_001/                    # Tet binded formic acid on 001 surface
├── 1_generate_fa_on_001/               # Formic acid generation on 001 surface
│   ├── 2_bond_react_tet_run/           # LAMMPS BOND_REACT for tet binding site
├── 4_fa_int_on_001/                    # Int binded formic acid on 001 surface
│   ├── 1_generate_fa_on_001/           
│   ├── 2_bond_react_int_run/           # BOND_REACT run

221215_formate_on_magnetite_with_bulk/  
├── 1_with_bulk/                        # Formate on magnetite with bulk layers (not published)
│   ├── 2_results/                      # Analysis results 

231120_formate_on_both_sides/           
├── 1_charge_to_slab/                    # Excess charge (from protonation) to the slab
├── 1_OH_asymmetric/                     # Asymmetric OH
│   ├── 1_gen/                           
│   ├── 2_MD_analysis/                   # Analysis scripts
│   ├── 3_doct/                          # Distance between octahedral layers
│   ├── 4_NVT_MC/                        # Hybdrid molecular dynamics/Monte Carlo simulations
│   ├── 5_geom_analysis/                 # Geometric analyssis
│   ├── 6_layered_structures/            # Oxidation state layered structure analyis
│   ├── 7_results/                       

├── 2_OH_symmetric/                      # Symmetric OH
│   ├── 1_gen/                            
│   ├── 2_results/                       

├── 2_charge_to_extra_hydroxide/         # Extra hydroxide charge analysis  (not published)
│   ├── 3_gen_slab/                      # Slab generation scripts (not published)

231214_65L_formate_ordered/              
├── 1_analyze_surface_slab_41L/          # Surface on 41-layer bulk (not published)
│   ├── 2_65_layered_surface/            # Surface on 65-layer bulk (not published)

240913_trimeron_analysis/
├── 1_RDF/                               # RDF analysis
├── 2_entropy/                           # Entropy calculations
│   ├── 3_results/                       # Entropy results

241008_trimeron_analysis/                # Additional trimeron analysis (not published)
```
