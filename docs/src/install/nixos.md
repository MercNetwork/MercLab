# Installing the desktop and laptop

The same steps for `desktop` and `laptop`; machine-specific notes are at the
end. Total time: 20–60 minutes, mostly downloading. New to Disko? Read
[Disko in plain English](disko.md) first — it's two minutes.

Already installed NixOS the normal way? Use
[From an existing NixOS install](existing-nixos.md) instead.

## 1. Boot the installer and get online

Boot the USB stick. In the live session, connect to Wi-Fi from the top-bar menu
(or run `nmtui`). Open a terminal.

## 2. Clone the repo

```bash
nix-shell -p git
git clone https://github.com/MercNetwork/MercLab.git ~/MercLab
cd ~/MercLab
```

(Username: your GitHub username. Password: the token from
[Before you install](prepare.md).)

## 3. Generate this machine's hardware file

The repo ships a sensible starting `hardware-configuration.nix`, but the real
one is more accurate. Replace it (pick the right host):

```bash
sudo nixos-generate-config --no-filesystems --show-hardware-config \
  > hosts/desktop/hardware-configuration.nix
```

`--no-filesystems` matters: Disko owns the disks, and duplicate filesystem
entries break the build.

## 4. Check the target disk

```bash
lsblk -o NAME,SIZE,MODEL
```

If the disk you want is not `nvme0n1`, edit `device = lib.mkDefault "/dev/…"` in
`hosts/<name>/disko.nix`. Prefer a stable name from `ls -l /dev/disk/by-id/`.

## 5. Laptop only: GPU bus IDs

```bash
lspci | grep -E "VGA|3D"
```

Convert each address `BB:DD.F` (hex) to `PCI:B:D:F` (decimal) and check they
match `intelBusId` / `nvidiaBusId` in `hosts/laptop/configuration.nix`.
Typical: `00:02.0 → PCI:0:2:0` and `01:00.0 → PCI:1:0:0`.

## 6. Run the installer

```bash
git add -A     # flakes only see files git knows about
sudo nix --extra-experimental-features "nix-command flakes" run .#install -- desktop
```

What happens:

1. You type the host name to confirm, then Disko asks again before wiping.
2. You choose the **disk-encryption passphrase** (asked at every boot).
3. Host keys are created and the host's **age public key** is printed —
   copy it somewhere; you need it for [secrets](../customise/secrets.md).
4. NixOS is built and installed.
5. The repo is copied to `/home/mercury/MercLab`, where the live dotfile links
   expect it.

## 7. Reboot

```bash
reboot
```

Remove the USB stick. Enter the disk passphrase, then log in at SDDM as
`mercury` / `chloe` with the **Hyprland (uwsm)** session. Continue with the
[First boot checklist](first-boot.md).

## Machine notes

### desktop — Ryzen 5 5600X + Intel Arc B570

- **BIOS:** UEFI on, Secure Boot off, **Resizable BAR** and **Above 4G
  Decoding** on (Arc cards lose a lot of performance without ReBAR).
- Plug the monitor into the **Arc card**, not the motherboard (the 5600X has
  no integrated graphics).
- Already configured: latest kernel for the `xe` driver, Intel media/compute
  drivers, AMD microcode, ARM emulation for building the Pi.
- After boot: `nix-shell -p libva-utils --run vainfo` should show the iHD driver.

### laptop — Core i7-11500H + RTX 3050 Ti

- **BIOS:** UEFI on, Secure Boot off, graphics mode *Hybrid/Optimus* (not
  "discrete only").
- Verify GPU bus IDs before installing (step 5).
- Already configured: Intel iGPU drives the screen, NVIDIA via
  `nvidia-offload`, thermald, suspend on lid close, shorter idle timers.
- After boot: `nvidia-smi` lists the card; `nvidia-offload glxinfo | grep renderer`
  (`nix-shell -p mesa-demos`).

## If the install fails

- **Build error** — the message names the file and line. Fix, `git add -A`,
  and re-run the same command; Disko re-partitions, which is fine on a fresh
  machine.
- **Out of space in the live session** — the build happens on the target disk,
  but very large builds can still fill the ISO's RAM disk; reboot the ISO and
  retry.
- **Stuck at "waiting for device"** at first boot — the disk name in `disko.nix`
  doesn't match; boot the ISO, run `mercury-recover` via
  `sudo nix run .#recover`, and check `/mnt/etc/fstab`.
