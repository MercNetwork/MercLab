{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.audio.cozy;
in {
  options.mercury.home.apps.media.audio.cozy.enable = lib.mkEnableOption "Cozy Audiobook reader";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.cozy
    ];
  };
}
