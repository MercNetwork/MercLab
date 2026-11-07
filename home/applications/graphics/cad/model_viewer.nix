{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.cad.model_viewer;
in {
  options.mercury.home.apps.graphics.cad.model_viewer.enable = lib.mkEnableOption "3D model viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.exhibit
    ];
  };
}
