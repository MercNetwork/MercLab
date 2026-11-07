{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.tools.postman;
in {
  options.mercury.home.apps.development.tools.postman.enable = lib.mkEnableOption "Postman";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.postman
    ];
  };
}
