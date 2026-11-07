{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.system.shell.pay_respects;
in {
  options.mercury.home.apps.system.shell.pay_respects.enable = lib.mkEnableOption "Pay-respects";

  config = lib.mkIf cfg.enable {
    programs.pay-respects = {
      enable = true;
    };
  };
}
