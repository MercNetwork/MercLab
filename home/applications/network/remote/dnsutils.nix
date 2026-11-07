{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.dnsutils;
in {
  options.mercury.home.apps.network.remote.dnsutils.enable = lib.mkEnableOption "Dnsutils";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.dnsutils
    ];
  };
}
