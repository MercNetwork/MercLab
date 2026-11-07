{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.settings.desktop.nwg_look;
in {
  options.mercury.home.apps.settings.desktop.nwg_look.enable = lib.mkEnableOption "nwg-look";

  config = lib.mkIf cfg.enable {
    home.packages = [
      # nwg
      pkgs.nwg-look
    ];
  };
}
