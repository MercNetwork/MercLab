# From an existing NixOS install

Use this if you installed NixOS with the normal graphical installer (no Disko,
no `mercury-install`) and now want MercLab on it. Nothing is reformatted.

## During the graphical install

- Create the user with the username **`mercury`**. MercLab sets
  `users.mutableUsers = false`, so any *other* user account created by the
  installer is removed on the first switch (its files stay in `/home`).
- Encryption, filesystem and partitioning are up to you — MercLab will use
  whatever you chose.

## After first boot

```bash
nix-shell -p git
git clone https://github.com/MercNetwork/MercLab.git ~/MercLab
cd ~/MercLab
```

1. **Keep the installer's filesystems.** Generate a hardware file *with*
   filesystems (no `--no-filesystems` this time):
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
   ```
2. **Turn off Disko for this host** — in `hosts/laptop/configuration.nix`:
   ```nix
   mercury.storage.disko.enable = false;
   ```
   (Leave the `./disko.nix` import in place; it's ignored when disabled.)
3. **Keep the bootloader you installed with.** If the graphical installer set
   up GRUB instead of systemd-boot, copy its `boot.loader` lines from
   `/etc/nixos/configuration.nix` into the host file.
4. **First switch** (the hostname changes, so name the host explicitly):
   ```bash
   git add -A
   sudo nixos-rebuild switch --flake ~/MercLab#laptop
   ```
5. Reboot. Log in as `mercury` / `chloe` with the **Hyprland (uwsm)** session.
   From now on `mcli switch` works.

`/etc/nixos/` is no longer used; you can leave it or delete it.

## What you don't get this way

- The Btrfs subvolume layout and swapfile from `disko.nix` (so no
  impermanence unless your own layout supports it).
- Host keys and age identity created by the installer — make the age key for
  [secrets](../customise/secrets.md) with `ssh-to-age` from the existing SSH
  host key.

To move to the full layout later, back up `/home` and reinstall with
[mercury-install](nixos.md).
