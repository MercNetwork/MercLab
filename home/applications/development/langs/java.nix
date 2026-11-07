{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.java;
in {
  options.mercury.home.apps.development.langs.java.enable = lib.mkEnableOption "Java language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.jdt-language-server # Brain
      pkgs.google-java-format # Janitor
    ];
  };
}
