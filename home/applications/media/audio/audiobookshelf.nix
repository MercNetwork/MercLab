{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.audio.audiobookshelf;
in {
  options.mercury.home.apps.media.audio.audiobookshelf.enable = lib.mkEnableOption "Audiobookshelft reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.audiobookshelf
    ];
  };
}
