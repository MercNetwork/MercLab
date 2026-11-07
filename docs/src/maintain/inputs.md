# Flake inputs inventory

Every external source MercLab pulls from, why, and how to drop it. Dropping an
input means: delete it from `flake.nix`, delete every file that references it
(`grep -rn "inputs.<name>" .`), `mcli check`.

| Input | Provides | Used by | Can drop? |
|-------|----------|---------|-----------|
| `nixpkgs` (nixos-26.05) | all packages, NixOS | everything | no |
| `nixpkgs-unstable` | `pkgs.unstable` overlay | optional newer packages | yes — remove overlay in `lib/helpers` |
| `nixpkgs-darwin` | packages for macOS | Mac | only if no Mac |
| `home-manager` | user configuration | everything | no |
| `nix-darwin` | macOS system config | Mac | only if no Mac |
| `disko` | declarative partitioning | installer, hosts/*/disko.nix | not without redoing install |
| `impermanence` | wipe-on-boot support | `modules/storage/impermanence.nix` | yes, if you never use it |
| `sops-nix` | encrypted secrets | `modules/security/sops_nix.nix`, `home/…/sops.nix` | yes, if no secrets |
| `nixos-raspberrypi` (commented out) | Pi 5 kernel, firmware, bootloader | `piserver` | yes — it's off until you uncomment it |
| `autofirma-nix` | AutoFirma (Spanish e-signature) | `home/…/office/tools/autofirma.nix` | yes |
| `flox` | Flox CLI | `home/…/ai/flox.nix`; also adds a binary cache in `hosts/base.nix` | yes |
| `nix-flatpak` | declarative Flatpak | `modules/virtualization/flatpak.nix` | yes |
| `compose2nix` | docker-compose → Nix | `modules/virtualization/compose2nix.nix` | yes |
| `microvm` | lightweight VMs | `modules/virtualization/microvm.nix` | yes |
| `iio-hyprland` | screen auto-rotation | Hyprland `autoRotate` option | yes |
| `mnw` | Neovim wrapper | `home/…/editors/nvim.nix` | not without rewriting nvim module |
| `antigravity-nix` | Google Antigravity | `home/…/ai/antigravity.nix` | yes |
| `zen-browser` | Zen browser | `home/…/browsers/zen.nix` | yes |
| `spicetify-nix` | themed Spotify | `home/…/audio/spotify.nix` | yes — switch module to `pkgs.spotify` |

All other software comes from nixpkgs. Wayle, for example, is
`pkgs.wayle` plus Home Manager's `services.wayle` — no input needed.

## Health check

If an input's repository becomes unmaintained, its pinned version keeps working
until it conflicts with a newer nixpkgs. That's your cue to drop it or replace
it with the nixpkgs package.
