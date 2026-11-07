{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.science.electronics.kicad;
in {
  options.mercury.home.apps.science.electronics.kicad.enable = lib.mkEnableOption "Kicad";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kicad
    ];
  };
}
