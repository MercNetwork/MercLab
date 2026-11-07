#!/usr/bin/env bash
set -euo pipefail

# mcli — day-to-day helper for the MercLab flake. Works on NixOS and macOS.
# Every command prints the real command it runs, so you can always do it by hand.

FLAKE="${MERCURY_FLAKE:-$HOME/MercLab}"
OS="$(uname -s)"
HOST="${MERCURY_HOST:-$(hostname -s 2>/dev/null || hostname)}"

run() {
  printf '\033[1;34m$ %s\033[0m\n' "$*"
  "$@"
}

rebuild() {
  local action="$1"; shift
  if [ "${OS}" = "Darwin" ]; then
    run sudo darwin-rebuild "${action}" --flake "${FLAKE}#${HOST}" "$@"
  else
    run sudo nixos-rebuild "${action}" --flake "${FLAKE}#${HOST}" "$@"
  fi
}

usage() {
  cat <<USAGE
mcli — MercLab helper   (flake: ${FLAKE}, host: ${HOST})

  switch            build and activate now (also makes it the boot default)
  boot              build and activate on next boot only            [NixOS]
  test              activate now, but don't touch the boot menu      [NixOS]
  build             build only; then show what would change (nvd)
  check             nix flake check (evaluates every machine)
  update [input]    update all flake inputs, or just one (e.g. nixpkgs)
  diff              compare the running system with the previous generation
  rollback          switch back to the previous generation
  generations       list system generations
  clean [days]      delete generations older than N days (default 7) and GC
  fmt               format all .nix files (alejandra)
  repl              nix repl with this flake loaded
  hosts             list machines defined in the flake
  deploy <host> <user@ip>   first install onto a remote machine (nixos-anywhere + Disko)
  push <host> <user@ip>     apply a config to a remote machine over SSH
  book              open the MercLab book (docs) in a browser
  epub              rebuild docs/MercLab-Book.epub (for phones / e-readers)
  edit              open the repo in \$EDITOR

Environment: MERCURY_FLAKE (repo path), MERCURY_HOST (override hostname)
USAGE
}

cmd="${1:-help}"
shift || true

case "${cmd}" in
  switch)       rebuild switch "$@" ;;
  boot)         rebuild boot "$@" ;;
  test)         rebuild test "$@" ;;
  build)
    if [ "${OS}" = "Darwin" ]; then
      run nix build "${FLAKE}#darwinConfigurations.${HOST}.system" --out-link /tmp/mercury-build "$@"
    else
      run nix build "${FLAKE}#nixosConfigurations.${HOST}.config.system.build.toplevel" --out-link /tmp/mercury-build "$@"
    fi
    run nvd diff /run/current-system /tmp/mercury-build ;;
  check)        run nix flake check "${FLAKE}" "$@" ;;
  update)
    if [ $# -gt 0 ]; then run nix flake update "$@" --flake "${FLAKE}"; else run nix flake update --flake "${FLAKE}"; fi ;;
  diff)
    prev="$(find /nix/var/nix/profiles -maxdepth 1 -name 'system-*-link' | sort -t- -k2 -n | tail -2 | head -1)"
    run nvd diff "${prev}" /run/current-system ;;
  rollback)     rebuild switch --rollback ;;
  generations)
    if [ "${OS}" = "Darwin" ]; then run sudo darwin-rebuild --list-generations;
    else run sudo nix-env --list-generations --profile /nix/var/nix/profiles/system; fi ;;
  clean)
    days="${1:-7}"
    run sudo nix-collect-garbage --delete-older-than "${days}d"
    run nix-collect-garbage --delete-older-than "${days}d" ;;
  fmt)          run nix fmt "${FLAKE}" ;;
  repl)         run nix repl --impure --expr "builtins.getFlake \"git+file://${FLAKE}\"" ;;
  hosts)
    echo "NixOS:";  nix eval --json "${FLAKE}#nixosConfigurations" --apply builtins.attrNames 2>/dev/null || true
    echo "Darwin:"; nix eval --json "${FLAKE}#darwinConfigurations" --apply builtins.attrNames 2>/dev/null || true ;;
  deploy)
    [ $# -ge 2 ] || { echo "usage: mcli deploy <host> <user@ip>" >&2; exit 1; }
    echo "This ERASES the target disk declared in hosts/$1/disko.nix on $2."
    read -r -p "Type the host name ($1) to continue: " confirm
    [ "${confirm}" = "$1" ] || exit 0
    run nix run github:nix-community/nixos-anywhere -- --flake "${FLAKE}#$1" "$2" ;;
  push)
    [ $# -ge 2 ] || { echo "usage: mcli push <host> <user@ip>" >&2; exit 1; }
    run nixos-rebuild switch --flake "${FLAKE}#$1" --target-host "$2" --sudo --ask-sudo-password ;;
  book)         run nix run "${FLAKE}#book" ;;
  epub)         run env MERCURY_FLAKE="${FLAKE}" nix run "${FLAKE}#epub" ;;
  edit)         cd "${FLAKE}" && exec "${EDITOR:-nvim}" . ;;
  help|-h|--help) usage ;;
  *) echo "Unknown command: ${cmd}" >&2; usage; exit 1 ;;
esac
