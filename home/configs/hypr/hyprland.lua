-- Mercury Hyprland entry point (Hyprland 0.55+ Lua config).
--
-- Layout of this directory:
--   variables.lua        apps, look, and every keybind (edit this first)
--   hyprland/*.lua       one file per Hyprland config section
--   scheme/current.lua   colour scheme (Material-You style tokens)
--   utils/               helper functions (scratchpads, resizing)
--   user/vars.lua        your overrides for anything in variables.lua
--   user/config.lua      your own extra Hyprland Lua, loaded last
--   user/scratchpads.json optional scratchpad app overrides

local vars = require("variables")

-- Scale chosen in Nix (mercury.home.desktop.wms.hyprland.scale), written by
-- Home Manager to ~/.config/mercury/scale.lua
local scale_ok, nix_scale = pcall(function()
    local home = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
    return dofile(home .. "/mercury/scale.lua")
end)
if scale_ok and type(nix_scale) == "number" then
    vars.monitorScale = nix_scale
end

-- Apply user/vars.lua overrides on top of variables.lua
local ok, overrides = pcall(require, "user.vars")
if ok and type(overrides) == "table" then
    for k, v in pairs(overrides) do
        vars[k] = v
    end
end

-- Default monitor conf: preferred mode, fixed scale (never "auto", which is
-- what makes Hyprland look huge on high-DPI panels). Per-monitor lines in
-- user/config.lua override this.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = vars.monitorScale,
})

-- Let X11 apps render at native resolution instead of blurry upscaling
hl.config({ xwayland = { force_zero_scaling = true } })

-- Configs
require("hyprland.env")
require("hyprland.general")
require("hyprland.input")
require("hyprland.misc")
require("hyprland.animations")
require("hyprland.decoration")
require("hyprland.group")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.gestures")
require("hyprland.keybinds")

-- User config, loaded last so it can override anything above
pcall(require, "user.config")
