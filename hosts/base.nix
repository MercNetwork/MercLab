# Settings every Mercury NixOS machine gets, before any host file runs.
# Hosts override anything here with plain assignments or lib.mkForce.
{
  config,
  lib,
  pkgs,
  inputs,
  stateVersion,
  ...
}: let
  cfg = config.mercury.system.autoUpgrade;
in {
  imports = [
    inputs.disko.nixosModules.disko
    ../modules/modules.nix
  ];

  options.mercury.system.autoUpgrade = {
    enable = lib.mkEnableOption ''
      unattended upgrades. Off by default: MercLab is a private repo, so the
      machine needs read access to it (deploy key or token) before this works'';

    flake = lib.mkOption {
      type = lib.types.str;
      default = "git+ssh://git@github.com/MercNetwork/MercLab";
      description = "Flake URI that auto-upgrade pulls from. The host attribute is appended automatically.";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "04:00";
      description = "systemd calendar expression for when to upgrade.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mcli
      git
      nix-tree # audit closure size
      nvd # diff generations (used by mcli)
    ];

    system.stateVersion = stateVersion;

    system.autoUpgrade = lib.mkIf cfg.enable {
      enable = true;
      flake = "${cfg.flake}#${config.networking.hostName}";
      inherit (cfg) dates;
      allowReboot = false;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      randomizedDelaySec = "45min";
    };

    nix.optimise.automatic = true;

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];

      extra-substituters = [
        "https://cache.flox.dev"
      ];
      extra-trusted-public-keys = [
        "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      ];
    };
  };
}
