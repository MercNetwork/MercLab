# Nix 5: Packages, scripts and overlays

## Installing a package

Almost always just a name from <https://search.nixos.org/packages>:

```nix
home.packages = [ pkgs.htop ];                 # user-level (Home Manager)
environment.systemPackages = [ pkgs.htop ];    # system-wide (NixOS)
```

Unfree packages (Steam, Discord, Spotify, NVIDIA) are allowed in `mkSystem`.

## Writing a script as a package

Mercury's helper commands are made with `writeShellApplication`, which also
runs **shellcheck** on the script at build time:

```nix
let
  hello = pkgs.writeShellApplication {
    name = "hello-mercury";
    runtimeInputs = [ pkgs.libnotify ];     # put these on the script's PATH
    text = ''
      notify-send "Hello" "from $(hostname)"
    '';
  };
in {
  home.packages = [ hello ];
}
```

See `home/desktop/wms/hyprland.nix` for four real ones
(`mercury-powermenu`, `-screenshot`, `-record`, `-clipboard`).

## Changing an existing package

```nix
# Change build inputs/flags
pkgs.sddm-astronaut.override { embeddedTheme = "astronaut"; }

# Change the derivation itself (version, patches, src)
pkgs.foo.overrideAttrs (old: {
  patches = (old.patches or []) ++ [ ./fix.patch ];
})
```

## Overlays: changing a package everywhere

An overlay is a function `final: prev: { … }` that adds or replaces packages
in `pkgs`. Mercury already has one — it adds `pkgs.unstable`:

```nix
unstableOverlay = final: prev: {
  unstable = import inputs.nixpkgs-unstable { inherit (prev.stdenv.hostPlatform) system; config.allowUnfree = true; };
};
```

To pin something everywhere, add another overlay in `lib/helpers/default.nix`:

```nix
(final: prev: { btop = prev.unstable.btop; })
```

## Packages from other flakes

```nix
inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
```

`${pkgs.stdenv.hostPlatform.system}` is `"x86_64-linux"`, `"aarch64-darwin"`, etc.

## Exercises

1. Add `pkgs.cowsay` to `home/users/mercury/common.nix`, `mcli switch`, run
   `cowsay hi`, then remove it and switch again.
2. Write a `writeShellApplication` called `mlog` that runs
   `git -C ~/MercLab log --oneline -10`, add it to your profile, try it.
3. Use `mcli build` to compare closure changes (`nvd` output) after adding a
   large package like `pkgs.blender`.
