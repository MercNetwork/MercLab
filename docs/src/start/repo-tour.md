# Repository tour

```text
MercLab/
├── flake.nix              Inputs (where software comes from) and outputs
│                          (the machines, tools and modules this repo provides)
├── flake.lock             Exact pinned versions of every input. Commit it.
├── lib/helpers/           mkSystem / mkDarwin / getFiles helpers
├── hosts/                 One folder per machine
│   ├── base.nix           Nix settings every NixOS machine gets
│   ├── boot.nix           systemd-boot and quiet boot defaults
│   ├── desktop/           configuration.nix, disko.nix, hardware-configuration.nix
│   ├── laptop/            same three files
│   └── mac/               configuration.nix (nix-darwin)
├── modules/               NixOS modules — options under `mercury.*`
│   ├── desktop/           Hyprland, display managers (SDDM…), GNOME, XFCE
│   ├── hardware/          GPU, audio, Bluetooth, networking, power, printing
│   ├── security/          polkit, keyring, PAM/U2F, sops-nix, 1Password, YubiKey
│   ├── services/          SSH, Tailscale, WireGuard, Syncthing, Caddy, AdGuard…
│   ├── storage/           impermanence, Btrfs rollback, ZFS, trash
│   ├── system/            users, Home Manager wiring, locale, time, Plymouth
│   ├── virtualization/    Docker, Podman, libvirt, MicroVM, Flatpak…
│   └── oci/ flatpak/ leisure/ personalization/
├── darwin/                nix-darwin modules (macOS) — options under `mercury.*`
├── home/                  Home Manager modules — options under `mercury.home.*`
│   ├── home.nix           Collects every home module
│   ├── applications/      ~150 app toggles by category
│   ├── desktop/           the Hyprland + Wayle desktop (Linux only)
│   ├── environment/       fonts, GTK, XDG, dotfile path, ignore lists
│   ├── services/          user services (Syncthing, Caddy, Google Drive)
│   ├── configs/           real dotfiles: hypr/, nvim/, zsh.d/, caddy/
│   └── users/mercury/     YOUR profile: common.nix, linux.nix, darwin.nix
├── installer/             mcli, mercury-install, mercury-recover, book launcher
└── docs/                  this book
```

## The files you will touch most

| You want to… | Edit |
|--------------|------|
| install/remove an app for yourself | `home/users/mercury/common.nix` (everywhere) or `linux.nix` / `darwin.nix` |
| change a machine's hardware, services, drivers | `hosts/<name>/configuration.nix` |
| change a keybind or default app | `home/configs/hypr/variables.lua` |
| change the bar | `mercury.home.desktop.wms.hyprland.wayle.settings` (see [Wayle](../desktop/wayle.md)) |
| change Neovim | `home/configs/nvim/lua/mercury/` |
| add shell aliases/functions | `home/configs/zsh.d/custom.zsh` or a file in `home/configs/zsh.d/conf.d/` |
| add a new machine | `flake.nix` + `hosts/<new>/` ([Adding a host](../customise/adding-a-host.md)) |
