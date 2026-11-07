{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.starship;
in {
  options.mercury.home.apps.system.shell.starship.enable = lib.mkEnableOption "Starship";

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      presets = ["gruvbox-rainbow"];
      settings = {
        hostname.ssh_only = false;
      };
    };
  };
}
