{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.core.bluetooth;
in {
  options.mercury.home.apps.system.core.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Bluetooth CLI tools (off by default: the Wayle bar has a Bluetooth menu).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bluez
      bluez-tools
    ];
  };
}
