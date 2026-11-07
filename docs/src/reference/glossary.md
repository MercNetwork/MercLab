# Glossary

| Term | Meaning |
|------|---------|
| **attribute set** | Nix's key–value map: `{ a = 1; }` |
| **closure** | a package plus everything it depends on |
| **derivation** | a build recipe; building it produces a store path |
| **Disko** | declares partitions/filesystems in Nix; used by the installer |
| **flake** | a repo with `flake.nix`: pinned inputs + outputs |
| **flake.lock** | exact versions of all inputs |
| **generation** | one built system; you can boot/roll back to any kept generation |
| **Home Manager** | manages user-level packages and dotfiles with Nix |
| **host** | one machine (`desktop`, `laptop`, `mac`) |
| **impermanence** | resetting `/` on each boot, keeping only declared state |
| **input** | an external flake this one depends on |
| **LSP** | Language Server Protocol — the program that gives an editor completion, errors and go-to-definition |
| **module** | a Nix file that declares and/or sets options |
| **nix-darwin** | NixOS-style configuration for macOS |
| **nixpkgs** | the package collection (and NixOS itself) |
| **option** | a typed setting, e.g. `mercury.hardware.bluetooth.enable` |
| **overlay** | a function that adds/changes packages in `pkgs` |
| **profile** (Mercury) | a Home Manager file listing your enabled user toggles (`home/users/mercury/*.nix`) |
| **PRIME offload** | hybrid-GPU mode: Intel drives the screen, NVIDIA runs chosen apps |
| **scratchpad** | Hyprland special workspace that slides over the current one |
| **sops / age** | file encryption used for secrets in the repo |
| **stateVersion** | release a machine was first installed with; don't change it |
| **store** | `/nix/store`, where every package lives, read-only |
| **UWSM** | session manager that starts Hyprland as a systemd session |
| **Wayle** | the bar/notification/OSD shell |
