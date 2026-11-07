{
  config,
  lib,
  ...
}: let
  cfg = config.mercury.virtualization.oci;
  dockerEnabled = config.mercury.virtualization.docker.enable or false;
in {
  options.mercury.virtualization = {
    oci.enable = lib.mkEnableOption "oci-containers base engine";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend =
        if dockerEnabled
        then "docker"
        else "podman";
    };
  };
}
