# Where Mercury came from

Mercury began as a fork of **Frost**, a public NixOS starter framework (MIT
license). It was imported once and is now maintained only here. There is no
link back: no Frost input, no update path, nothing fetched from its author.

## What was removed

- The author's own tools ("icebergs": Prism, Sled, Beacon, Borealis, Basecamp,
  Barograph, Lantern, Goggles, Rime, Searchlight, Skald, Snowpack, Shards) and
  their 13 flake inputs.
- The Caelestia shell, its Igloo wrapper, and the Permafrost greeter.
- The author's AI agent prompts/skills, personal Caddyfile, logos, Neovim tool
  integrations and username defaults.
- The `server` and `workstation` example hosts (replaced by `desktop`,
  `laptop`, `mac`).

## What changed

- Namespace `frost.*` → `mercury.*`; tools renamed `mercury-install`,
  `mercury-recover`; new `mcli`.
- Caelestia replaced by **Wayle**; every keybind now points at an installed
  program; Arch-only startup commands removed; tools Wayle covers (awww
  wrapper, Bluetooth CLI, clocks app, GTK settings app) dropped from defaults.
- Fixed 100% scaling: no `auto` monitor scale, XWayland zero-scaling, no Qt
  auto-DPI, SDDM HiDPI off, one `scale` option for Hyprland + Wayle.
- `mercury.storage.disko.enable` for machines installed without Disko;
  `mcli deploy`/`push` (nixos-anywhere) for remote machines; prepared
  `piserver` host.
- Added nix-darwin support, GPU module, central user module, per-platform user
  profiles, extra language modules (`docker`, `web`, `qml`, `all`).
- Fixed: dangling dotfile links, auto-upgrade with no flake, missing
  `iio-hyprland` package reference, Btrfs rollback racing the LUKS unlock,
  Neovim language servers that never started, installer key placement on
  non-impermanent systems, the repo not being copied into place on install.

## Licence

Frost's MIT licence requires keeping its copyright notice with substantial
copies of its code, so `LICENSE` keeps that line alongside MercLab's. That is
the only remaining trace and has no effect on how anything runs. The Hyprland
Lua configuration was itself derived from the Caelestia project's dotfiles.
