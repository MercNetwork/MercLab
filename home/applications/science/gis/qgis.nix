{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.science.gis.qgis;
in {
  options.mercury.home.apps.science.gis.qgis.enable = lib.mkEnableOption "QGIS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.qgis
    ];
  };
}
