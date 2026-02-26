# FFI strain workflow (AthenaK waveforms)

This folder contains the post-processing scripts used in my thesis workflow to compute the gravitational-wave strain \(h(t)\) from AthenaK-extracted Weyl scalar data \(\Psi_4\) using fixed-frequency integration (FFI), and to visualize the result.

## Recommended entrypoint

The intended way to run the full workflow is via the repository script:

    bash scripts/run_strain_and_plot.sh data/example_input/waveforms data/example_output

This runs the strain computation and then produces the strain plot (by default the \((2,2)\) mode at `r0050`). The generated `strain.h5` is copied to `data/example_output/` so the example input data remains unchanged.

## What each script does

- `waveforms.py`  
  Reads `rpsi4_real_*.txt` and `rpsi4_imag_*.txt` (multiple extraction radii).  
  Constructs complex \(\Psi_4(t)\) for each \((\ell,m)\) mode, applies a smooth time-domain window, and performs FFI to obtain \(h(t)\).  
  Writes the result to `strain.h5` with groups like `r0050/` and datasets `t` and `h[l,m]`.

- `plot_strain.py`  
  Plots a chosen `h[l,m]` mode from `strain.h5` for a selected extraction radius (e.g. `r0050`).  
  Can show interactively or save a PNG via `--save`.
