# Home Manager on macOS — same profiles as NixOS, Linux-only modules skipped.
{
  config,
  lib,
  inputs,
  stateVersion,
  host,
  getFiles,
  platform,
  ...
}: let
  cfg = config.mercury.system.home_manager;
  user = config.mercury.system.user.name;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  options.mercury.system.home_manager = {
    enable = lib.mkEnableOption "Home Manager for the primary user";

    profile = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
      default = [];
      description = "Home Manager modules (user profiles) loaded for the primary user.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs stateVersion host getFiles platform;};
      sharedModules = [../../home/home.nix];

      users.${user} = {
        imports = cfg.profile;
        home.username = user;
        home.homeDirectory = "/Users/${user}";
        home.stateVersion = stateVersion;
      };
    };
  };
}
