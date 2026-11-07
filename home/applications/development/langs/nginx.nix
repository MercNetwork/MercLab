{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.nginx;
in {
  options.mercury.home.apps.development.langs.nginx.enable = lib.mkEnableOption "Nginx support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nginx-language-server # LSP
    ];
  };
}
