{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.office.docs.todoist;
in {
  options.mercury.home.apps.office.docs.todoist.enable = lib.mkEnableOption "todoist";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.todoist
      pkgs.todoist-electron
    ];
  };
}
