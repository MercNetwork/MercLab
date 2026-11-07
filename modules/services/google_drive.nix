{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.services.google_drive;
in {
  options.mercury.services.google_drive.enable = lib.mkEnableOption "Google Drive";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.rclone
    ];
    programs.fuse.enable = true;
  };
}
