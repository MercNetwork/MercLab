{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.tools.ghostscript;
in {
  options.mercury.home.apps.office.tools.ghostscript.enable = lib.mkEnableOption "Ghostscript";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.ghostscript # ghostscript
    ];
  };
}
