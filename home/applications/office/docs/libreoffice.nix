{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.docs.libreoffice;
in {
  options.mercury.home.apps.office.docs.libreoffice.enable = lib.mkEnableOption "Libreoffice";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice-fresh
    ];
  };
}
