{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.calculator;
in {
  options.mercury.home.apps.utility.accessories.calculator.enable = lib.mkEnableOption "Gnome calculator";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bc # some calculator
      pkgs.libqalculate
    ];
  };
}
