# Turning things on

Everything optional in Mercury is a toggle. Find it in the
[module index](../reference/modules.md), then set `enable = true` in the right
place.

```nix
# hosts/desktop/configuration.nix — system-level toggles
mercury.virtualization.docker.enable = true;
mercury.services.tailscale.enable = true;

# home/users/mercury/linux.nix — user-level toggles
mercury.home.apps.office.docs.obsidian.enable = true;
mercury.home.apps.development.langs.all.enable = true;   # every language at once
```

## What's on by default

| Where | Enabled |
|-------|---------|
| Every NixOS host | flakes, weekly GC, sops-nix, SSH server (keys only), the `mercury` user |
| desktop + laptop | Hyprland + Wayle, SDDM, PipeWire, Bluetooth, GNOME keyring, polkit, fonts, XDG portals, trash, **Steam** |
| desktop | Intel Arc drivers, latest kernel, ARM emulation (to build the Pi) |
| laptop | Intel + NVIDIA PRIME, thermald, power management, shorter idle timers |
| `common.nix` (all machines) | zsh, starship, kitty, Neovim, git, CLI tools, LSPs for Bash/Lua/Markdown/Nix/TOML/YAML |
| `linux.nix` | **Zed, Discord, Spotify, ProtonPlus**, Firefox, Nautilus, pwvucontrol, image/PDF viewers, Seahorse, btop |

Things the Wayle bar already does — Bluetooth menu, network menu, clock and
world clock, weather, notifications, volume/brightness pop-ups, wallpapers —
have no separate app enabled. Their standalone toggles still exist if you ever
want them.

## Languages (LSP + formatter + linter)

Each `mercury.home.apps.development.langs.<name>` installs the language server
and tools onto your PATH. Neovim starts any installed server automatically;
Zed uses PATH servers where it supports them and downloads the rest itself.

| Toggle | Language server(s) | Formatter / linter |
|--------|--------------------|--------------------|
| `bash` | bash-language-server | shfmt, shellcheck |
| `cpp` | clangd | clang-format |
| `docker` | dockerfile-language-server, docker-compose-language-service | hadolint |
| `go` | gopls | goimports, staticcheck, golangci-lint |
| `java` | jdtls | google-java-format |
| `js` | vtsls (JS/TS) | prettierd |
| `latex` | texlab | latexindent, proselint |
| `lua` | lua-language-server | stylua, selene |
| `markdown` | marksman, mdx-language-server | markdownlint, prettierd |
| `matlab` | matlab-language-server (needs MATLAB) | miss_hit |
| `nginx` | nginx-language-server | |
| `nix` | nixd | alejandra, statix, deadnix |
| `python` | ty, ruff | ruff |
| `qml` | qmlls | |
| `rust` | rust-analyzer | rustfmt |
| `toml` | taplo | taplo |
| `typst` | tinymist | typstyle |
| `web` | html, cssls, jsonls, eslint (vscode-langservers-extracted), svelte, vue | prettierd |
| `yaml` | yaml-language-server | prettierd |
| `all` | every one above except `matlab` | |

Compilers/runtimes for building your own projects are better kept per-project
in a `flake.nix` dev shell (with `direnv`, already enabled), so each project
pins its own versions.
