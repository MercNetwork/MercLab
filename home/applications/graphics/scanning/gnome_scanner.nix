{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.scanning.gnome_scanner;
in {
  options.mercury.home.apps.graphics.scanning.gnome_scanner.enable = lib.mkEnableOption "Gnome scanner";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.simple-scan
    ];
  };
}
