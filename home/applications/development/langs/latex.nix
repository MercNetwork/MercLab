{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.latex;
in {
  options.mercury.home.apps.development.langs.latex.enable = lib.mkEnableOption "Latex support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.texlab # LSP
      pkgs.texlivePackages.latexindent # Formatter
      pkgs.proselint # Linter
    ];
  };
}
