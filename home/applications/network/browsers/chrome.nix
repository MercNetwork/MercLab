{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.browsers.chrome;
in {
  options.mercury.home.apps.network.browsers.chrome.enable = lib.mkEnableOption "Google Chrome";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.google-chrome
    ];
  };
}
