{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.gnome_fretboard;
in {
  options.mercury.home.apps.utility.accessories.gnome_fretboard.enable = lib.mkEnableOption "Gnome fretboard";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fretboard
    ];
  };
}
