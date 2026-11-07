# The roadmap to an end-all config

A suggested order for growing MercLab into the one config that runs
everything. Each phase is useful on its own; stop wherever you like.

## Phase 1 — Desktop running (week 1)
- Install `desktop`, finish the [first boot checklist](../install/first-boot.md).
- Live with the defaults for a few days; note every annoyance in a
  `TODO.md` in the repo.
- Learn: [Nix 1–3](../learn/nix-1-values.md), [Git](../learn/git.md).

## Phase 2 — Make it yours (weeks 2–3)
- Keybinds and look: `variables.lua`, `scheme/current.lua`, Wayle layout.
- Apps: enable toggles from the [module index](../reference/modules.md); turn
  on `langs.all` or the languages you use.
- Learn: [Lua](../learn/lua.md), [Nix 5](../learn/nix-5-packages.md).

## Phase 3 — Laptop (week 3–4)
- Install `laptop`. Verify bus IDs, PRIME, suspend, battery.
- Put shared changes in `common.nix`/`linux.nix`, machine-only ones in the host.
- Habit: `mcli check` before every push.

## Phase 4 — Secrets and password (month 2)
- Personal age key, `.sops.yaml`, move the password hash into sops
  ([Secrets](../customise/secrets.md)). Remove the default `chloe` hash.
- Tag a known-good state: `git tag -a good-<date>`.

## Phase 5 — Servers (month 2–3)
- Server: [headless host](../customise/adding-a-host.md#a-headless-server),
  Docker/OCI services (Jellyfin, Immich), Tailscale between machines.
- PiServer: [Raspberry Pi 5](../customise/adding-a-host.md#raspberry-pi-5),
  deploy from the desktop with `--target-host`.

## Phase 6 — Mac (when it arrives)
- [Setting up the Mac](../install/mac.md). Shared shell/editor from
  `common.nix`; GUI apps via Homebrew casks.

## Phase 7 — Hardening (optional)
- Impermanence on one machine first ([Disks](../customise/disks.md)).
- Remote LUKS unlock for servers.
- Prune: delete module files you're sure you'll never use, and their flake
  inputs ([inputs inventory](inputs.md)). Less code, less to update.

## Standing habits
- Update every week or two; release-upgrade every May/November.
- Commit config and docs together.
- When you fix something non-obvious, add it to Troubleshooting.
