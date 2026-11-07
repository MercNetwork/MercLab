# Lua

Lua configures two things in MercLab: **Hyprland** (`home/configs/hypr/`) and
**Neovim** (`home/configs/nvim/`). Both files are live-linked, so you can edit
and reload without rebuilding (see [Live dotfiles](../desktop/live-dotfiles.md)).

## The language in ten minutes

```lua
-- comments start with two dashes
local name = "mercury"            -- always use `local`
local count = 3
local enabled = true
local nothing = nil

local msg = "hi " .. name         -- .. joins strings

-- tables are Lua's only data structure: arrays AND maps
local apps = { "kitty", "firefox" }       -- array, indexes start at 1!
print(apps[1])                            -- kitty
local user = { name = "mercury", shell = "zsh" }
print(user.name, user["shell"])

-- if / loops
if count > 2 then
  print("many")
elseif count == 2 then
  print("two")
else
  print("few")
end

for i, app in ipairs(apps) do print(i, app) end     -- arrays
for k, v in pairs(user) do print(k, v) end          -- maps

-- functions
local function greet(who)
  return "hello " .. (who or "world")   -- `or` gives a default
end

-- modules: a file returns a value, `require` loads it once
-- in variables.lua:   return { terminal = "kitty" }
-- elsewhere:          local vars = require("variables")
```

`~=` means "not equal". `#apps` is the length of an array. `pcall(f)` calls
`f` and catches errors — `hyprland.lua` uses `pcall(require, "user.vars")` so a
missing file isn't fatal.

## Hyprland's Lua API (Hyprland 0.55+)

Everything goes through the global `hl` table:

```lua
hl.config({ general = { gaps_in = 5, gaps_out = 10 } })     -- settings
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))              -- keybinds
hl.window_rule({ match = { class = "pwvucontrol" }, float = true })
hl.monitor({ output = "DP-1", mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.on("hyprland.start", function() hl.exec_cmd("trash-empty 30") end)
```

`hl.dsp.*` are *dispatchers* (actions): `exec_cmd`, `window.close()`,
`focus({ workspace = 3 })`, `window.move({ workspace = "+1" })`, etc.

Official reference: the Hyprland wiki (<https://wiki.hypr.land>) — *Configuring*
section. The full API stub ships with Hyprland at
`/run/current-system/sw/share/hypr/stubs/hl.meta.lua` (path may vary;
`fd hl.meta.lua /nix/store` finds it), which also gives Neovim completion.

### How Mercury's Hyprland config is organised

| File | Edit it to… |
|------|-------------|
| `variables.lua` | change apps, gaps, blur, opacity and **every keybind** |
| `hyprland/keybinds.lua` | change what a keybind *does* |
| `hyprland/rules.lua` | float/size/opacity rules per app |
| `hyprland/execs.lua` | things to run at login |
| `scheme/current.lua` | colours |
| `user/vars.lua` | override variables without touching the originals |
| `user/config.lua` | monitors and anything machine-specific |

Reload after editing: `hyprctl reload` (or just save — Hyprland watches its
config). A Lua syntax error shows a red banner; fix and save again.

## Neovim

Entry point is `lua/mercury/init.lua`, which loads `core`, `keymaps`, `tools`
and the plugin manager (`lazy.lua`). Each file in `lua/mercury/plugins/`
returns one plugin spec:

```lua
return {
  "folke/which-key.nvim",          -- GitHub repo
  event = "VeryLazy",              -- when to load
  opts = { preset = "modern" },    -- passed to the plugin's setup()
}
```

Add a plugin = add a file. Language servers are configured in
`plugins/nvim-lspconfig.lua`; a server starts only if its binary is installed,
which the `langs.*` modules do.

## Exercises

1. In `user/vars.lua`, return `{ windowGapsOut = 4 }`. Save, `hyprctl reload`.
2. Add a bind in `user/config.lua`:
   `hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox --private-window"))`.
3. Add `plugins/oil.lua` returning `{ "stevearc/oil.nvim", opts = {} }`,
   open Neovim, run `:Lazy` and watch it install.
