local wezterm = require('wezterm')
local config = wezterm.config_builder()

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.font_size = 9.0
elseif wezterm.target_triple == "x86_64-apple-darwin" or wezterm.target_triple == "aarch64-apple-darwin" then
  config.font_size = 12.5
elseif wezterm.target_triple == "x86_64-apple-darwin" then
  config.font_size = 10.0
end

config.initial_cols = 120
config.initial_rows = 40
config.window_padding = {
  left = 12,
  right = 12,
  top = 12,
  bottom = 12
}
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", italic = false })
config.color_scheme = "carbonfox"
config.window_close_confirmation = "NeverPrompt"
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
config.line_height = 1.08

return config
