# Bash

Bash is your shell's scripting language (your interactive shell is zsh, which
understands the same syntax for everything here). In MercLab it appears in
`installer/*.sh` (mcli, installer, recovery) and inside `writeShellApplication`
blocks in modules.

## A safe script skeleton

```bash
#!/usr/bin/env bash
set -euo pipefail      # stop on errors, unset variables, and failed pipes

name="${1:-world}"     # first argument, default "world"
echo "hello ${name}"
```

## Essentials

```bash
x="value"                 # no spaces around =
echo "$x"                 # ALWAYS quote variables
today="$(date +%F)"       # command substitution
echo "${HOME}/MercLab"    # braces when text follows

if [ -f ~/.zshrc ]; then echo "exists"; fi
[ -d "$dir" ] || mkdir -p "$dir"     # do the right side if the left fails

case "$1" in
  start) echo "starting" ;;
  stop)  echo "stopping" ;;
  *)     echo "usage: $0 start|stop" >&2; exit 1 ;;
esac

for f in *.nix; do echo "$f"; done

greet() { echo "hi $1"; }
greet mercury

cmd1 | cmd2               # pipe output into the next command
cmd > file                # write output; >> appends; 2> redirects errors
```

Exit codes: `0` = success, anything else = failure. `$?` holds the last one.

## Reading mcli

`installer/mcli.sh` is ~100 lines and uses only the above. The `run` function
prints each real command before running it, so mcli doubles as a cheat sheet —
watch what it prints and you learn the underlying `nixos-rebuild`/`nix` commands.

## Bash inside Nix strings

Inside `'' … ''` Nix strings, `${…}` is **Nix** interpolation. For a Bash
`${VAR}` write `''${VAR}`; plain `$VAR` needs no escaping:

```nix
text = ''
  dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}"
  echo "${pkgs.hello}/bin/hello"      # Nix inserts the store path here
'';
```

## Commands you'll use when troubleshooting

| Command | Shows |
|---------|-------|
| `journalctl -b -p err` | errors since boot |
| `journalctl --user -u wayle -f` | follow a user service log |
| `systemctl --failed` / `systemctl --user --failed` | failed services |
| `which -a nvim` / `readlink -f $(which nvim)` | where a program comes from |
| `rg pattern` / `fd name` | search text / files |
| `lsblk`, `lspci`, `ip a`, `nmcli` | disks, PCI devices, network |

## Exercises

1. Add `mcli hello` to `installer/mcli.sh` that prints the host and flake
   path. Rebuild and try it.
2. Write `home/configs/zsh.d/conf.d/aliases.zsh` with
   `alias ml='cd ~/MercLab'`. Open a new terminal — no rebuild needed.
