# mcli

`mcli` is a small Bash script (`installer/mcli.sh`) installed on every machine.
It only wraps standard commands and **prints each real command before running
it**, so you can always do the same thing by hand.

It assumes the repo is at `~/MercLab` and the flake output is named after the
machine's hostname. Override with `MERCURY_FLAKE=/path` or `MERCURY_HOST=name`.

| Command | Runs | Use it when |
|---------|------|-------------|
| `mcli switch` | `sudo nixos-rebuild switch --flake ~/MercLab#<host>` (`darwin-rebuild` on Mac) | apply changes now and on boot |
| `mcli boot` | `… boot …` | kernel/driver changes you'd rather apply at next reboot |
| `mcli test` | `… test …` | try something; a reboot undoes it |
| `mcli build` | `nix build …toplevel` then `nvd diff` | see what would change, safely |
| `mcli check` | `nix flake check` | before pushing; evaluates *all* machines |
| `mcli update [input]` | `nix flake update` | update everything, or one input |
| `mcli diff` | `nvd diff` previous vs current | what did the last switch change? |
| `mcli rollback` | `… switch --rollback` | the last switch broke something |
| `mcli generations` | list system generations | |
| `mcli clean [days]` | `nix-collect-garbage --delete-older-than` | free disk space (default 7 days) |
| `mcli fmt` | `nix fmt` (alejandra) | tidy every `.nix` file |
| `mcli repl` | `nix repl` with the flake loaded | explore values |
| `mcli hosts` | list machines in the flake | |
| `mcli deploy <host> <user@ip>` | `nix run github:nix-community/nixos-anywhere -- --flake …` | first install onto a remote machine (formats its disk with Disko) |
| `mcli push <host> <user@ip>` | `nixos-rebuild switch --target-host … --sudo` | update a remote machine (the Pi) from here |
| `mcli book` | serve this book locally | |
| `mcli epub` | rebuild `docs/MercLab-Book.epub` (pandoc) | after editing the book |
| `mcli edit` | open the repo in `$EDITOR` | |

## Extending it

It's yours to tinker with. Add a `case` branch in `installer/mcli.sh`, run
`mcli switch` (mcli itself is rebuilt), done. See [Bash](../learn/bash.md).
