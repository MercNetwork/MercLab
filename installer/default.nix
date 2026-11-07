# Mercury tools: mcli (daily helper), mercury-install, mercury-recover,
# and mercury-book (serves docs/ with mdBook).
{
  pkgs,
  inputs,
}: let
  system = pkgs.stdenv.hostPlatform.system;
in
  {
    mcli = pkgs.writeShellApplication {
      name = "mcli";
      runtimeInputs = with pkgs; [nvd alejandra coreutils findutils git];
      text = builtins.readFile ./mcli.sh;
    };

    book = pkgs.writeShellApplication {
      name = "mercury-book";
      runtimeInputs = [pkgs.mdbook pkgs.coreutils];
      text = ''
        repo="''${MERCURY_FLAKE:-$PWD}"
        if [ ! -f "$repo/docs/book.toml" ]; then
          echo "Run this from the MercLab repo (or set MERCURY_FLAKE)." >&2
          exit 1
        fi
        exec mdbook serve --open "$repo/docs" --dest-dir "$(mktemp -d)"
      '';
    };

    epub = pkgs.writeShellApplication {
      name = "mercury-epub";
      runtimeInputs = [pkgs.python3 pkgs.pandoc];
      text = ''
        repo="''${MERCURY_FLAKE:-$PWD}"
        exec python3 "$repo/docs/tools/make-epub.py" "$repo"
      '';
    };
  }
  // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    mercury-install = pkgs.writeShellApplication {
      name = "mercury-install";
      runtimeInputs = [
        inputs.disko.packages.${system}.disko
        pkgs.git
        pkgs.dropbear
        pkgs.ssh-to-age
        pkgs.openssh
        pkgs.nixos-install-tools
        pkgs.coreutils
        pkgs.util-linux
      ];
      text = builtins.readFile ./install.sh;
    };

    mercury-recover = pkgs.writeShellApplication {
      name = "mercury-recover";
      runtimeInputs = with pkgs; [btrfs-progs cryptsetup coreutils util-linux findutils];
      text = builtins.readFile ./recover.sh;
    };
  }
