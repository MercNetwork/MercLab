{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.storage.gnome_disks;
in {
  options.mercury.storage.gnome_disks.enable = lib.mkEnableOption "Gnome disks";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gnome-disk-utility
    ];
  };
}
