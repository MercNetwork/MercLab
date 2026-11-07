{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.file;
in {
  options.mercury.home.apps.system.shell.file.enable = lib.mkEnableOption "File";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.file
    ];
  };
}
