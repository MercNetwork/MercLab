# Hyprland and keybinds

Hyprland is the window manager; [Wayle](wayle.md) draws the bar,
notifications and on-screen displays around it. Windows tile automatically
(dwindle layout): each new window splits the focused one.

## Workspaces

| Keys | Action |
|------|--------|
| `SUPER + 1…0` | go to workspace 1–10 |
| `SUPER + ALT + 1…0` | move window to workspace 1–10 |
| `CTRL + SUPER + 1…0` | go to workspace group (11–20, 21–30, …) |
| `SUPER + arrows` | focus left/right/up/down |
| `SUPER + SHIFT + arrows` | move window left/right/up/down |
| 4-finger swipe | switch workspace (touchpad) |
| 3-finger swipe up/down | toggle scratchpad |

## Every other keybind

Generated from `home/configs/hypr/variables.lua` — change keys there (or
override them in `user/vars.lua`).

| Action | Keys | Variable |
|--------|------|----------|
| Send window to scratchpad | `SUPER + ALT + S` · `CTRL + SUPER + SHIFT + Up` | `kbMoveWinToWsSpecial` |
| Move window to next workspace | `SUPER + ALT + mouse_down` · `SUPER + ALT + Page_Down` · `CTRL + SUPER + SHIFT + Right` | `kbMoveWinToWsNext` |
| Next workspace | `SUPER + mouse_down` · `CTRL + SUPER + Right` · `SUPER + Page_Down` | `kbNextWs` |
| Next group of 10 workspaces | `CTRL + SUPER + mouse_down` | `kbNextWsGroup` |
| Next window | `ALT + TAB` | `kbWindowCycleNext` |
| Next tab in group | `CTRL + ALT + TAB` | `kbWindowGroupCycleNext` |
| Move window out of group | `SUPER + U` | `kbUngroup` |
| Lock group | `SUPER + SHIFT + Comma` | `kbGroupLockActive` |
| Narrower | `SUPER + Minus` · `SUPER + ALT + Left` | `kbWindowDecreaseWidth` |
| Shorter | `SUPER + SHIFT + Minus` · `SUPER + ALT + Up` | `kbWindowDecreaseHeight` |
| Drag to move (also SUPER + left mouse) | `SUPER + Z` | `kbMoveWindow` |
| Center floating window | `CTRL + SUPER + Backslash` | `kbCenterWindow` |
| Picture-in-picture | `SUPER + ALT + Backslash` | `kbWindowPip` |
| Fullscreen | `SUPER + F` | `kbWindowFullscreen` |
| Toggle floating | `SUPER + ALT + Space` | `kbToggleWindowFloating` |
| Toggle scratchpad | `SUPER + S` | `kbSpecialWs` |
| Music scratchpad (Spotify) | `SUPER + M` | `kbMusicWs` |
| To-do scratchpad | `SUPER + R` | `kbTodoWs` |
| Terminal (kitty) | `SUPER + T` | `kbTerminal` |
| Editor (Neovim in kitty) | `SUPER + C` | `kbEditor` |
| Audio mixer (pwvucontrol) | `CTRL + ALT + V` | `kbAudioSettings` |
| Screenshot whole screen (saved + copied) | `Print` | `kbScreenshot` |
| Screenshot region → file + clipboard | `SUPER + SHIFT + ALT + S` | `kbScreenshotRegionSave` |
| Record screen with audio | `SUPER + ALT + R` | `kbRecordSound` |
| Colour picker | `SUPER + SHIFT + C` | `kbColorPicker` |
| Play/pause | `CTRL + SUPER + Space` | `kbMediaToggle` |
| Previous track | `CTRL + SUPER + Minus` | `kbMediaPrev` |
| Mute | `SUPER + SHIFT + M` | `kbVolumeMute` |
| App launcher (fuzzel) — tap SUPER | `SUPER + SUPER_L` | `kbLauncher` |
| Restart the Wayle bar | `CTRL + SUPER + ALT + R` | `kbRestartShell` |
| Suspend | `SUPER + SHIFT + L` | `kbSleep` |
| Clipboard history | `SUPER + V` | `kbClipboard` |
| Volume up/down, brightness, media keys | the keyboard's media keys | — |

## Scratchpads

A scratchpad is a hidden workspace that slides over the current one. Mercury
has five: a general one (`SUPER+S`), and system monitor, music, chat and to-do.
Pressing the key opens it, launches its app if needed (btop, Spotify,
Discord), and pulls in matching windows. Press again to hide.

Customise per machine without editing the code: create
`home/configs/hypr/user/scratchpads.json`:

```json
{ "toggles": { "todo": { "obsidian": { "enable": true, "match": [{ "class": "obsidian" }], "command": ["obsidian"], "move": true } } } }
```

## Changing a default app

1. Set it in `variables.lua` (`terminal`, `browser`, `editor`, `fileExplorer`,
   `audioSettings`) or in `user/vars.lua`.
2. Make sure it's installed: enable its toggle in `home/users/mercury/linux.nix`.
3. Update the matching file association in `home/environment/xdg.nix` if it
   handles file types.

## Helper commands behind the keybinds

All defined in `home/desktop/wms/hyprland.nix`, usable from a terminal too:
`mercury-powermenu`, `mercury-screenshot [full|region|region-save]`,
`mercury-record [screen|sound|region]`, `mercury-clipboard [pick|delete]`.
Screenshots go to `~/Pictures/Screenshots`, recordings to `~/Videos/Recordings`.
