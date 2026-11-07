{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.bash;
in {
  options.mercury.home.apps.development.langs.bash.enable = lib.mkEnableOption "BASH support";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.bash-language-server
      pkgs.shfmt
      pkgs.shellcheck
    ];
  };
}
