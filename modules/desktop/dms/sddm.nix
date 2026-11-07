# SDDM login screen (the default Mercury greeter).
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.desktop.dms.sddm;

  theme = pkgs.sddm-astronaut.override {
    embeddedTheme = cfg.theme;
  };
in {
  options.mercury.desktop.dms.sddm = {
    enable = lib.mkEnableOption "SDDM display manager";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "astronaut";
      example = "japanese_aesthetic";
      description = "sddm-astronaut embedded theme variant.";
    };

    defaultSession = lib.mkOption {
      type = lib.types.str;
      default = "hyprland-uwsm";
      description = "Session selected by default on the login screen.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      inherit (cfg) defaultSession;
      sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
        enableHidpi = false; # render at 100%
        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
            CursorTheme = "Bibata-Modern-Classic";
            CursorSize = 24;
          };
          Users.RememberLastUser = true;
        };
        extraPackages = [theme];
      };
    };

    environment.systemPackages = [
      theme
      pkgs.kdePackages.qtmultimedia
      pkgs.bibata-cursors
    ];

    mercury.storage.impermanence.directories = [
      "/var/lib/sddm"
    ];
  };
}
