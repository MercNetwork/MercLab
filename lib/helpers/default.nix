# Mercury helper library.
#
#   getFiles     — every .nix file below a directory (used for auto-imports)
#   mkSystem     — build a NixOS machine from hosts/<host>/configuration.nix
#   mkDarwin     — build a nix-darwin machine from hosts/<host>/configuration.nix
#   forAllSystems — generate per-system flake outputs
{
  lib,
  inputs,
  stateVersion,
}: rec {
  getFiles = dir:
    lib.filter
    (file: lib.hasSuffix ".nix" (toString file))
    (lib.filesystem.listFilesRecursive dir);

  linuxSystems = ["x86_64-linux" "aarch64-linux"];
  darwinSystems = ["aarch64-darwin"];
  forAllSystems = lib.genAttrs (linuxSystems ++ darwinSystems);

  # Exposes nixos-unstable as `pkgs.unstable.<name>` on every machine.
  unstableOverlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev.stdenv.hostPlatform) system;
      config.allowUnfree = true;
    };
  };

  hostConfig = host: "${inputs.self}/hosts/${host}/configuration.nix";

  mkSystem = {
    host,
    system ? "x86_64-linux",
    modules ? [],
    specialArgs ? {},
  }:
    lib.nixosSystem {
      inherit system;

      modules =
        [
          inputs.self.nixosModules.default
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [unstableOverlay];
          }
          (hostConfig host)
        ]
        ++ modules;

      specialArgs =
        {
          inherit inputs stateVersion host getFiles;
          platform = "linux";
        }
        // specialArgs;
    };

  mkDarwin = {
    host,
    system ? "aarch64-darwin",
    modules ? [],
    specialArgs ? {},
  }:
    inputs.nix-darwin.lib.darwinSystem {
      modules =
        [
          inputs.self.darwinModules.default
          {
            nixpkgs.hostPlatform = system;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [unstableOverlay];
          }
          (hostConfig host)
        ]
        ++ modules;

      specialArgs =
        {
          inherit inputs stateVersion host getFiles;
          platform = "darwin";
        }
        // specialArgs;
    };
}
