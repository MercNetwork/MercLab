{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.utility.accessories.gnome_weather;
in {
  options.mercury.home.apps.utility.accessories.gnome_weather.enable = lib.mkEnableOption "Gnome weather";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-weather
    ];
  };
}
