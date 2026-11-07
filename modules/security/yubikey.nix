{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.security.yubikey;
in {
  options.mercury.security.yubikey = {
    enable = lib.mkEnableOption "YubiKey support & pcscd daemon";
  };

  config = lib.mkIf cfg.enable {
    services.pcscd.enable = true;
    environment.systemPackages = [
      pkgs.yubikey-manager
    ];
  };
}
