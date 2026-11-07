{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mercury.virtualization.docker;
in {
  options.mercury.virtualization = {
    docker.enable = lib.mkEnableOption "Docker feature set";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      extraPackages = with pkgs; [
        docker-buildx
      ];
      daemon.settings = {
        # userland-proxy = false;
        ipv6 = false;
      };
    };
    environment.systemPackages = with pkgs; [
      docker-buildx
    ];

    mercury.storage.impermanence.directories = [
      "/var/lib/docker"
    ];
  };
}
