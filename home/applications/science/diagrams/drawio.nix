{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.science.diagrams.drawio;
in {
  options.mercury.home.apps.science.diagrams.drawio.enable = lib.mkEnableOption "DrawIO";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.drawio
    ];
  };
}
