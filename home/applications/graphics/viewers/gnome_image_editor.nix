{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.viewers.gnome_image_editor;
in {
  options.mercury.home.apps.graphics.viewers.gnome_image_editor.enable = lib.mkEnableOption "Gnome image editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.switcheroo
    ];
  };
}
