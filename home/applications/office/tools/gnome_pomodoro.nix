{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.tools.gnome_pomodoro;
in {
  options.mercury.home.apps.office.tools.gnome_pomodoro.enable = lib.mkEnableOption "Gnome pomodoro";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-solanum
    ];
  };
}
