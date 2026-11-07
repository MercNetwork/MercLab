{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.browsers.tor;
in {
  options.mercury.home.apps.network.browsers.tor.enable = lib.mkEnableOption "Tor Browser";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.tor-browser
    ];
  };
}
