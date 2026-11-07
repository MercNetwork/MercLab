# Disko in plain English

**Disko** turns a Nix file into a partitioned, formatted, mounted disk. Instead
of clicking through a partitioner, `hosts/<name>/disko.nix` *describes* the
disk and the installer makes it so. The same file then tells NixOS how to mount
everything at boot, so the two can never disagree.

## Reading a disko file

```nix
disko.devices.disk.main = {
  device = lib.mkDefault "/dev/nvme0n1";     # which physical disk
  type = "disk";
  content = {
    type = "gpt";                            # partition table
    partitions = {
      ESP = {                                # partition 1: boot
        size = "1G";
        type = "EF00";                       # EFI system partition
        content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; };
      };
      ROOT = {                               # partition 2: the rest
        size = "100%";
        content = {
          type = "luks";                     # encrypted container…
          name = "cryptroot";
          content = {
            type = "btrfs";                  # …holding a Btrfs filesystem
            subvolumes = {
              "@"     = { mountpoint = "/"; };
              "@home" = { mountpoint = "/home"; };
              "@nix"  = { mountpoint = "/nix"; };
              # …
            };
          };
        };
      };
    };
  };
};
```

Read it inside-out: *a disk → a GPT table → partitions → what's in each
partition → where it mounts.*

## Why subvolumes

Btrfs subvolumes are like partitions that share free space. Splitting `/`,
`/home`, `/nix` and `/persist` lets each be snapshotted or wiped separately —
that's what makes [impermanence](../customise/disks.md) possible, and why a
reinstall can keep `/home` if you choose to.

## When Disko runs

| Situation | Disko does |
|-----------|------------|
| `mercury-install <host>` (live ISO) | wipes, partitions, formats, mounts at `/mnt` |
| `mcli deploy <host> root@ip` (nixos-anywhere) | the same, on a remote machine |
| every `mcli switch` afterwards | **nothing to the disk** — it only generates mount settings |

Editing `disko.nix` on an installed machine never repartitions it. If you
change the layout, it only applies on the next install.

## Choosing the disk safely

`/dev/nvme0n1` can change if you add drives. Stable names never change:

```bash
ls -l /dev/disk/by-id/
# nvme-Samsung_SSD_980_1TB_S64DNX0R123456 -> ../../nvme0n1
```

```nix
device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S64DNX0R123456";
```

## Machines installed without Disko

If a machine was installed with the normal NixOS installer, its disks don't
match `disko.nix`. Tell Mercury so:

```nix
mercury.storage.disko.enable = false;
```

and keep a `hardware-configuration.nix` that *includes* filesystems. See
[From an existing NixOS install](existing-nixos.md).
