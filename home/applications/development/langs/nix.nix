{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.nix;
in {
  options.mercury.home.apps.development.langs.nix.enable = lib.mkEnableOption "Nix support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nix
      pkgs.nixd # LSP
      pkgs.alejandra # Formatter
      pkgs.statix # Linter
      pkgs.deadnix # Linter
    ];
  };
}
