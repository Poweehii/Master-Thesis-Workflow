#!/bin/bash
#SBATCH --account=project_2005751
#SBATCH --cpus-per-task=8
#SBATCH --no-requeue
#SBATCH --verbose

#SBATCH --partition=medium
##SBATCH --partition=small
##SBATCH --partition=test
#SBATCH --job-name=mahti-z4cTP-medium
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --nodes=10 --tasks-per-node=4
##SBATCH --ntasks=64
#SBATCH --time=36:00:00

## Some startup output that may be useful
echo Starting serial job
echo $SLURM_JOB_ID
hostname
date

## ---- module environment (matches your build) ----
module --force purge
module load gcc/13.1.0
module load cmake/3.28.6
module load openmpi/4.1.5
module load gsl/2.7.1
export GSL_PREFIX="$(gsl-config --prefix)"
export LD_LIBRARY_PATH="$GSL_PREFIX/lib:$LD_LIBRARY_PATH"
## Pure MPI run: avoid oversubscribing because Kokkos has OpenMP enabled
export OMP_NUM_THREADS=8
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

## Launch run
RUNDIR="/scratch/project_2005751/piaelibl/runs/mahti_test_02"
INPUT="${RUNDIR}/z4c_twopuncture.athinput"
OUTDIR="${RUNDIR}/out"
echo "Starting command"
srun --export=ALL --cpu-bind=cores ./src/athena -i "$INPUT" -d "$OUTDIR" 2>&1 | tee -a "${RUNDIR}/run.log"

## We're done!
echo Done.
date


