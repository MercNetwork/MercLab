{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.vector.inkscape;
in {
  options.mercury.home.apps.graphics.vector.inkscape.enable = lib.mkEnableOption "Inkscape";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];
  };
}
