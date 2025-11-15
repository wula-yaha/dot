local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font_size = 9.0
	config.window_background_opacity = 0.95
elseif wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
	config.font_size = 12.5
	config.window_background_opacity = 0.95
elseif wezterm.target_triple == "x86_64-apple-darwin" then
	config.font_size = 10.0
	config.window_background_opacity = 1.0
end

config.initial_cols = 120
config.initial_rows = 40
config.window_padding = {
	left = 12,
	right = 12,
	top = 12,
	bottom = 12,
}
config.animation_fps = 60
config.max_fps = 60
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", italic = false })
config.color_scheme = "carbonfox"
config.window_close_confirmation = "NeverPrompt"
config.front_end = "OpenGL"
config.webgpu_power_preference = "HighPerformance"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
config.line_height = 1.08
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.integrated_title_button_alignment = "Right"
config.integrated_title_button_color = "Auto"
config.integrated_title_button_style = "Windows"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
config.status_update_interval = 1000
config.command_palette_font_size = 16
config.command_palette_rows = 24
config.scrollback_lines = 2000
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 1500
config.cursor_blink_ease_in = "EaseIn"
config.cursor_blink_ease_out = "EaseOut"

return config
