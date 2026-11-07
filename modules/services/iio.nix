{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.services.iio;
in {
  options.mercury.services.iio.enable = lib.mkEnableOption "IIO sensors (accelerometer, ambient light) via iio-sensor-proxy";

  config = lib.mkIf cfg.enable {
    hardware.sensor.iio.enable = true;
  };
}
