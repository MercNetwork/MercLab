{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.tools.heimdall;
in {
  options.mercury.home.apps.development.tools.heimdall.enable = lib.mkEnableOption "Heimdall flash utility";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.heimdall-gui
    ];
  };
}
