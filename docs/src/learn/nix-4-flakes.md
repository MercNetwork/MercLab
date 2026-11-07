# Nix 4: Flakes, inputs and the lock file

## A flake is a folder with `flake.nix`

```nix
{
  description = "…";
  inputs = { /* where code comes from */ };
  outputs = inputs: { /* what this repo provides */ };
}
```

### Inputs

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";      # a branch
  home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";   # use OUR nixpkgs, not its own copy
  };
};
```

`follows` keeps one copy of nixpkgs instead of several — smaller downloads,
fewer surprises. Add it whenever an input has its own `nixpkgs`.

### The lock file

`flake.lock` records the exact git commit of every input. **Commit it.** It's
what makes builds reproducible.

| Command | Effect |
|---------|--------|
| `mcli update` | move every input to the newest commit on its branch |
| `mcli update nixpkgs` | move just one input |
| `git checkout flake.lock` | undo an update you haven't committed |

### Outputs

MercLab's outputs (see `flake.nix`):

| Output | Used by |
|--------|---------|
| `nixosConfigurations.<host>` | `nixos-rebuild --flake .#<host>` |
| `darwinConfigurations.mac` | `darwin-rebuild --flake .#mac` |
| `packages.<system>.mcli` etc. | `nix build .#mcli`, `nix run .#install` |
| `apps.<system>.install/recover/book` | `nix run .#install` |
| `devShells.<system>.default` | `nix develop` (alejandra, nixd, sops…) |
| `formatter.<system>` | `nix fmt` |

Run `nix flake show` to see them all.

## Flake references you'll type

```text
.#desktop                         this repo, output "desktop"
~/MercLab#laptop                  same, by path
github:owner/repo                 a GitHub flake
nixpkgs#ripgrep                   a package from the registry's nixpkgs
```

Try a package without installing it: `nix run nixpkgs#cowsay -- hi` or
`nix shell nixpkgs#htop`.

## The git rule (again)

Flakes copy only **git-tracked** files into the build. New file? `git add` it.
Uncommitted *changes* to tracked files are fine (you'll see "dirty tree").

## Exercises

1. Run `nix flake metadata ~/MercLab` and find the locked nixpkgs revision.
2. Run `nix flake show` and find the `book` app.
3. `mcli update spicetify-nix`, then `git diff flake.lock`. Undo with
   `git checkout flake.lock`.
