{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.network.remote.openssl;
in {
  options.mercury.home.apps.network.remote.openssl.enable = lib.mkEnableOption "Openssl";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.openssl
    ];
  };
}
