{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.desktop.dms.ly;
in {
  options.mercury.desktop.dms.ly.enable = lib.mkEnableOption "Ly";

  config = lib.mkIf cfg.enable {
    services.displayManager = {
      ly = {
        enable = true;
      };
    };
  };
}
