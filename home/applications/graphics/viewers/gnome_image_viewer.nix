{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.viewers.gnome_image_viewer;
in {
  options.mercury.home.apps.graphics.viewers.gnome_image_viewer.enable = lib.mkEnableOption "Gnome image viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.loupe
    ];
  };
}
