{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.desktop.dms.gdm;
in {
  options.mercury.desktop.dms.gdm.enable = lib.mkEnableOption "GDM";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      gdm = {
        enable = true;
      };
    };
  };
}
