{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.gaming.launchers.gamemode;
in {
  options.mercury.home.apps.gaming.launchers.gamemode.enable = lib.mkEnableOption "Gamemode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gamemode
    ];
  };
}
