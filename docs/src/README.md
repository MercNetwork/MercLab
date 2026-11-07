# The MercLab Book

This book is the manual for **MercLab**, your private Nix configuration, and
**Mercury**, the framework inside it. It is written so you can install,
run, change, upgrade and repair every machine without outside help.

MercLab started from a fork of a public starter framework. Everything that tied
it to that project — its author's own tools, branding, inputs and accounts —
has been removed. Nothing in this repository pulls from, or waits on, anyone
else's configuration. The only things it depends on are mainstream community
projects (nixpkgs, Home Manager, nix-darwin, Disko, sops-nix and a few app
flakes), listed in [Flake inputs inventory](maintain/inputs.md), each of which
you can drop.

## The machines

| Name      | Hardware                                   | System     | Status        |
|-----------|--------------------------------------------|------------|---------------|
| `desktop` | Ryzen 5 5600X, Intel Arc B570              | NixOS      | wired in      |
| `laptop`  | Core i7-11500H, RTX 3050 Ti                | NixOS      | wired in      |
| `mac`     | Apple Silicon                              | nix-darwin | wired in, not purchased |
| `piserver` | Raspberry Pi 5 8 GB                      | NixOS      | prepared — [enable when ready](install/pi.md) |
| Server    | x86 media / virtualization box             | NixOS      | add yourself ([guide](customise/adding-a-host.md#a-headless-server)) |

## How to read this book

- **New to Nix?** Start with *Learning the languages* — it teaches Nix, Lua, Bash and the rest using this repo.
- **Installing for the first time?** Read *Getting started*, then *Installing*.
- **Day to day?** *Daily use* and the [`mcli`](daily/mcli.md) page are all you need.
- **Something broke?** Go straight to [Troubleshooting](maintain/troubleshooting.md)
  and [Rolling back and recovery](daily/recovery.md).
- **Growing it?** *Customising* and [the roadmap](maintain/roadmap.md).

Read it in a browser with live search:

```bash
cd ~/MercLab
nix run .#book        # or: mcli book
```

Or on your phone/e-reader: `docs/MercLab-Book.epub`. Rebuild it after editing
the book with `mcli epub`.

## Conventions

- `~/MercLab` is where the repository lives on every machine.
- Commands starting with `sudo` need an admin account; on NixOS that's any
  member of `wheel`.
- File paths are relative to the repository root unless they start with `/` or `~`.
- `mercury.*` options are NixOS/nix-darwin options; `mercury.home.*` options are
  Home Manager options. The [module index](reference/modules.md) lists all of them.
