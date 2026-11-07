{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mercury.desktop.des.gnome;
in {
  options.mercury.desktop.des = {
    gnome.enable = lib.mkEnableOption "Gnome feature set";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.gnome.enable = cfg.enable;
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];
  };
}
