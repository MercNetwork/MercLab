{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.gnome_network_displays;
in {
  options.mercury.home.apps.network.remote.gnome_network_displays.enable = lib.mkEnableOption "Gnome network displays";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-network-displays
    ];
  };
}
