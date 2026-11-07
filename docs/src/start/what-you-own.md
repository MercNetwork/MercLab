# What you own

You are the only maintainer of MercLab. That has three practical consequences.

**1. Nothing changes unless you change it.** Every package version is pinned in
`flake.lock`. A machine built today and the same machine rebuilt next year from
the same commit are identical. Updates happen only when you run `mcli update`.

**2. Every line is yours to delete.** Mercury ships about 210 modules, and almost
all of them do nothing until a host or profile turns them on. You do not need to
understand a module you never enable. When you want to simplify, deleting an
unused module file is safe: imports are automatic (see
[architecture](architecture.md)), so nothing else references it by path —
unless a host or profile enables its option, in which case evaluation tells you
exactly where.

**3. The upstream you still rely on is the Nix community, not a person.**
nixpkgs (the package collection), Home Manager, nix-darwin and a few smaller
flakes. They are large, long-lived projects with release branches. You choose
when to move to a new release (twice a year, see
[Upgrading NixOS releases](../maintain/release-upgrade.md)).

## The three layers

| Layer | Lives in | Controls | Applied by |
|-------|----------|----------|------------|
| System (NixOS) | `modules/`, `hosts/<name>/` | boot, disks, drivers, services, users | `mcli switch` on Linux |
| System (macOS) | `darwin/`, `hosts/mac/` | macOS defaults, Homebrew, Nix itself | `mcli switch` on the Mac |
| User (Home Manager) | `home/`, `home/users/mercury/` | your apps, shell, dotfiles, desktop | the same `mcli switch` |

Home Manager runs *inside* the system build, so one command updates everything.

## What a "configuration" is

A machine's whole state is described by `hosts/<name>/configuration.nix` plus
everything it switches on. Building it produces a *generation*: a complete,
read-only system in `/nix/store`. Switching makes it the running system and adds
it to the boot menu. Old generations stay until garbage-collected, so any change
can be undone by booting the previous one. That safety net is why you can
experiment freely.
