# Nix 6: Reading errors and debugging

## Read errors bottom-up

Nix errors are long. The useful part is usually:

1. The **last** `error:` line — what went wrong.
2. The **first** `at /…/MercLab/<file>:<line>` that points into *your* repo.

Add `--show-trace` for the full chain: `mcli switch --show-trace`.

## Errors you will see

| Message | Meaning | Fix |
|---------|---------|-----|
| `path '…' does not exist` | new file not tracked by git | `git add` it |
| `The option 'mercury.x.y' does not exist` | typo, or the module file is missing | check spelling against the [module index](../reference/modules.md) |
| `The option '…' has conflicting definition values` | two places set one value | `lib.mkForce` one, or remove one |
| `infinite recursion encountered` | an option's value depends on itself (often `imports` using `config`) | don't use `config` inside `imports` or an `mkIf` that controls its own option |
| `attribute 'foo' missing` | package/attribute renamed or removed | search.nixos.org for the new name |
| `undefined variable 'lib'` | missing function argument | add `lib` to the `{ … }:` at the top of the file |
| `error: … is marked as broken` / `insecure` | nixpkgs flagged it | update, pin from `pkgs.unstable`, or allow per package |
| `hash mismatch` | a fixed-output download changed | update the hash Nix prints as "got:" |

## The REPL

```bash
mcli repl
```

```nix
nix-repl> nixosConfigurations.laptop.config.networking.hostName
"laptop"
nix-repl> :p nixosConfigurations.laptop.config.mercury.hardware.gpu
nix-repl> nlib = inputs.nixpkgs.lib
nix-repl> :doc nlib.mkIf
nix-repl> :q
```

`:p` prints deeply, `:t` shows a type, `:?` lists commands.

## Printing from inside a module

```nix
config = lib.traceSeq cfg (lib.mkIf cfg.enable { … });   # prints cfg, then continues
```

or `builtins.trace "got here" value`. Remove before committing.

## Build vs. runtime problems

- **Fails to build** → a Nix problem; this chapter.
- **Builds but misbehaves** → a runtime problem: `journalctl -b -p err`,
  `systemctl --failed`, `systemctl --user status wayle`, Hyprland's log at
  `$XDG_RUNTIME_DIR/hypr/*/hyprland.log`. See
  [Troubleshooting](../maintain/troubleshooting.md).

## Exercises

1. Misspell `mercury.hardware.bluetooth` in a host as `bluetoth`, build, read
   the error, fix it.
2. In `mcli repl`, find the list of language servers enabled for `desktop`:
   `nixosConfigurations.desktop.config.home-manager.users.mercury.mercury.home.apps.development.langs`
