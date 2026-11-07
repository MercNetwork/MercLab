{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.virtualization.distrobox;
in {
  options.mercury.home.apps.system.virtualization.distrobox.enable = lib.mkEnableOption "Distrobox";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.distrobox
      pkgs.distrobox-tui
    ];
  };
}
