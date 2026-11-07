{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.mercury.virtualization.flatpak;
in {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.mercury.virtualization = {
    flatpak.enable = lib.mkEnableOption "Flatpak feature set";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;

      overrides = {
        global = {
          Context.filesystems = ["/nix/store:ro"];
        };
      };
    };

    mercury.storage.impermanence.directories = [
      "/var/lib/flatpak"
    ];
  };
}
