{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.desktop.gnome_system_monitor;
in {
  options.mercury.home.apps.system.desktop.gnome_system_monitor.enable = lib.mkEnableOption "Gnome System Monitor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-system-monitor
      pkgs.btop
    ];
  };
}
