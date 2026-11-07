{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.settings.packages.gnome_software;
in {
  options.mercury.home.apps.settings.packages.gnome_software.enable = lib.mkEnableOption "Gnome software";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-software
    ];
  };
}
