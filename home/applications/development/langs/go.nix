{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.go;
in {
  options.mercury.home.apps.development.langs.go.enable = lib.mkEnableOption "Go language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gopls # Brain
      pkgs.gotools # Janitor (goimports)
      pkgs.go-tools # Diagnostics (staticcheck)
      pkgs.golangci-lint # Diagnostics
    ];
  };
}
