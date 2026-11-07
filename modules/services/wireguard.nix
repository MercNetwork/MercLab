{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mercury.services.wireguard;
in {
  options.mercury.services.wireguard = {
    enable = lib.mkEnableOption "WireGuard feature set";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["wireguard"];

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];

    # Trust standard WireGuard tunnels (wg0, wg1, etc.)
    networking.firewall.trustedInterfaces = [
      "wg+"
    ];
  };
}
