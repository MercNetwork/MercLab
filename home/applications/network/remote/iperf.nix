{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.iperf;
in {
  options.mercury.home.apps.network.remote.iperf.enable = lib.mkEnableOption "Iperf";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.iperf
    ];
  };
}
