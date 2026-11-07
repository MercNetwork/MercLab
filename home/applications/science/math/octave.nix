{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.science.math.octave;
in {
  options.mercury.home.apps.science.math.octave.enable = lib.mkEnableOption "GNU Octave";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnuplot
      pkgs.octave
    ];
  };
}
