{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.video.kdenlive;
in {
  options.mercury.home.apps.media.video.kdenlive.enable = lib.mkEnableOption "Kdenlive";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdenlive
    ];
  };
}
