{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.lua;
in {
  options.mercury.home.apps.development.langs.lua = {
    enable = lib.mkEnableOption "Lua language tooling and runtime";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lua # Interpreter/runtime
      pkgs.lua-language-server # LSP
      pkgs.stylua # Formatter
      pkgs.selene # Linter
    ];
  };
}
