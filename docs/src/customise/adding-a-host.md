# Adding a host

Three steps for any machine: a folder, a line in `flake.nix`, install.

## Generic NixOS machine

```bash
cd ~/MercLab
cp -r hosts/desktop hosts/newbox
```

1. Edit `hosts/newbox/configuration.nix`: hostname, GPU, what to enable.
2. Edit `hosts/newbox/disko.nix`: disk device, swap size.
3. Register it in `flake.nix`:
   ```nix
   nixosConfigurations = {
     desktop = mkSystem {host = "desktop";};
     laptop  = mkSystem {host = "laptop";};
     newbox  = mkSystem {host = "newbox";};
   };
   ```
4. `git add -A && mcli check`, then install with
   [mercury-install](../install/nixos.md).

The flake name, folder name and `mercury.hardware.networking.hostname` should
all match — mcli picks the flake output from the hostname.

## A headless server

Start from the laptop/desktop files but leave out the desktop:

```nix
# hosts/server/configuration.nix
{...}: {
  imports = [ ./disko.nix ./hardware-configuration.nix ];

  mercury = {
    hardware.networking = { hostname = "server"; backend = "networkmanager"; };
    personalization.locales.locale = "en_US.UTF-8";
    services = {
      ssh.enable = true;          # already on by default; keys only
      tailscale.enable = true;
    };
    system = {
      user.authorizedKeys = [ "ssh-ed25519 AAAA… mercury@desktop" ];
      home_manager = {
        enable = true;
        profile = [ ../../home/users/mercury/common.nix ];   # shell only, no GUI
      };
    };
    virtualization.docker.enable = true;
    oci.jellyfin.enable = true;
  };
}
```

Add your SSH public key *before* installing — password login over SSH is
disabled. Consider `mercury.services.ssh.initrdUnlock.enable = true;` to type
the disk passphrase over SSH after a reboot.

## Raspberry Pi 5

Already prepared: `hosts/piserver/` plus commented lines in `flake.nix`. Follow
[Setting up the Pi](../install/pi.md). The same pattern works for any remote
machine: give it a `disko.nix`, boot any NixOS installer on it, and run
`mcli deploy <host> root@<ip>` from a machine that already runs MercLab.

## Another Mac

```nix
darwinConfigurations = {
  mac   = mkDarwin {host = "mac";};
  mac2  = mkDarwin {host = "mac2";};
};
```

Copy `hosts/mac`, change the host names inside.

## Home Manager only (another Linux distro)

For a non-NixOS machine where you just want your shell and apps. Add to
`flake.nix` outputs:

```nix
homeConfigurations."mercury@workpc" = inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  extraSpecialArgs = {
    inherit inputs stateVersion;
    inherit (helpers) getFiles;
    host = "workpc";
    platform = "linux";
  };
  modules = [
    ./home/home.nix
    ./home/users/mercury/common.nix
    {
      home.username = "mercury";
      home.homeDirectory = "/home/mercury";
      home.stateVersion = stateVersion;
      nixpkgs.config.allowUnfree = true;
    }
  ];
};
```

On that machine (with Nix installed):
`nix run home-manager/release-26.05 -- switch --flake ~/MercLab#mercury@workpc`.
