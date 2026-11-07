{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.toml;
in {
  options.mercury.home.apps.development.langs.toml.enable = lib.mkEnableOption "TOML support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.taplo
    ];
  };
}
