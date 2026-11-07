# Disks, encryption and impermanence

## The default layout

`hosts/<name>/disko.nix` (applied only by `mercury-install`):

```text
ESP 1G (vfat, /boot)
LUKS (passphrase at boot)
 └─ Btrfs: @ → /   @home → /home   @nix → /nix   @persist → /persist
           @swap → /swap (swapfile)   @blank (empty, for impermanence)
```

Btrfs is compressed (zstd). Changing `disko.nix` on an installed machine does
**not** repartition anything; it only matters for the next install.

## Without encryption

Replace the whole `ROOT = { … content = { type = "luks"; … content = { type = "btrfs"; … }; }; };`
with the inner Btrfs part:

```nix
ROOT = {
  size = "100%";
  content = {
    type = "btrfs";
    extraArgs = [ "-L" "Nixos-root" "-f" ];
    subvolumes = { /* unchanged */ };
  };
};
```

## Impermanence ("erase your darlings")

Off by default. When on, `/` is reset to the empty `@blank` snapshot on every
boot; only `/home`, `/nix`, `/persist` and an explicit list survive. The
benefit: no forgotten state accumulates — the machine is exactly the config.

Turn it on (installed machine is fine):

```nix
mercury.storage.impermanence.enable = true;
```

Before rebooting, make sure anything you need outside `/home` is persisted.
Mercury modules already register their own state (NetworkManager, Bluetooth,
SDDM, SSH host keys, Docker, Tailscale…). Add others:

```nix
mercury.storage.impermanence.directories = [ "/var/lib/something" ];
mercury.storage.impermanence.files = [ "/etc/some-file" ];
```

Previous roots are kept in `old_roots/` for 30 days — `mercury-recover` mounts
the newest one, so you can copy out anything you forgot.

**Test first:** before enabling, list files recently written on `/` that live
outside the kept locations — these are what would disappear:

```bash
sudo find / -xdev -newer /etc/os-release \
  -not -path '/home/*' -not -path '/nix/*' -not -path '/persist/*' \
  -not -path '/proc/*' -not -path '/sys/*' -not -path '/run/*' | less
```

## Swap and hibernation

Swap is a swapfile in `@swap`. Hibernation needs `mercury.hardware.power`
with `mode = "hibernate"` and the swapfile's resume offset
(`sudo btrfs inspect-internal map-swapfile -r /swap/swapfile`) in
`hibernation.resumeOffset`, plus `resumeDevice = "/dev/mapper/cryptroot"`.
