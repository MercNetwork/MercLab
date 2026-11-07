#!/usr/bin/env bash
set -euo pipefail

# mercury-recover — mount an installed Mercury system at /mnt for repair.
#
#   sudo mercury-recover            # auto-detect (unlocks LUKS if needed)
#   sudo mercury-recover /dev/...   # explicit Btrfs device
#   sudo nixos-enter                # then work inside the system
#
# With impermanence enabled, the newest archived root in old_roots/ is mounted
# (that's the state from before the last reboot).

ROOT_DEV="${1:-}"

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: mercury-recover must be run as root (or via sudo)." >&2
  exit 1
fi

# Unlock the encrypted root if it isn't open yet (Disko partition label "luks")
if [ -z "${ROOT_DEV}" ] && [ ! -e /dev/mapper/cryptroot ] && [ -e /dev/disk/by-partlabel/luks ]; then
  echo "--> Unlocking /dev/disk/by-partlabel/luks as cryptroot..."
  cryptsetup open /dev/disk/by-partlabel/luks cryptroot
fi

# Auto-detect root device if not explicitly provided
if [ -z "${ROOT_DEV}" ]; then
  if [ -e "/dev/mapper/cryptroot" ]; then
    ROOT_DEV="/dev/mapper/cryptroot"
  elif [ -e "/dev/disk/by-label/Nixos-root" ]; then
    ROOT_DEV="/dev/disk/by-label/Nixos-root"
  else
    echo "Error: Could not automatically detect root block device." >&2
    echo "Please specify the root device: mercury-recover <root-device>" >&2
    echo "Examples:" >&2
    echo "  mercury-recover /dev/mapper/cryptroot" >&2
    echo "  mercury-recover /dev/disk/by-label/Nixos-root" >&2
    exit 1
  fi
fi

echo "--> Target root device: ${ROOT_DEV}"

# 1. Clean up existing mounts
echo "--> Cleaning up existing /mnt mounts..."
umount -R /mnt 2>/dev/null || true

# 2. Check for latest old_roots snapshot
TMP_MOUNT="$(mktemp -d /tmp/mercury-recover.XXXXXX)"
mount "${ROOT_DEV}" "${TMP_MOUNT}"

LATEST_ROOT=""
if [ -d "${TMP_MOUNT}/old_roots" ]; then
  # Find latest timestamped folder
  LATEST_ROOT="$(find "${TMP_MOUNT}/old_roots" -mindepth 1 -maxdepth 1 -printf "%f\n" 2>/dev/null | sort -n | tail -n 1 || true)"
fi

umount "${TMP_MOUNT}"
rmdir "${TMP_MOUNT}"

# 3. Mount root subvolume
if [ -n "${LATEST_ROOT}" ]; then
  echo "--> Found historical root snapshot: old_roots/${LATEST_ROOT}"
  echo "--> Mounting dynamic root subvolume to /mnt..."
  mount -o "subvol=old_roots/${LATEST_ROOT}" "${ROOT_DEV}" /mnt
else
  echo "--> No old_roots snapshot found; mounting root subvolume '@' to /mnt..."
  mount -o subvol=@ "${ROOT_DEV}" /mnt
fi

# 4. Mount persistent subvolumes
echo "--> Mounting persistent subvolumes..."
mkdir -p /mnt/nix /mnt/persist /mnt/home /mnt/boot

mount -o subvol=@nix "${ROOT_DEV}" /mnt/nix
mount -o subvol=@persist "${ROOT_DEV}" /mnt/persist
mount -o subvol=@home "${ROOT_DEV}" /mnt/home

# 5. Detect and mount boot partition
BOOT_DEV=""
if [ -e "/dev/disk/by-label/Nixos-boot" ]; then
  BOOT_DEV="/dev/disk/by-label/Nixos-boot"
elif [ -e "/dev/disk/by-label/boot" ]; then
  BOOT_DEV="/dev/disk/by-label/boot"
elif [ -e "/dev/disk/by-partlabel/boot" ]; then
  BOOT_DEV="/dev/disk/by-partlabel/boot"
fi

if [ -n "${BOOT_DEV}" ]; then
  echo "--> Mounting EFI boot partition (${BOOT_DEV}) to /mnt/boot..."
  mount "${BOOT_DEV}" /mnt/boot
else
  echo "Warning: Could not auto-detect boot partition. Mount it manually to /mnt/boot if needed." >&2
fi

echo "=================================================="
echo "--> Mercury system mounted at /mnt."
echo "Run 'nixos-enter' to access your system environment."
echo "=================================================="
