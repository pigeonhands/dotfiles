local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.enable_tab_bar = false;
-- config.hide_tab_bar_if_only_one_tab = true
-- config.tab_bar_at_bottom = true

config.window_decorations = 'NONE'
config.window_background_opacity = 0.9

--config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'Tokyo Night'


config.font = wezterm.font('JetBrainsMono NF')
-- config.font_size = 14.0

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- config.keys = {
--   { key = '|', mods = 'LEADER', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
--   { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
--
--   { key = 'h', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Left' },
--   { key = 'j', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Down' },
--   { key = 'k', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Up' },
--   { key = 'l', mods = 'CTRL', action = wezterm.action.ActivatePaneDirection 'Right' },
--
--   { key = 'z', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },
-- }
--
-- config.inactive_pane_hsb = {
--   saturation = 0.9,
--   brightness = 0.5,
-- }

return config
