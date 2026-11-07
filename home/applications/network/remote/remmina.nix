{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.remmina;
in {
  options.mercury.home.apps.network.remote.remmina.enable = lib.mkEnableOption "Remmina VNC";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.remmina
    ];
  };
}
