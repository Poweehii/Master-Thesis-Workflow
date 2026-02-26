#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash scripts/run_strain_and_plot.sh [WAVEFORM_DIR] [OUTDIR]
#
# Examples:
#   bash scripts/run_strain_and_plot.sh data/example_input/waveforms
#   bash scripts/run_strain_and_plot.sh data/example_input/waveforms data/example_output

WAVEFORM_DIR="${1:-data/example_input/waveforms}"
OUTDIR="${2:-}"

RADIUS="${RADIUS:-r0050}"
L="${L:-2}"
M="${M:-2}"
TMAX="${TMAX:-300}"
# Optional:
# export TMIN=0
TMIN="${TMIN:-}"

# 1) Compute strain (creates/updates WAVEFORM_DIR/strain.h5) using waveforms.py defaults
python3 analysis/ffi/waveforms.py "$WAVEFORM_DIR" --verbose

# 2) Choose which strain.h5 to plot from:
STRAIN_H5="$WAVEFORM_DIR/strain.h5"

# Optionally copy to OUTDIR (if provided)
if [[ -n "$OUTDIR" ]]; then
  mkdir -p "$OUTDIR"
  cp -f "$STRAIN_H5" "$OUTDIR/strain.h5"
  STRAIN_H5="$OUTDIR/strain.h5"
fi

# 3) Plot
if [[ -n "$TMIN" ]]; then
  python3 analysis/ffi/plot_strain.py "$STRAIN_H5" --radius "$RADIUS" -l "$L" -m "$M" --tmin "$TMIN" --tmax "$TMAX"
else
  python3 analysis/ffi/plot_strain.py "$STRAIN_H5" --radius "$RADIUS" -l "$L" -m "$M" --tmax "$TMAX"
fi
