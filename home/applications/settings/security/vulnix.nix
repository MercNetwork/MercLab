{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.home.apps.settings.security.vulnix;
in {
  options.mercury.home.apps.settings.security.vulnix = {
    enable = lib.mkEnableOption "Vulnix vulnerability scanner";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vulnix
    ];
  };
}
