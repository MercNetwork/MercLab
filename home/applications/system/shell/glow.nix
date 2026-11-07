{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.glow;
in {
  options.mercury.home.apps.system.shell.glow.enable = lib.mkEnableOption "Glow";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.glow
    ];
  };
}
