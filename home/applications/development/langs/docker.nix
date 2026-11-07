{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.docker;
in {
  options.mercury.home.apps.development.langs.docker.enable = lib.mkEnableOption "Dockerfile and Compose support (LSPs)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.dockerfile-language-server or pkgs.dockerfile-language-server-nodejs) # dockerls
      pkgs.docker-compose-language-service # compose LSP
      pkgs.hadolint # Dockerfile linter
    ];
  };
}
