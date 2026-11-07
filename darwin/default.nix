# Mercury for nix-darwin (macOS). Mirrors the NixOS side: every file in
# ./modules declares `mercury.*` options that hosts switch on.
{getFiles, ...}: {
  imports = getFiles ./modules;
}
