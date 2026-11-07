# PiServer — Raspberry Pi 5, 8 GB. Headless server.
#
# READY BUT NOT WIRED IN. To activate, uncomment `nixos-raspberrypi` and
# `piserver` in flake.nix, then follow docs/src/install/pi.md.
# Option names for the Pi bootloader come from the nixos-raspberrypi flake;
# check its README if an option is reported missing.
{lib, ...}: {
  imports = [./disko.nix];

  # The Raspberry Pi modules bring their own bootloader (no UEFI/systemd-boot).
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.raspberryPi.bootloader = "kernel"; # recommended for new installs

  mercury = {
    hardware.networking = {
      hostname = "piserver";
      backend = "networkmanager";
    };

    personalization.locales.locale = "en_US.UTF-8";

    services.ssh.enable = true; # key-only logins

    system = {
      autoTimezone = true;

      # REQUIRED before the first deploy — without a key you can't log in
      # over SSH. Paste the contents of ~/.ssh/id_ed25519.pub from the desktop.
      user.authorizedKeys = [
        # "ssh-ed25519 AAAA... mercury@desktop"
      ];

      # Shell, editor and CLI tools only — no desktop on a server.
      home_manager = {
        enable = true;
        profile = [../../home/users/mercury/common.nix];
      };
    };

    # Typical Pi server roles — switch on what you want:
    # services.tailscale.enable = true;
    # virtualization.docker.enable = true;
    # services.adguard.enable = true;
  };
}
