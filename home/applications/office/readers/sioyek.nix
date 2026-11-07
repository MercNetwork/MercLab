{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.readers.sioyek;
in {
  options.mercury.home.apps.office.readers.sioyek.enable = lib.mkEnableOption "Sioyek";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];
  };
}
