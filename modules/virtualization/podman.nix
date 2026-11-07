{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.virtualization.podman;
  # Detecta de forma dinámica si Docker está activo en el host actual
  dockerEnabled = config.mercury.virtualization.docker.enable or false;
in {
  options.mercury.virtualization = {
    podman.enable = lib.mkEnableOption "Podman feature set";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = !dockerEnabled;
      dockerSocket.enable = !dockerEnabled;
    };

    virtualisation.containers.containersConf.settings = {
      engine = {
        color = "always";
        log_level = "info";
      };
    };

    mercury.storage.impermanence.directories = [
      "/var/lib/containers"
    ];
  };
}
