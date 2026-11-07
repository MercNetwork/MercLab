{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.tools.zotero;
in {
  options.mercury.home.apps.office.tools.zotero.enable = lib.mkEnableOption "zotero";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zotero
    ];
  };
}
