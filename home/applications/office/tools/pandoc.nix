{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.tools.pandoc;
in {
  options.mercury.home.apps.office.tools.pandoc.enable = lib.mkEnableOption "Pandoc";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pandoc
    ];
  };
}
