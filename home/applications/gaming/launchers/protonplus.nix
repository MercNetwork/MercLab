{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.gaming.launchers.protonplus;
in {
  options.mercury.home.apps.gaming.launchers.protonplus.enable = lib.mkEnableOption "ProtonPlus (install Proton-GE and other compatibility tools for Steam/Heroic)";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.protonplus];
  };
}
