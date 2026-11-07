{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.virtualization.virt_manager;
in {
  options.mercury.home.apps.system.virtualization.virt_manager.enable = lib.mkEnableOption "Virt-manager";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.virt-manager
    ];
  };
}
