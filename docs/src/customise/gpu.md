# Graphics cards

`modules/hardware/gpu.nix` provides `mercury.hardware.gpu.{intel,amd,nvidia}`.

## Desktop: Intel Arc B570

- Driver: the kernel's `xe` driver, which needs a recent kernel — the desktop
  uses `boot.kernelPackages = pkgs.linuxPackages_latest;`.
- `intel.enable` adds VA-API (`intel-media-driver`), Quick Sync
  (`vpl-gpu-rt`) and OpenCL (`intel-compute-runtime`).
- Check: `nix-shell -p libva-utils --run vainfo` should list the iHD driver.
- If the latest kernel ever misbehaves, pin a specific series:
  `pkgs.linuxPackages_6_18` (pick one listed on search.nixos.org).

## Laptop: Intel iGPU + RTX 3050 Ti (PRIME offload)

- The Intel GPU drives the display; the NVIDIA GPU sleeps until asked.
- Run something on NVIDIA: `nvidia-offload <program>`.
  Steam game: Properties → Launch options → `nvidia-offload %command%`.
- Bus IDs must match the hardware (`lspci | grep -E "VGA|3D"`).
- `open = true` uses NVIDIA's open kernel modules (fine for RTX 30 series).
- Check: `nvidia-smi` shows the card; `nvidia-offload glxinfo | grep renderer`.

## Switching to sync mode (NVIDIA always on)

Better performance on an external monitor wired to the NVIDIA GPU, worse
battery. In the laptop host:

```nix
hardware.nvidia.prime = {
  offload.enable = lib.mkForce false;
  offload.enableOffloadCmd = lib.mkForce false;
  sync.enable = true;
};
hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
```
