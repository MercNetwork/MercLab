{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.readers.calibre;
in {
  options.mercury.home.apps.office.readers.calibre.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.calibre
    ];
  };
}
