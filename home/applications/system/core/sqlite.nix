{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.core.sqlite;
in {
  options.mercury.home.apps.system.core.sqlite.enable = lib.mkEnableOption "SQLite support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # SQLite
      pkgs.sqlite

      # LSP
      pkgs.sqls
    ];
  };
}
