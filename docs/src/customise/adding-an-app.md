# Adding an app

## Option 1: just add the package

For a one-off, add it to your profile:

```nix
# home/users/mercury/linux.nix
{ pkgs, ... }: {
  imports = [ ./common.nix ];
  home.packages = [ pkgs.vlc ];
  # …
}
```

(Add `pkgs` to the file's `{ … }:` arguments.)

## Option 2: make it a toggle (recommended for anything you might reuse)

Create `home/applications/media/video/vlc.nix`:

```nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mercury.home.apps.media.video.vlc;
in {
  options.mercury.home.apps.media.video.vlc.enable = lib.mkEnableOption "VLC media player";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.vlc ];
  };
}
```

Then:

```bash
git add home/applications/media/video/vlc.nix     # new file → git add!
```

```nix
# home/users/mercury/linux.nix
media.video.vlc.enable = true;
```

No import list to edit — `home/home.nix` picks up every file automatically.
Keep the option path matching the folder path; that's how you find things later.

## When the app has a Home Manager module

Many apps have `programs.<name>` options in Home Manager that manage their
config too. Prefer those:

```nix
config = lib.mkIf cfg.enable {
  programs.btop = {
    enable = true;
    settings.color_theme = "TTY";
  };
};
```

Search them at <https://home-manager-options.extranix.com>.

## When the app needs system-level setup

Steam, Docker, VirtualBox and anything needing a service, kernel module or
firewall port are **NixOS** modules (`modules/…`, options `mercury.*`) enabled
in the host file. See [Writing a system module](system-module.md).

## When the app needs a live config file

Copy the pattern from `home/applications/system/shell/zsh.nix`: put the files
in `home/configs/<app>/`, then

```nix
xdg.configFile."<app>".source =
  if cfg.configsPath != null
  then config.lib.file.mkOutOfStoreSymlink "${cfg.configsPath}/<app>"
  else "${inputs.self}/home/configs/<app>";
```
