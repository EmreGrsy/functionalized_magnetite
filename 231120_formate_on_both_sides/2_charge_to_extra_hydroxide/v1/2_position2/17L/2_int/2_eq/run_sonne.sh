#!/bin/bash
#SBATCH -p 40c
#SBATCH -J 17L_int_pos2
#SBATCH --cpus-per-task 1
#SBATCH --ntasks 20
#SBATCH --time 504:00:00
#SBATCH --nodes 1

# Module initialisieren und Modul fuer Gromacs laden
source /etc/profile
module unload rocks-openmpi
module load openmpi
module load gcc

# Lokales Arbeitsverzeichnis anlegen
# grp und id ist an die Unix-Gruppe und Nutzername anzupassen !
#MYWORKDIR=/tmp/$SLURM_JOBID
MYWORKDIR=$PWD/${SLURM_JOBID}
mkdir $MYWORKDIR
JOBDIR=$PWD

# Kopiere die Eingabedatei aus dem Homeverzeichnis in das Arbeitsverzeichnis
cp $JOBDIR/* $MYWORKDIR

# Ins Arbeitsverzeichnis wechseln und Rechnung starten
cd $MYWORKDIR
mpirun -np 20 /home/kveg/bin/lmp_mpi_4.0.2 -in equilibrate_formate.lmp

# Alle Ausgabedaten zurueck ins Homeverzeichnis sichern.
#cp * $JOBDIR/

# Aufraeumen.
#rm -rf $MYWORKDIR

exit
