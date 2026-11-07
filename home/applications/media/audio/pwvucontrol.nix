{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.audio.pwvucontrol;
in {
  options.mercury.home.apps.media.audio.pwvucontrol.enable = lib.mkEnableOption "Pwvucontrol";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pwvucontrol
    ];
  };
}
