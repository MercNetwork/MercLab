{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.gaming.launchers.heroic;
in {
  options.mercury.home.apps.gaming.launchers.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heroic
    ];
  };
}
