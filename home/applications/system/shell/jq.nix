{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.jq;
in {
  options.mercury.home.apps.system.shell.jq.enable = lib.mkEnableOption "Jq";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.jq
    ];
  };
}
