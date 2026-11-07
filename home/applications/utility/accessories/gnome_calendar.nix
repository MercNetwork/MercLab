{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.gnome_calendar;
in {
  options.mercury.home.apps.utility.accessories.gnome_calendar.enable = lib.mkEnableOption "Gnome calendar";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-calendar
    ];
  };
}
