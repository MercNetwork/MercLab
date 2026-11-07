# Desktop — AMD Ryzen 5 5600X, Intel Arc B570.
# Build/switch: `mcli switch` (or `sudo nixos-rebuild switch --flake ~/MercLab#desktop`)
{pkgs, ...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # Arc B570 (Battlemage) uses the `xe` driver, which needs a recent kernel.
  # Also enable Resizable BAR / Above 4G Decoding in the BIOS for Arc performance.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Lets the desktop build ARM (Raspberry Pi) systems under emulation.
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  mercury = {
    desktop = {
      dms.sddm.enable = true;
      wms.hyprland.enable = true;
    };

    hardware = {
      gpu.intel.enable = true;
      bluetooth.enable = true;
      networking = {
        hostname = "desktop";
        backend = "networkmanager";
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
    };

    personalization = {
      fonts.enable = true;
      locales.locale = "en_US.UTF-8";
      xdg.enable = true;
    };

    security = {
      gnome_keyring.enable = true;
      polkit.enable = true;
    };

    leisure.steam.enable = true;

    storage.trash.enable = true;

    system = {
      keymap = "us";
      autoTimezone = true;
      home_manager = {
        enable = true;
        profile = [../../home/users/mercury/linux.nix];
      };
    };
  };
}
