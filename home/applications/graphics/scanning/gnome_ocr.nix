{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.graphics.scanning.gnome_ocr;
in {
  options.mercury.home.apps.graphics.scanning.gnome_ocr.enable = lib.mkEnableOption "Gnome OCR";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-frog
    ];
  };
}
