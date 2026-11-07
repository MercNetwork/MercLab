{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.transfer.gnome_torrents;
in {
  options.mercury.home.apps.network.transfer.gnome_torrents.enable = lib.mkEnableOption "Gnome torrents";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.fragments
    ];
  };
}
