{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.desktop.gnome_characters;
in {
  options.mercury.home.apps.system.desktop.gnome_characters.enable = lib.mkEnableOption "Gnome characters";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-characters
    ];
  };
}
