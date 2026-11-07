{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.home.apps.system.core.usbutils;
in {
  options.mercury.home.apps.system.core.usbutils = {
    enable = lib.mkEnableOption "USB utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.usbutils
    ];
  };
}
