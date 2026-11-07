{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.video.obs;
in {
  options.mercury.home.apps.media.video.obs.enable = lib.mkEnableOption "OBS";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.obs-studio
    ];
  };
}
