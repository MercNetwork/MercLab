{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.langs.qml;
in {
  options.mercury.home.apps.development.langs.qml.enable = lib.mkEnableOption "QML support (qmlls)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.qtdeclarative # provides qmlls
    ];
  };
}
