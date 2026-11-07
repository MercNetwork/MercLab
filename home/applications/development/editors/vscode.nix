{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.editors.vscode;
in {
  options.mercury.home.apps.development.editors.vscode.enable = lib.mkEnableOption "Vscode";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vscode
    ];
  };
}
