{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.curl;
in {
  options.mercury.home.apps.system.shell.curl.enable = lib.mkEnableOption "Curl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.curl
    ];
  };
}
