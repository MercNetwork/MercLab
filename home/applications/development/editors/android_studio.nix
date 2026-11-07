{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.development.editors.android_studio;
in {
  options.mercury.home.apps.development.editors.android_studio.enable = lib.mkEnableOption "Android Studio editor";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.android-studio
    ];
  };
}
