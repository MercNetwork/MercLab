{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.readers.zlibrary;
in {
  options.mercury.home.apps.office.readers.zlibrary.enable = lib.mkEnableOption "Epub reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.z-library-desktop
    ];
  };
}
