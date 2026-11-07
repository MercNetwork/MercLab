{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.hardware.bluetooth;
in {
  options.mercury.hardware = {
    bluetooth.enable = lib.mkEnableOption "Bluetooth feature set";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    mercury.storage.impermanence.directories = [
      "/var/lib/bluetooth"
    ];
  };
}
