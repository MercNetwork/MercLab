# Updating

## Routine updates (every week or two)

```bash
cd ~/MercLab
mcli update          # newest commits on each input's branch
mcli build           # review nvd output: kernel? big jumps?
mcli switch
git commit -am "flake: update inputs" && git push
```

Then on each other machine: `git pull && mcli switch`.

Updating stays within the release branch (`nixos-26.05`), so these are security
and bug fixes, not big version jumps. Moving to the next release is a separate,
deliberate step: [Upgrading NixOS releases](../maintain/release-upgrade.md).

## Updating only one thing

```bash
mcli update nixpkgs         # just packages
mcli update home-manager
```

## If an update breaks something

1. `mcli rollback` — you're back on the previous generation immediately.
2. `git restore flake.lock` (not yet committed) or
   `git checkout HEAD~1 -- flake.lock` (already committed).
3. Wait a few days and try again, or update everything *except* the culprit:
   `mcli update nixpkgs home-manager` (list the inputs you want).

## What auto-upgrade would do

`mercury.system.autoUpgrade.enable` (off) rebuilds nightly from GitHub. Because
MercLab is private, the machine needs a read-only deploy key first. For a
solo-maintained setup, manual updates are recommended — you see every change.
