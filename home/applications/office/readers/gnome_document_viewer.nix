{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.readers.gnome_document_viewer;
in {
  options.mercury.home.apps.office.readers.gnome_document_viewer.enable = lib.mkEnableOption "Gnome PDF viewer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.papers
    ];
  };
}
