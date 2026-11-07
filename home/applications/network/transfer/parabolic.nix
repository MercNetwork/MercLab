{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.transfer.parabolic;
in {
  options.mercury.home.apps.network.transfer.parabolic.enable = lib.mkEnableOption "Youtube downloader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.parabolic
    ];
  };
}
