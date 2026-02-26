#!/usr/bin/env python3
import argparse
import os
import numpy as np
import h5py
import matplotlib.pyplot as plt

def main():
    p = argparse.ArgumentParser(description="Plot strain from AthenaK strain.h5")
    p.add_argument("strain_h5", help="Path to strain.h5")
    p.add_argument("--radius", default="r0050", help="Radius group (e.g. r0010, r0025, r0050)")
    p.add_argument("-l", type=int, default=2, help="Spherical harmonic l")
    p.add_argument("-m", type=int, default=2, help="Spherical harmonic m")
    p.add_argument("--tmin", type=float, default=None, help="Minimum time to plot")
    p.add_argument("--tmax", type=float, default=None, help="Maximum time to plot")
    p.add_argument("--save", default=None, help="Save figure to this path (e.g. docs/figures/strain_r0050_l2m2.png)")
    args = p.parse_args()

    fn = os.path.expanduser(args.strain_h5)
    radius = args.radius
    l, m = args.l, args.m

    with h5py.File(fn, "r") as f:
        t = np.array(f[f"{radius}/t"][()])
        h = f[f"{radius}/h[{l},{m}]"][()]
        # handle possible (N,2) [Re,Im] storage
        if (not np.iscomplexobj(h)) and getattr(h, "ndim", 0) == 2 and h.shape[1] == 2:
            h = h[:, 0] + 1j * h[:, 1]

    mask = np.ones_like(t, dtype=bool)
    if args.tmin is not None:
        mask &= (t >= args.tmin)
    if args.tmax is not None:
        mask &= (t <= args.tmax)

    t = t[mask]
    h = h[mask]

    plt.figure()
    plt.plot(t, h.real, label="Re(h)")
    plt.plot(t, h.imag, label="Im(h)")
    plt.xlabel("t [M]")
    plt.ylabel("h")
    plt.title(f"{os.path.basename(fn)}  {radius}  (l,m)=({l},{m})")
    plt.legend()
    if args.save:
        out = os.path.expanduser(args.save)
        os.makedirs(os.path.dirname(out) or '.', exist_ok=True)
        plt.savefig(out, dpi=150)
        print(f"Saved figure to {out}")
    else:
        plt.show()

if __name__ == "__main__":
    main()

