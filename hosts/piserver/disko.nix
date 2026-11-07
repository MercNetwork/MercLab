# PiServer disk layout, applied by `mcli deploy piserver root@<ip>`.
# THIS FORMATS THE DISK.
#
# Target: an NVMe drive on a Pi 5 NVMe HAT (/dev/nvme0n1) or a USB SSD
# (/dev/sda). It must NOT be the SD card the installer is running from.
#
#   FIRMWARE 1G  vfat   /boot/firmware   (Pi firmware, config.txt, kernel)
#   root     rest btrfs: @ → /  @home → /home  @nix → /nix  @swap → /swap
#
# No disk encryption: a headless Pi can't ask for a passphrase at boot.
# Compare with the disko examples in nixos-raspberrypi-demo before the first
# deploy if the Pi doesn't boot.
{lib, ...}: {
  disko.devices.disk.main = {
    device = lib.mkDefault "/dev/nvme0n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        FIRMWARE = {
          label = "FIRMWARE";
          priority = 1;
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/firmware";
            mountOptions = ["noatime" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=1min"];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-L" "nixos" "-f"];
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "@swap" = {
                mountpoint = "/swap";
                swap.swapfile.size = "4G";
              };
            };
          };
        };
      };
    };
  };
}
