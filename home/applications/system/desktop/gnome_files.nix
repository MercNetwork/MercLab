{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.desktop.gnome_files;
in {
  options.mercury.home.apps.system.desktop.gnome_files.enable = lib.mkEnableOption "Gnome files";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nautilus
    ];
  };
}
