{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.ai.opencode;
in {
  options.mercury.home.apps.ai.opencode.enable = lib.mkEnableOption "Opencode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
    ];
  };
}
