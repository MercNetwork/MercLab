{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.settings.security.gnome_seahorse;
in {
  options.mercury.home.apps.settings.security.gnome_seahorse.enable = lib.mkEnableOption "Gnome seahorse";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.seahorse
    ];
  };
}
