{
  description = "Mercury — the MercLab NixOS / nix-darwin / Home Manager framework";

  inputs = {
    #################################################################
    # Package sets
    #################################################################
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    #################################################################
    # System
    #################################################################
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix.url = "github:nix-community/autofirma-nix/develop";

    # Raspberry Pi 5 support — uncomment together with `piserver` below
    # (docs/src/install/pi.md).
    # nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    #################################################################
    # Other package managers
    #################################################################
    flox = {
      url = "github:flox/flox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    #################################################################
    # Virtualization
    #################################################################
    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #################################################################
    # Desktop & apps
    #################################################################
    iio-hyprland = {
      url = "github:commonkestrel/iio-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw.url = "github:Gerg-L/mnw";

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    stateVersion = "26.05";

    helpers = import ./lib/helpers {inherit lib inputs stateVersion;};
    inherit (helpers) mkSystem mkDarwin forAllSystems;
  in {
    lib = {
      inherit mkSystem mkDarwin;
      inherit (helpers) getFiles;
    };

    nixosModules = {
      default = {...}: {
        imports = [
          ./modules/modules.nix
          ./hosts/base.nix
          ./hosts/boot.nix
        ];
      };
      mercury = inputs.self.nixosModules.default;
    };

    darwinModules = {
      default = ./darwin;
      mercury = inputs.self.darwinModules.default;
    };

    homeManagerModules = {
      default = ./home/home.nix;
      mercury = inputs.self.homeManagerModules.default;
    };

    #################################################################
    # Machines — add new ones here (see docs/src/hosts/adding-a-host.md)
    #################################################################
    nixosConfigurations = {
      desktop = mkSystem {host = "desktop";};
      laptop = mkSystem {host = "laptop";};

      # Raspberry Pi 5 (8 GB) — host files are ready in hosts/piserver.
      # piserver = mkSystem {
      #   host = "piserver";
      #   system = "aarch64-linux";
      #   specialArgs = {inherit (inputs) nixos-raspberrypi;};
      #   modules = with inputs.nixos-raspberrypi.nixosModules; [
      #     inputs.nixos-raspberrypi.lib.inject-overlays
      #     raspberry-pi-5.base
      #     raspberry-pi-5.page-size-16k
      #     raspberry-pi-5.bluetooth
      #   ];
      # };
    };

    darwinConfigurations = {
      mac = mkDarwin {host = "mac";};
    };

    #################################################################
    # Tools: mcli, mercury-install, mercury-recover, docs book
    #################################################################
    packages = forAllSystems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      tools = import ./installer {inherit pkgs inputs;};
    in
      {
        inherit (tools) mcli book epub;
        default = tools.mcli;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit (tools) mercury-install mercury-recover;
      });

    apps = forAllSystems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      tools = import ./installer {inherit pkgs inputs;};
      mkApp = drv: name: {
        type = "app";
        program = "${drv}/bin/${name}";
      };
    in
      {
        default = mkApp tools.mcli "mcli";
        mcli = mkApp tools.mcli "mcli";
        book = mkApp tools.book "mercury-book";
        epub = mkApp tools.epub "mercury-epub";
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        install = mkApp tools.mercury-install "mercury-install";
        recover = mkApp tools.mercury-recover "mercury-recover";
      });

    devShells = forAllSystems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          nixd
          nvd
          mdbook
          sops
          age
          ssh-to-age
          git
        ];
      };
    });

    formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
  };
}
