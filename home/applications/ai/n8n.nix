{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.ai.n8n;
in {
  options.mercury.home.apps.ai.n8n.enable = lib.mkEnableOption "N8N";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.n8n
      pkgs.node-red
    ];
  };
}
