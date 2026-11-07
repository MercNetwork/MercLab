{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.cad.blender;
in {
  options.mercury.home.apps.graphics.cad.blender.enable = lib.mkEnableOption "Blender";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.blender
    ];
  };
}
