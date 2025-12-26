import os
import libqtile.resources
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

mod = "mod4"
terminal = guess_terminal()

keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key(
        [mod, "control"],
        "h",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide", "monadthreecol"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide", "monadthreecol"]),
        desc="Grow window to the right",
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "space", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl s +5%"),
        desc="Brightness Up",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl s 5%-"),
        desc="Brightness Down",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("amixer sset Master 5%+"),
        desc="Raise Volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("amixer sset Master 5%-"),
        desc="Lower Volume",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("amixer sset Master 1+ toggle"),
        desc="Mute Volume",
    ),
]

for vt in range(1, 10):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [Group(i) for i in "1234567890"]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

layouts = [
    # layout.Columns(),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(border_width=1, ratio=0.55, margin=8),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans bold",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()
logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.Prompt(prompt="➤ "),
                widget.GroupBox(),
                widget.WindowName(),
                widget.CPU(format="CPU:{load_percent}%", padding=4),
                widget.Memory(format="{MemUsed:.0f}{mm}", fmt="RAM:{}", padding=4),
                widget.Battery(format="BAT:{percent:2.0%}", padding=4),
                widget.Volume(fmt="VOL:{}", padding=4),
                widget.Clock(format="%Y-%m-%d %H:%M", padding=4),
                widget.Systray(),
                widget.CurrentLayout(mode="icon", scale=0.75),
            ],
            24,
            border_width=[0, 0, 0, 0],
            border_color=["000000", "000000", "000000", "000000"],
        ),
        background="#000000",
        wallpaper=logo,
        wallpaper_mode="center",
    ),
]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wl_xcursor_theme = None
wl_xcursor_size = 24
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    process = [
        "xclip",
        "nm-applet",
        "blueman-applet",
        "flameshot",
        "udiskie --tray",
        "/usr/lib/polkit-kde-authentication-agent-1",
        "xrdb -merge ~/.Xresources",
        "ibus-daemon --drxR",
        "redshift -x && redshift -O 4500",
        "picom",
    ]
    for p in process:
        qtile.spawn(p + " &")
