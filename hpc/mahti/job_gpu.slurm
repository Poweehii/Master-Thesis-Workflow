#!/bin/bash
#SBATCH --account=project_2005751
#SBATCH --partition=gpumedium
#SBATCH --job-name=mahti-z4cTP-gputest-1gpu
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err
#SBATCH --time=15:00:00

#SBATCH --ntasks=4
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:a100:4
#SBATCH --no-requeue
#SBATCH --verbose
## Some startup output that may be useful
echo Starting serial job
echo $SLURM_JOB_ID
hostname
date

## ---- module environment (matches your build) ----
module --force purge
module load gcc/9.4.0
module load cuda/11.5.0
module load gsl/2.7

## Pure MPI run: avoid oversubscribing because Kokkos has OpenMP enabled
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export UCX_TLS=self,sm,cuda_copy
export UCX_MEMTYPE_CACHE=n
export OMPI_MCA_pml=ucx

## Launch run
RUNDIR="/scratch/project_2005751/piaelibl/runs/mahti_gpu_test_01"
INPUT="${RUNDIR}/z4c_twopuncture.athinput"
OUTDIR="${RUNDIR}/out"
echo "Starting command"
srun --export=ALL --cpu-bind=cores bash -lc "export CUDA_VISIBLE_DEVICES=\$SLURM_LOCALID; exec ./src/athena -i '$INPUT' -d '$OUTDIR'" 2>&1 | tee -a "${RUNDIR}/run.log"

## We're done!
echo Done.
date


