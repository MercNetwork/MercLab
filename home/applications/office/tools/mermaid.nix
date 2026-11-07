{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.tools.mermaid;
in {
  options.mercury.home.apps.office.tools.mermaid.enable = lib.mkEnableOption "Mermaid support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mermaid-cli
    ];
  };
}
