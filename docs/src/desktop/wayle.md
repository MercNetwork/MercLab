# Wayle shell

Wayle (<https://wayle.app>) provides the top bar, notification centre,
on-screen display for volume/brightness, and an optional wallpaper engine. It's
written in Rust/GTK4, packaged in nixpkgs, and configured through Home
Manager's `services.wayle` — so there's no extra flake input to maintain.

## Where it's configured

`home/desktop/wms/hyprland.nix` sets Mercury's defaults:

```nix
services.wayle.settings = {
  bar.layout = [{
    monitor = "*";
    left   = [ "dashboard" "hyprland-workspaces" "window-title" ];
    center = [ "clock" "media" ];
    right  = [ "systray" "volume" "network" "bluetooth" "battery" "notifications" "power" ];
  }];
  modules.clock.format = "%a %d %b  %H:%M";
};
```

Change or extend it **from your profile** (no need to edit the module) —
anything here is merged over the defaults:

```nix
# home/users/mercury/linux.nix
mercury.home.desktop.wms.hyprland.wayle.settings = {
  bar.location = "top";
  modules.weather = { location = "Denver"; units = "imperial"; };
  bar.layout = [{
    monitor = "*";
    left = [ "dashboard" "hyprland-workspaces" ];
    center = [ "clock" "weather" ];
    right = [ "cpu" "ram" "volume" "network" "battery" "notifications" "power" ];
  }];
};
```

Every module and field is documented at <https://wayle.app/config>.
Available bar modules include: battery, bluetooth, brightness, cava, clock,
cpu, custom, dashboard, hyprland-workspaces, hyprsunset, idle-inhibit,
keyboard-input, media, microphone, netstat, network, notifications, power,
ram, separator, storage, systray, volume, weather, window-title, world-clock.

## Using the settings GUI, then making it permanent

```bash
wayle panel settings
```

Changes apply live and are saved to `~/.config/wayle/runtime.toml`. To keep
them, convert to Nix and paste into `wayle.settings`:

```bash
cd ~/.config/wayle
nix-instantiate --eval --expr 'builtins.fromTOML (builtins.readFile ./runtime.toml)' | nix run nixpkgs#nixfmt
```

## Wallpapers

```nix
mercury.home.desktop.wms.hyprland.wayle.settings.wallpaper = {
  engine-enabled = true;
  cycling-directory = "/home/mercury/Pictures/Wallpapers";
  cycling-mode = "shuffle";
};
```

## Commands

| Command | Does |
|---------|------|
| `wayle panel restart` | restart (also `CTRL+SUPER+ALT+R`) |
| `wayle config get bar.scale` / `set …` | read/change a value live |
| `wayle audio output-volume +5` | volume |
| `wayle idle toggle` | stop the screen locking |
| `systemctl --user status wayle` | is it running? |
| `journalctl --user -u wayle -b` | its log |

(The service name may differ slightly by Home Manager version — `systemctl --user list-units | grep -i wayle` finds it.)
