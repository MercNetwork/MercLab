# Laptop — Intel Core i7-11500H (Iris Xe) + NVIDIA RTX 3050 Ti (PRIME offload).
# Build/switch: `mcli switch` (or `sudo nixos-rebuild switch --flake ~/MercLab#laptop`)
#
# The Intel GPU drives the screen; run something on the NVIDIA GPU with
#   nvidia-offload <program>
{...}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # Intel thermal daemon: keeps Tiger Lake CPUs from throttling hard
  services.thermald.enable = true;

  mercury = {
    desktop = {
      dms.sddm.enable = true;
      wms.hyprland.enable = true;
    };

    hardware = {
      gpu = {
        intel.enable = true;
        nvidia = {
          enable = true;
          prime = {
            enable = true;
            # Verify on the machine: `lspci | grep -E "VGA|3D"`
            #   00:02.0 -> "PCI:0:2:0"   01:00.0 -> "PCI:1:0:0"
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
      };
      bluetooth.enable = true;
      networking = {
        hostname = "laptop";
        backend = "networkmanager";
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };
      power = {
        enable = true;
        mode = "suspend";
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
        profile = [
          ../../home/users/mercury/linux.nix
          {
            # Lock after 5 min, suspend after 20 min on the laptop
            mercury.home.desktop.wms.hyprland.idle = {
              lockAfter = 300;
              suspendAfter = 1200;
            };
          }
        ];
      };
    };
  };
}
