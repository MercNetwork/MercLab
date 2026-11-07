{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.ripgrep;
in {
  options.mercury.home.apps.system.shell.ripgrep = {
    enable = lib.mkEnableOption "Ripgrep search engine";
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };
  };
}
