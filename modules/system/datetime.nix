{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.system;
in {
  options.mercury.system = {
    timezone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = "Fallback time zone for the system if dynamic detection fails";
    };
    autoTimezone = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable automatic network-based timezone switching (tzupdate)";
    };
  };

  config = {
    # 1. Enable automatic network-based timezone switching (when requested)
    services.tzupdate.enable = cfg.autoTimezone;

    # 2. Fixed time zone when not detecting it automatically (tzupdate needs it unset)
    time.timeZone =
      if cfg.autoTimezone
      then null
      else lib.mkDefault cfg.timezone;
  };
}
