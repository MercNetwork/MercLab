{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.wget;
in {
  options.mercury.home.apps.system.shell.wget.enable = lib.mkEnableOption "Wget";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wget
    ];
  };
}
