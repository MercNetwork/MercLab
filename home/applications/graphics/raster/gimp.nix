{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.raster.gimp;
in {
  options.mercury.home.apps.graphics.raster.gimp.enable = lib.mkEnableOption "Gimp";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
