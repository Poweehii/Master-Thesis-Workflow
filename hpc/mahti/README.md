# Mahti Slurm job scripts

This folder contains the Slurm job scripts I use to run AthenaK on the CSC Mahti supercomputer.

## Files

- `job_cpu.slurm`  
  CPU run on the `medium` partition (multi-node, MPI + OpenMP via `OMP_NUM_THREADS`).

- `job_gpu.slurm`  
  GPU run on the `gpumedium` partition (MPI + OpenMP, UCX settings for GPU-aware communication).

## How to use

1. Copy the script you want to a run directory on Mahti.
2. Adjust the paths near the bottom of the script (variables `RUNDIR`, `INPUT`, `OUTDIR`) to match your run directory and input file.
3. Submit with:
   - `sbatch job_cpu.slurm`
   - `sbatch job_gpu.slurm`

## Notes

- These scripts are included exactly as used during my thesis work. Some values (account, partitions, module versions, run paths) are specific to my Mahti environment and allocation.
