{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.virtualization.boxbuddy;
in {
  options.mercury.home.apps.system.virtualization.boxbuddy.enable = lib.mkEnableOption "Boxbuddy";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.boxbuddy
    ];
  };
}
