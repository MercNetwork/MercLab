{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.hardware.printing;
in {
  options.mercury.hardware = {
    printing.enable = lib.mkEnableOption "Printing feature set";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    mercury.storage.impermanence.directories = [
      "/var/lib/cups"
    ];
  };
}
