# Making a change

Every change follows the same loop.

```text
edit  →  mcli build  →  mcli switch  →  use it  →  git commit + push
              │               │
              └ fails? read the error (Nix 6)   └ broken? mcli rollback
```

## Worked example: add an app for yourself

1. Find its toggle in the [module index](../reference/modules.md) — say
   `mercury.home.apps.office.docs.obsidian`.
2. Enable it in the right profile. Everywhere → `home/users/mercury/common.nix`;
   Linux only → `linux.nix`:
   ```nix
   office.docs.obsidian.enable = true;
   ```
3. `mcli build` — read the `nvd` summary.
4. `mcli switch`.
5. `git commit -am "home: add obsidian" && git push`.

No toggle exists? Add the package directly to the profile
(`home.packages = [ pkgs.foo ];`) or [write a module](../customise/adding-an-app.md).

## Worked example: a machine setting

Printing on the laptop only → `hosts/laptop/configuration.nix`:

```nix
mercury.hardware.printing.enable = true;
```

## Where does a change go?

| Scope | File |
|-------|------|
| me, every machine | `home/users/mercury/common.nix` |
| me, Linux machines | `home/users/mercury/linux.nix` |
| me, Mac | `home/users/mercury/darwin.nix` |
| me, one machine only | the host's `profile = [ … { … } ];` list (see laptop's idle settings) |
| one machine's system | `hosts/<name>/configuration.nix` |
| every NixOS machine | `hosts/base.nix` |
| live config (no rebuild) | `home/configs/…` |

## Keep machines in sync

Push from where you edited; on the others `git pull && mcli switch`. Run
`mcli check` before pushing — it catches breakage on machines you aren't
sitting at (including the Mac, from Linux, as far as evaluation goes).
