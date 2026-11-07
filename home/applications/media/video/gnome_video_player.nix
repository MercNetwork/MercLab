{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.video.gnome_video_player;
in {
  options.mercury.home.apps.media.video.gnome_video_player.enable = lib.mkEnableOption "Gnome video player";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.showtime
    ];
  };
}
