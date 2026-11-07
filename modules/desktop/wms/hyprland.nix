# Hyprland (system side). The user side — config files, Wayle shell, lock,
# idle, launcher — lives in home/desktop/wms/hyprland.nix.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.mercury.desktop.wms.hyprland;
in {
  options.mercury.desktop.wms.hyprland = {
    enable = lib.mkEnableOption "Hyprland (UWSM session) with the services the Wayle shell expects";

    autoRotate = lib.mkEnableOption "iio-hyprland screen auto-rotation (2-in-1 / tablet devices only)";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # PAM entry for the lock screen
    programs.hyprlock.enable = true;

    # Services Wayle's battery, network, bluetooth and power widgets talk to
    services.upower.enable = true;
    services.power-profiles-daemon.enable = lib.mkDefault true;

    # File manager integration (trash, mounts, thumbnails)
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    # Graphical polkit agent runs per-user (hyprpolkitagent); system polkit must be on
    security.polkit.enable = true;

    hardware.sensor.iio.enable = lib.mkIf cfg.autoRotate true;
    environment.systemPackages = lib.optionals cfg.autoRotate [
      inputs.iio-hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
