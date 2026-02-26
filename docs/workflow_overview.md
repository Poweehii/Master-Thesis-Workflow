# Workflow overview

This repository captures the practical workflow I use in my Master's thesis work to go from numerical-relativity simulation output to a plotted gravitational-wave strain signal.

## Inputs

AthenaK waveform extraction produces text files for the Weyl scalar \(\Psi_4\) at multiple extraction radii:

- `rpsi4_real_XXXX.txt`
- `rpsi4_imag_XXXX.txt`

where `XXXX` encodes the extraction radius (e.g. `0010`, `0025`, `0050`).

The repository includes a small real example dataset in:

- `data/example_input/waveforms/`

## Pipeline (Psi4 → strain)

1. **Read Psi4 data**  
   `analysis/ffi/waveforms.py` reads the real/imaginary files for each radius and constructs complex \(\Psi_4(t)\) for each \((\ell,m)\) mode.

2. **Resample to uniform time grid**  
   The input time samples are interpolated onto a uniform grid to enable FFT-based processing.

3. **Window and fixed-frequency integration (FFI)**  
   A smooth window is applied in the time domain, and the strain \(h(t)\) is obtained by performing fixed-frequency integration (FFI) of \(\Psi_4\) in the frequency domain. The FFI method regularizes the low-frequency behavior to control unphysical drifts that occur in naive double time integration.

4. **Write strain output**  
   The result is written to an HDF5 file `strain.h5` with groups named by radius, e.g. `r0050/`, and datasets:
   - `t`
   - `h[l,m]`

## Plotting

`analysis/ffi/plot_strain.py` reads `strain.h5` and plots a chosen radius and mode (default \((2,2)\)). It can also save a figure via `--save`.

## Recommended entrypoint

From the repository root, the intended way to reproduce the demo is:

    bash scripts/run_strain_and_plot.sh data/example_input/waveforms data/example_output

This computes strain from the included example data and produces the plot shown in the main README.

## HPC (Mahti)

Slurm job scripts used to run AthenaK on the Mahti supercomputer are stored in `hpc/mahti/` (kept as used during the thesis work).
