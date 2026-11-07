{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.virtualization.kontainer;
in {
  options.mercury.home.apps.system.virtualization.kontainer.enable = lib.mkEnableOption "kontainer";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kontainer
    ];
  };
}
