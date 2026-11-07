# Look and feel

## Display scale (size of everything)

Mercury renders at **100%** by default: Hyprland uses a fixed scale of `1`
(never `auto`, which is what makes Hyprland look huge on other setups), X11
apps render at native resolution, Qt's automatic DPI scaling is off, and the
login screen doesn't upscale.

One option changes the whole desktop — Hyprland and the Wayle bar together:

```nix
# home/users/mercury/linux.nix (all Linux machines)
mercury.home.desktop.wms.hyprland.scale = 1.25;
```

For one machine only, put it in that host's profile list, like the laptop's
idle settings:

```nix
profile = [
  ../../home/users/mercury/linux.nix
  { mercury.home.desktop.wms.hyprland.scale = 1.25; }
];
```

Good values: `1`, `1.25`, `1.5`, `2`. Odd values like `1.33` can cause blurry
edges; Hyprland warns about them.

**Try a scale live, without rebuilding:** add to
`home/configs/hypr/user/vars.lua`

```lua
return { monitorScale = 1.25 }
```

and save — Hyprland reloads. Once happy, move the value to the Nix option and
empty `user/vars.lua` again.

**Different monitors, different scales:** add per-monitor lines to
`home/configs/hypr/user/config.lua` (names from `hyprctl monitors`):

```lua
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0",    scale = 1.25 })
hl.monitor({ output = "DP-1",  mode = "preferred", position = "1536x0", scale = 1 })
```

Text-only tweaks, if apps are the right size but fonts aren't: kitty's font
size in `home/applications/system/shell/kitty.nix`, GTK font in
`home/environment/gtk.nix`.

## Where everything else lives

| Thing | Where | Rebuild? |
|-------|-------|----------|
| Window colours, borders, shadows | `home/configs/hypr/scheme/current.lua`, `variables.lua` | no — `hyprctl reload` |
| Gaps, rounding, blur, opacity | `home/configs/hypr/variables.lua` | no |
| Bar colours | `wayle.settings.styling` (see <https://wayle.app/guide/themes>) | yes |
| GTK/Qt theme, icons, cursor | `home/environment/gtk.nix` | yes |
| Fonts | `home/environment/fonts.nix`, `modules/personalization/fonts.nix` | yes |
| Terminal | `home/applications/system/shell/kitty.nix` | yes |
| Login screen | `mercury.desktop.dms.sddm.theme` (sddm-astronaut variants) | yes |
| Lock screen | `programs.hyprlock.settings` in `home/desktop/wms/hyprland.nix` | yes |

## The colour scheme

`scheme/current.lua` holds Material-You style tokens (`primary`, `surface`,
`onSurface`, …) used by `variables.lua` for borders and shadows. Replace the hex
values to retheme Hyprland. Keep `scheme/default.lua` as a reference copy.

To make Wayle match, give it a palette, or let Wayle generate one from your
wallpaper:

```nix
wayle.settings.styling = {
  theme-provider = "matugen";     # or "wallust", "pywal"; installed automatically
};
```

## Cursor

The cursor is **Bibata-Modern-Classic, size 24** in three places that must
agree: `home/environment/gtk.nix` (`home.pointerCursor`),
`home/configs/hypr/variables.lua` (`cursorTheme`, `cursorSize`) and the SDDM
module. Change all three together.
