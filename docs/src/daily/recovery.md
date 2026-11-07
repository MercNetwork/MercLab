# Rolling back and recovery

From least to most drastic.

## 1. Roll back while running

```bash
mcli rollback
```

## 2. Pick an older generation at boot

Reboot; in the systemd-boot menu choose an older "NixOS … Generation N" entry
(press a key during the 1-second timeout, or hold Space). Once booted:
`sudo /run/current-system/bin/switch-to-configuration boot` makes it the
default again.

## 3. Fix the config from the broken system

If you can reach a TTY (`CTRL+ALT+F2`), log in, fix the file, `mcli switch`.

## 4. Repair from the installer USB

```bash
# boot the NixOS ISO, open a terminal, get online
git clone https://github.com/MercNetwork/MercLab.git && cd MercLab
sudo nix --extra-experimental-features "nix-command flakes" run .#recover
#   → unlocks the LUKS disk (asks the passphrase) and mounts everything at /mnt
sudo nixos-enter
# now you're "inside" the installed system as root
cd /home/mercury/MercLab
nixos-rebuild boot --flake .#<host>
exit; reboot
```

Reinstall the bootloader if it's damaged (from inside `nixos-enter`):
`NIXOS_INSTALL_BOOTLOADER=1 /nix/var/nix/profiles/system/bin/switch-to-configuration boot`

## 5. Reinstall

Your data in `/home` survives only if you don't run `mercury-install` (it
formats the disk). Back up `/home` first, then follow
[Installing a NixOS machine](../install/nixos.md). Because the config is in git,
a reinstall gives you the identical system.

## The Mac

`sudo darwin-rebuild --rollback`, or `mcli rollback`. nix-darwin never touches
the macOS boot process, so the Mac always boots.
