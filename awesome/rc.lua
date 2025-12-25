-- IMPORT PACKAGES --
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local filesystem = require("gears.filesystem")
local xresources = require("beautiful.xresources")
local theme_assets = require("beautiful.theme_assets")
local get_themes_dir = filesystem.get_themes_dir()
local dpi = xresources.apply_dpi

-- Error Handling --
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "There were errors during startup!",
		text = awesome.startup_errors,
	})
end
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "An error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end

-- THEME --
local catppuccin = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
}
beautiful.init({
	font = "JetBrainsMono Nerd Font Semibold 11",
	bg_normal = catppuccin["crust"],
	bg_focus = catppuccin["crust"],
	bg_urgent = catppuccin["crust"],
	bg_minimize = catppuccin["crust"],
	bg_systray = catppuccin["crust"],
	fg_normal = catppuccin["text"],
	fg_focus = catppuccin["green"],
	fg_urgent = catppuccin["red"],
	fg_minimize = catppuccin["text"],
	useless_gap = dpi(4),
	border_width = dpi(2),
	border_normal = catppuccin["surface2"],
	border_focus = catppuccin["green"],
	border_marked = catppuccin["red"],
	menu_height = dpi(40),
	menu_width = dpi(200),
	taglist_fg_focus = catppuccin["base"],
	taglist_bg_focus = catppuccin["green"],
	taglist_fg_urgent = catppuccin["base"],
	taglist_bg_urgent = catppuccin["red"],
	taglist_squares_sel = theme_assets.taglist_squares_sel(dpi(0), catppuccin["green"]),
	taglist_squares_unsel = theme_assets.taglist_squares_unsel(dpi(0), catppuccin["surface1"]),
	menu_submenu_icon = get_themes_dir .. "default/submenu.png",
	titlebar_fg_normal = catppuccin["text"],
	titlebar_bg_normal = catppuccin["crust"],
	titlebar_fg_focus = catppuccin["text"],
	titlebar_bg_focus = catppuccin["crust"],
	titlebar_close_button_normal = get_themes_dir .. "default/titlebar/close_normal.png",
	titlebar_close_button_focus = get_themes_dir .. "default/titlebar/close_focus.png",
	titlebar_minimize_button_normal = get_themes_dir .. "default/titlebar/minimize_normal.png",
	titlebar_minimize_button_focus = get_themes_dir .. "default/titlebar/minimize_focus.png",
	titlebar_ontop_button_normal_inactive = get_themes_dir .. "default/titlebar/ontop_normal_inactive.png",
	titlebar_ontop_button_focus_inactive = get_themes_dir .. "default/titlebar/ontop_focus_inactive.png",
	titlebar_ontop_button_normal_active = get_themes_dir .. "default/titlebar/ontop_normal_active.png",
	titlebar_ontop_button_focus_active = get_themes_dir .. "default/titlebar/ontop_focus_active.png",
	titlebar_sticky_button_normal_inactive = get_themes_dir .. "default/titlebar/sticky_normal_inactive.png",
	titlebar_sticky_button_focus_inactive = get_themes_dir .. "default/titlebar/sticky_focus_inactive.png",
	titlebar_sticky_button_normal_active = get_themes_dir .. "default/titlebar/sticky_normal_active.png",
	titlebar_sticky_button_focus_active = get_themes_dir .. "default/titlebar/sticky_focus_active.png",
	titlebar_floating_button_normal_inactive = get_themes_dir .. "default/titlebar/floating_normal_inactive.png",
	titlebar_floating_button_focus_inactive = get_themes_dir .. "default/titlebar/floating_focus_inactive.png",
	titlebar_floating_button_normal_active = get_themes_dir .. "default/titlebar/floating_normal_active.png",
	titlebar_floating_button_focus_active = get_themes_dir .. "default/titlebar/floating_focus_active.png",
	titlebar_maximized_button_normal_inactive = get_themes_dir .. "default/titlebar/maximized_normal_inactive.png",
	titlebar_maximized_button_focus_inactive = get_themes_dir .. "default/titlebar/maximized_focus_inactive.png",
	titlebar_maximized_button_normal_active = get_themes_dir .. "default/titlebar/maximized_normal_active.png",
	titlebar_maximized_button_focus_active = get_themes_dir .. "default/titlebar/maximized_focus_active.png",
	tasklist_bg_normal = catppuccin["crust"],
	tasklist_bg_focus = catppuccin["crust"],
	tasklist_fg_normal = catppuccin["text"],
	tasklist_fg_focus = catppuccin["text"],
	layout_fairh = get_themes_dir .. "default/layouts/fairhw.png",
	layout_fairv = get_themes_dir .. "default/layouts/fairvw.png",
	layout_floating = get_themes_dir .. "default/layouts/floatingw.png",
	layout_magnifier = get_themes_dir .. "default/layouts/magnifierw.png",
	layout_max = get_themes_dir .. "default/layouts/maxw.png",
	layout_fullscreen = get_themes_dir .. "default/layouts/fullscreenw.png",
	layout_tilebottom = get_themes_dir .. "default/layouts/tilebottomw.png",
	layout_tileleft = get_themes_dir .. "default/layouts/tileleftw.png",
	layout_tile = get_themes_dir .. "default/layouts/tilew.png",
	layout_tiletop = get_themes_dir .. "default/layouts/tiletopw.png",
	layout_spiral = get_themes_dir .. "default/layouts/spiralw.png",
	layout_dwindle = get_themes_dir .. "default/layouts/dwindlew.png",
	layout_cornernw = get_themes_dir .. "default/layouts/cornernww.png",
	layout_cornerne = get_themes_dir .. "default/layouts/cornernew.png",
	layout_cornersw = get_themes_dir .. "default/layouts/cornersww.png",
	layout_cornerse = get_themes_dir .. "default/layouts/cornersew.png",
	prompt_bg = catppuccin["crust"],
	prompt_fg = catppuccin["red"],
	prompt_bg_cursor = catppuccin["red"],
	notification_font = "JetBrainsMono Nerd Font 10",
	notification_bg = catppuccin["base"],
	notification_fg = catppuccin["text"],
	notification_border_color = catppuccin["surface2"],
	awesome_icon = theme_assets.awesome_icon(dpi(15), catppuccin["base"], catppuccin["text"]),
	-- wallpaper = get_themes_dir .. "default/background.png",
	wallpaper = "~/wallpaper/wp1.jpg",
	icon_theme = nil,
})

-- VARIABLES & LAYOUT --
local modkey = "Mod4"
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	awful.layout.suit.corner.ne,
	awful.layout.suit.corner.sw,
	awful.layout.suit.corner.se,
}
menubar.utils.terminal = "xterm"

-- WIBAR --
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
		-- gears.wallpaper.set("#000000")
	end

	-- Prompt
	s.promptbox = awful.widget.prompt({
		prompt = " Execute: ",
	})

	-- LayoutBox
	s.layoutbox = awful.widget.layoutbox(s)

	-- Taglist
	awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", " 0 " }, s, awful.layout.layouts[1])
	s.taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
	})

	-- Tasklist
	s.tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
	})

	-- Wibox
	s.wibox = awful.wibar({
		position = "top",
		screen = s,
		height = 24,
	})

	s.wibox:setup({
		layout = wibox.layout.align.horizontal,
		-- Left
		{
			layout = wibox.layout.fixed.horizontal,
			s.taglist,
			s.tasklist,
			s.promptbox,
		},
		-- Center
		{
			layout = wibox.layout.fixed.horizontal,
		},
		-- Right
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = xresources.apply_dpi(16),
			wibox.widget({
				awful.widget.watch(
					[[sh -c "echo CPU:$(top -bn1 | grep Cpu | awk '{print sprintf(\"\%.0f\", $2)}')%"]],
					3
				),
				fg = catppuccin["red"],
				widget = wibox.container.background,
			}),
			wibox.widget({
				awful.widget.watch([[sh -c "echo RAM:$(free | grep Mem | awk '{printf \"%.0f\", ($3/$2)*100}')%"]], 3),
				fg = catppuccin["peach"],
				widget = wibox.container.background,
			}),
			wibox.widget({
				awful.widget.watch([[sh -c "echo BAT:$(cat /sys/class/power_supply/BAT1/capacity)%"]], 120),
				fg = catppuccin["green"],
				widget = wibox.container.background,
			}),
			wibox.widget({
				awful.widget.watch(
					[[sh -c "echo VOL:$(echo $(amixer sget Master | grep -o -E '[0-9]+%' | head -1))"]],
					1
				),
				fg = catppuccin["text"],
				widget = wibox.container.background,
			}),
			wibox.widget({
				awful.widget.watch([[sh -c "echo DAT:$(date +%Y-%m-%d\ %H:%M)"]], 60),
				fg = catppuccin["lavender"],
				widget = wibox.container.background,
			}),
			wibox.widget.systray(),
			s.layoutbox,
		},
	})
end)

-- KEYBINDING --
local globalkeys = gears.table.join(
	awful.key({ modkey }, "space", function()
		awful.screen.focused().promptbox:run()
	end),
	awful.key({ modkey }, "Return", function()
		awful.spawn("xterm")
	end),
	awful.key({ modkey, "Shift" }, "Return", function()
		awful.spawn("emacs")
	end),
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end),
	awful.key({ modkey }, ",", function()
		awful.screen.focus_relative(1)
	end),
	awful.key({ modkey }, ".", function()
		awful.screen.focus_relative(-1)
	end),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end),
	awful.key({ modkey, "Shift" }, "r", awesome.restart),
	awful.key({ modkey, "Shift" }, "e", awesome.quit),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end),
	awful.key({ modkey }, "Tab", function()
		awful.layout.inc(1)
	end),
	awful.key({ modkey, "Shift" }, "Tab", function()
		awful.layout.inc(-1)
	end),
	awful.key({ modkey }, "#10", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[1]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#11", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[2]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#12", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[3]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#13", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[4]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#14", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[5]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#15", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[6]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#16", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[7]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#17", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[8]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#18", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[9]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey }, "#19", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[10]
		if tag then
			tag:view_only()
		end
	end),
	awful.key({ modkey, "Shift" }, "#10", function()
		if client.focus then
			local tag = client.focus.screen.tags[1]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#11", function()
		if client.focus then
			local tag = client.focus.screen.tags[2]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#12", function()
		if client.focus then
			local tag = client.focus.screen.tags[3]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#13", function()
		if client.focus then
			local tag = client.focus.screen.tags[4]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#14", function()
		if client.focus then
			local tag = client.focus.screen.tags[5]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#15", function()
		if client.focus then
			local tag = client.focus.screen.tags[6]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#16", function()
		if client.focus then
			local tag = client.focus.screen.tags[7]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#17", function()
		if client.focus then
			local tag = client.focus.screen.tags[8]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#18", function()
		if client.focus then
			local tag = client.focus.screen.tags[9]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Shift" }, "#19", function()
		if client.focus then
			local tag = client.focus.screen.tags[10]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.util.spawn("brightnessctl s +5%")
	end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.util.spawn("brightnessctl s 5%-")
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.util.spawn("amixer sset Master 5%+")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.util.spawn("amixer sset Master 5%-")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.util.spawn("amixer sset Master 1+ toggle")
	end)
)
root.keys(globalkeys)

-- RULE --
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = gears.table.join(
				awful.key({ modkey }, "f", function(c)
					c.fullscreen = not c.fullscreen
					c:raise()
				end),
				awful.key({ modkey, "Shift" }, "q", function(c)
					c:kill()
				end)
			),
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},
	-- Floating clients.
	{
		rule_any = {
			instance = { "DTA", "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},
			name = { "Event Tester" },
			role = { "AlarmWindow", "ConfigManager", "pop-up" },
		},
		properties = { floating = true },
	},
	-- Add titlebars to normal clients and dialogs
	{
		rule_any = {
			type = { "normal", "dialog" },
		},
		properties = { titlebars_enabled = true },
	},
}

-- SIGNAL --
client.connect_signal("manage", function(c)
	c.shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, 8)
	end
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		awful.placement.no_offscreen(c)
	end
end)
client.connect_signal("request::titlebars", function(c)
	awful.titlebar(c, { size = 24 }):setup({
		-- Left
		{
			awful.titlebar.widget.iconwidget(c),
			buttons = gears.table.join(
				awful.button({}, 1, function()
					c:emit_signal("request::activate", "titlebar", { raise = true })
					awful.mouse.client.move(c)
				end),
				awful.button({}, 3, function()
					c:emit_signal("request::activate", "titlebar", { raise = true })
					awful.mouse.client.resize(c)
				end)
			),
			layout = wibox.layout.fixed.horizontal,
		},
		-- Center
		{
			{
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = gears.table.join(
				awful.button({}, 1, function()
					c:emit_signal("request::activate", "titlebar", { raise = true })
					awful.mouse.client.move(c)
				end),
				awful.button({}, 3, function()
					c:emit_signal("request::activate", "titlebar", { raise = true })
					awful.mouse.client.resize(c)
				end)
			),
			layout = wibox.layout.flex.horizontal,
		},
		-- Right
		{
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- AUTOSTART --
local application = {
	"xclip",
	"nm-applet",
	"blueman-applet",
	"flameshot",
	"udiskie --tray",
	"/usr/lib/polkit-kde-authentication-agent-1",
	"xrdb -merge ~/.Xresources",
	"ibus-daemon -drxR",
	"redshift -x && redshift -O 4500",
}
for _, app in ipairs(application) do
	awful.spawn.with_shell(app)
end

-- GARBAGE COLLECTION --
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage()
	end,
})
