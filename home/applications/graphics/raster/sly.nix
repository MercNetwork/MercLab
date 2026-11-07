{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.raster.sly;
in {
  options.mercury.home.apps.graphics.raster.sly.enable = lib.mkEnableOption "SLY Image editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sly
    ];
  };
}
