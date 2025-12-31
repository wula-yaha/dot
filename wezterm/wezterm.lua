local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

if wezterm.target_triple:find("windows") then
	config.font_size = 10.0
	config.window_background_opacity = 0.99
	config.default_prog = { "powershell.exe" }
elseif wezterm.target_triple:find("darwin") then
	config.font_size = 13.0
	config.window_background_opacity = 0.99
	config.macos_window_background_blur = 10
	config.send_composed_key_when_left_alt_is_pressed = false
	config.send_composed_key_when_right_alt_is_pressed = true
	config.default_prog = { "/bin/zsh", "-l" }
elseif wezterm.target_triple:find("linux") then
	config.font_size = 11.0
	config.window_background_opacity = 1.0
	config.default_prog = { "/bin/bash", "-l" }
end

config.color_scheme = "tokyonight_night"
config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono Nerd Font",
		weight = "Medium",
		style = "Normal",
	},
	{ family = "Sarasa Term TC", scale = 1.0 },
	{
		family = "Noto Sans TC",
		weight = "Medium",
		scale = 1.15,
	},
})
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_load_flags = "NO_HINTING"
config.cell_width = 0.9
config.line_height = 1.2
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 24,
	right = 24,
	top = 24,
	bottom = 24,
}
config.window_close_confirmation = "NeverPrompt"

return config
