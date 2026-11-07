# Upgrading NixOS releases

NixOS releases twice a year: **YY.05** (May) and **YY.11** (November). Each is
supported for about seven months, so you have a month of overlap to move.
MercLab is on **26.05**; next is **26.11**.

## Steps

1. Read the release notes (NixOS manual → Release Notes) for
   "Backward Incompatibilities". Also skim Home Manager's and nix-darwin's.
2. On a branch, change the release in `flake.nix`:
   ```nix
   nixpkgs.url        = "github:nixos/nixpkgs/nixos-26.11";
   nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.11-darwin";
   home-manager.url   = "github:nix-community/home-manager/release-26.11";
   nix-darwin.url     = "github:nix-darwin/nix-darwin/nix-darwin-26.11";
   ```
3. `mcli update` then `mcli check`. Fix each error (renamed options and
   packages are the usual ones — the error usually names the replacement).
4. `mcli build`, `mcli switch` on one machine, use it for a day.
5. Merge, push, switch the other machines.

## `stateVersion` — don't change it

`stateVersion = "26.05"` in `flake.nix` records the release each machine was
*first installed* with, so services keep their on-disk data formats. It is
**not** the version you're running. Leave it at 26.05 forever for existing
machines. (If you ever want new machines to start at a later default, make it
a per-host value — but nothing requires that.) The Mac's
`system.stateVersion = 6` is the same idea for nix-darwin.

## macOS note

Nixpkgs 26.05 is the last release supporting Intel Macs; Apple Silicon is
unaffected.
