# One switch for every language module (except MATLAB, which needs a MATLAB
# installation). Individual modules can still be turned off with
# `mercury.home.apps.development.langs.<name>.enable = false;`
{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs;
  every = [
    "bash" "cpp" "docker" "go" "java" "js" "latex" "lua" "markdown"
    "nginx" "nix" "python" "qml" "rust" "toml" "typst" "web" "yaml"
  ];
in {
  options.mercury.home.apps.development.langs.all.enable =
    lib.mkEnableOption "every language module (LSP, formatter, linter) except MATLAB";

  config = lib.mkIf cfg.all.enable {
    mercury.home.apps.development.langs = lib.genAttrs every (_: {enable = lib.mkDefault true;});
  };
}
