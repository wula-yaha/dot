local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple:find("windows") then
	config.font_size = 9.0
	config.window_background_opacity = 0.95
elseif wezterm.target_triple:find("darwin") then
	config.font_size = 13.0
	config.window_background_opacity = 0.95
	config.macos_window_background_blur = 10
	config.send_composed_key_when_left_alt_is_pressed = false
	config.send_composed_key_when_right_alt_is_pressed = true
elseif wezterm.target_triple:find("linux") then
	config.font_size = 11.0
	config.window_background_opacity = 1.0
end

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium", italic = false })
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
config.line_height = 1.2
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.color_scheme = "Catppuccin Mocha"
config.colors = {
	background = "#11111b",
	tab_bar = {
		background = "#11111b",
	},
}
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = {
	left = 12,
	right = 12,
	top = 12,
	bottom = 12,
}
config.window_close_confirmation = "NeverPrompt"

return config
