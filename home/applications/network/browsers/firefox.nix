{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.browsers.firefox;
in {
  options.mercury.home.apps.network.browsers.firefox.enable = lib.mkEnableOption "Firefox Browser";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
