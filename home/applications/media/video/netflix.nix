{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.video.netflix;
in {
  options.mercury.home.apps.media.video.netflix.enable = lib.mkEnableOption "Netflix";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.netflix
    ];
  };
}
