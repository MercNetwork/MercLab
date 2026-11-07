{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.pdfgrep;
in {
  options.mercury.home.apps.system.shell.pdfgrep.enable = lib.mkEnableOption "PDFgrep utility for searching text in PDF files";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pdfgrep
    ];
  };
}
