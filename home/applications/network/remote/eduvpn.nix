{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.eduvpn;
in {
  options.mercury.home.apps.network.remote.eduvpn.enable = lib.mkEnableOption "EduVPN";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.eduvpn-client
    ];
  };
}
