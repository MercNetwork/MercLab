{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mercury.desktop.des.xfce;
in {
  options.mercury.desktop.des = {
    xfce.enable = lib.mkEnableOption "XFCE desktop";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.xfce.enable = true;
  };
}
