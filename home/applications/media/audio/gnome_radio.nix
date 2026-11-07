{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.audio.gnome_radio;
in {
  options.mercury.home.apps.media.audio.gnome_radio.enable = lib.mkEnableOption "Gnome radio";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.shortwave
    ];
  };
}
