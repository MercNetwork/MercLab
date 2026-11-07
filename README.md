# MercLab

Private NixOS / nix-darwin / Home Manager configuration for all of mercury's
machines, built on **Mercury** — a modular framework of `mercury.*` toggles.

| Host | Hardware | System |
|------|----------|--------|
| `desktop` | Ryzen 5 5600X, Intel Arc B570 | NixOS 26.05 · Hyprland + Wayle |
| `laptop` | Core i7-11500H, RTX 3050 Ti | NixOS 26.05 · Hyprland + Wayle |
| `mac` | Apple Silicon | nix-darwin 26.05 |

```bash
mcli switch          # apply changes on this machine
mcli update          # update pinned inputs
mcli book            # open the manual
```

**Everything is documented in [the MercLab Book](docs/src/README.md)** —
installation, daily use, the desktop, customising, and lessons on Nix, Lua and
Bash using this repo. Serve it locally with `nix run .#book`.

Default login: `mercury` / `chloe` — change it (see *First boot checklist*).
