{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.tree;
in {
  options.mercury.home.apps.system.shell.tree.enable = lib.mkEnableOption "Tree";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.tree
    ];
  };
}
