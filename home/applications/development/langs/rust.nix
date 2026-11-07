{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.rust;
in {
  options.mercury.home.apps.development.langs.rust.enable = lib.mkEnableOption "Rust language support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.rust-analyzer # Brain
      pkgs.rustfmt # Janitor
    ];
  };
}
