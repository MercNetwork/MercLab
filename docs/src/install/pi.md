# Setting up the Pi (PiServer)

The Raspberry Pi 5 (8 GB) is prepared in `hosts/piserver/` but **not wired into
`flake.nix` yet**, so nothing about it can break the other machines until you
choose to start.

The Pi can't run the normal NixOS installer, so the flow is: boot a small
installer image from an SD card, then install MercLab onto the Pi's NVMe/USB
drive **from the desktop** with `nixos-anywhere`, which runs Disko remotely.

```text
desktop ──(mcli deploy piserver root@pi)──▶ Pi booted from SD installer
                                             └─ Disko formats NVMe, installs MercLab
```

## What you need

- Pi 5 8 GB, official power supply, Ethernet (easiest) or Wi-Fi.
- An NVMe HAT + NVMe drive, or a USB SSD — the install target.
- An SD card for the installer (only used once).
- The desktop installed and running MercLab (it builds the Pi system).

## 1. Wire the host in

In `flake.nix`, uncomment the `nixos-raspberrypi` input and the `piserver = …`
block. Then:

```bash
cd ~/MercLab
mcli update nixos-raspberrypi        # locks the new input
```

Add your SSH key to `hosts/piserver/configuration.nix`
(`user.authorizedKeys`) — paste the output of `cat ~/.ssh/id_ed25519.pub`.
SSH is key-only, so skipping this locks you out.

Check the disk in `hosts/piserver/disko.nix`: `/dev/nvme0n1` for an NVMe HAT,
`/dev/sda` for a USB SSD.

```bash
git add -A
mcli check
nix build .#nixosConfigurations.piserver.config.system.build.toplevel
```

The desktop builds ARM code through emulation (`boot.binfmt.emulatedSystems`
is already on there). Most packages, including the Pi kernel, come from
binary caches, so this is mostly downloading. If `mcli check` reports an
unknown option from the Pi modules, compare with the README at
<https://github.com/nvmd/nixos-raspberrypi> — that flake defines them.

## 2. Make the installer SD card

nixos-raspberrypi publishes installer images for the Pi 5
(`nixosConfigurations.rpi5-installer` in its flake). Build or download it as its
README describes, then write it to the SD card:

```bash
# the README gives the current command; at the time of writing it is the SD image of:
nix build github:nvmd/nixos-raspberrypi/main#nixosConfigurations.rpi5-installer.config.system.build.sdImage
sudo dd if=result/sd-image/*.img of=/dev/sdX bs=4M status=progress conv=fsync
```

## 3. Boot the Pi from the SD card

Plug in Ethernet and power. The installer enables SSH and mDNS; find its
address on your router or try `ping rpi5-installer.local`. The README lists the
login (usually `root` with your key or a password printed on the Pi's screen).

## 4. Deploy

From the desktop:

```bash
mcli deploy piserver root@<pi-address>
```

This runs `nixos-anywhere`, which uses `hosts/piserver/disko.nix` to partition
the NVMe/USB drive, installs MercLab, and reboots.

Remove the SD card. The Pi 5 tries SD first, then NVMe/USB; if it doesn't
boot from NVMe, set the boot order once with `sudo rpi-eeprom-config --edit`
from any Pi OS (`BOOT_ORDER=0xf416` puts NVMe first).

## 5. Use it

```bash
ssh mercury@piserver          # or its IP
```

Change it from the desktop — no need to log in:

```bash
mcli push piserver mercury@piserver
```

Or on the Pi itself: clone the repo to `~/MercLab` and `mcli switch` (slower —
the Pi builds anything not in the cache).

## Ideas for the Pi

Enable in `hosts/piserver/configuration.nix`:

```nix
mercury.services.tailscale.enable = true;     # reach it from anywhere
mercury.services.adguard.enable = true;       # network-wide ad blocking
mercury.virtualization.docker.enable = true;  # containers
mercury.services.syncthing.enable = true;     # file sync hub
```
