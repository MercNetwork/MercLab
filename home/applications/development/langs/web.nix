{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.web;
in {
  options.mercury.home.apps.development.langs.web.enable = lib.mkEnableOption "HTML, CSS, JSON, ESLint, Svelte and Vue support (LSPs)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vscode-langservers-extracted # html, cssls, jsonls, eslint
      pkgs.svelte-language-server
      pkgs.vue-language-server
      pkgs.prettierd # formatter
    ];
  };
}
