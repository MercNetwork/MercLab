{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.js;
in {
  options.mercury.home.apps.development.langs.js.enable = lib.mkEnableOption "JavaScript/TypeScript support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vtsls # Brain
      pkgs.prettierd
    ];
  };
}
