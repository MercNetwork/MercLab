# Which languages, and when

Maintaining MercLab uses a handful of languages. You don't need all of them on
day one; this table tells you when each one matters.

| Language | Where in MercLab | Needed for | Chapter |
|----------|------------------|------------|---------|
| **Nix** | every `.nix` file | everything: apps, hosts, services | [Nix 1–6](nix-1-values.md) |
| **Lua** | `home/configs/hypr/`, `home/configs/nvim/` | keybinds, window rules, Neovim | [Lua](lua.md) |
| **Bash** | `installer/*.sh`, scripts inside modules, your shell | mcli, helper scripts, troubleshooting | [Bash](bash.md) |
| **TOML / YAML / JSON** | Wayle config, `.sops.yaml`, secrets, scratchpads | config formats other tools read | [Data formats](data-formats.md) |
| **Git** | the repo itself | saving, syncing, undoing | [Git](git.md) |
| **Markdown** | `docs/` | keeping this book current | [Markdown](markdown.md) |

Each chapter ends with exercises that use the real repo. Do them on a branch
(`git switch -c practice`) and throw the branch away afterwards
(`git switch main && git branch -D practice`). Nothing you do on a branch
touches a running machine until you `mcli switch`.

## A practice loop that can't break anything

```bash
cd ~/MercLab
mcli build      # builds the current machine and shows what would change — no activation
mcli repl       # explore any value interactively
mcli check      # evaluates every machine, including the ones you aren't on
```

`build`, `repl` and `check` never change the running system. Only
`switch`, `boot` and `test` do — and even those can be rolled back.
