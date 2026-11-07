{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.typst;
in {
  options.mercury.home.apps.development.langs.typst.enable = lib.mkEnableOption "Typst support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tinymist # Brain
      pkgs.typstyle # Janitor
    ];
  };
}
