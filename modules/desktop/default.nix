{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in
{
  config = mkIf config.services.xserver.enable {
    user.packages = with pkgs; [
      xclip
    ];

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        font-awesome
      ];
    };

    services = {
      xserver = {
        layout = "us";
        xkbOptions = "ctrl:nocaps";
        libinput = {
          enable = true;
          touchpad = {
            disableWhileTyping = true;
            naturalScrolling = true;
            tapping = false;
          };
        };
        desktopManager.xterm.enable = false;
        displayManager = {
          defaultSession = "none+i3";
          lightdm = {
            enable = true;
            greeters.mini.user = config.user.name;
          };
          autoLogin = {
            enable = true;
            user = config.user.name;
          };
        };
        windowManager = {
          i3 = {
            enable = true;
            # package = pkgs.i3-gaps;
            extraPackages = with pkgs; [
              dmenu
              font-awesome
              i3status-rust
              i3lock
              rofi
              speedtest-cli
            ];
          };
        };
      };
    };

    home.configFile = {
      "i3/config".text = ''
        # i3 config file (v4)
        #
        # Please see https://i3wm.org/docs/userguide.html for a complete reference!
        #
        # This config file uses keycodes (bindsym) and was written for the QWERTY
        # layout.
        #
        # To get a config file with the same key positions, but for your current
        # layout, use the i3-config-wizard
        #

        # Font for window titles. Will also be used by the bar unless a different font
        # is used in the bar {} block below.
        font pango:monospace 8

        for_window [class="floating"] floating enable

        # This font is widely installed, provides lots of unicode glyphs, right-to-left
        # text rendering and scalability on retina/hidpi displays (thanks to pango).
        #font pango:DejaVu Sans Mono 8

        # The combination of xss-lock, nm-applet and pactl is a popular choice, so
        # they are included here as an example. Modify as you see fit.

        # xss-lock grabs a logind suspend inhibit lock and will use i3lock to lock the
        # screen before suspend. Use loginctl lock-session to lock your screen.
        exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork

        # NetworkManager is the most popular way to manage wireless networks on Linux,
        # and nm-applet is a desktop environment-independent system tray GUI for it.
        #exec --no-startup-id nm-applet

        # Use pactl to adjust volume in PulseAudio.
        set $refresh_i3status killall -SIGUSR1 i3status
        bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
        bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
        bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
        bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

        # use these keys for focus, movement, and resize directions when reaching for
        # the arrows is not convenient
        set $up k
        set $down j
        set $left h
        set $right l

        # use Mouse+Mod1 to drag floating windows to their wanted position
        floating_modifier Mod1

        # start a terminal
        bindsym Mod1+Return exec ${pkgs.kitty}/bin/kitty

        # kill focused window
        bindsym Mod1+Shift+q kill

        # start dmenu (a program launcher)
        bindsym Mod1+d exec ${pkgs.dmenu}/bin/dmenu_run -b
        # There also is the (new) i3-dmenu-desktop which only displays applications
        # shipping a .desktop file. It is a wrapper around dmenu, so you need that
        # installed.
        bindsym Mod1+Shift+d exec --no-startup-id i3-dmenu-desktop --dmenu='dmenu -b'

        # change focus
        bindsym Mod1+$left focus left
        bindsym Mod1+$down focus down
        bindsym Mod1+$up focus up
        bindsym Mod1+$right focus right

        # alternatively, you can use the cursor keys:
        bindsym Mod1+Left focus left
        bindsym Mod1+Down focus down
        bindsym Mod1+Up focus up
        bindsym Mod1+Right focus right

        # move focused window
        bindsym Mod1+Shift+$left move left
        bindsym Mod1+Shift+$down move down
        bindsym Mod1+Shift+$up move up
        bindsym Mod1+Shift+$right move right

        # alternatively, you can use the cursor keys:
        bindsym Mod1+Shift+Left move left
        bindsym Mod1+Shift+Down move down
        bindsym Mod1+Shift+Up move up
        bindsym Mod1+Shift+Right move right

        # split in horizontal orientation
        # bindsym Mod1+Shift+h split h

        # split in vertical orientation
        # bindsym Mod1+Shift+v split v

        # enter fullscreen mode for the focused container
        bindsym Mod1+f fullscreen toggle

        # change container layout (stacked, tabbed, toggle split)
        bindsym Mod1+s layout stacking
        bindsym Mod1+w layout tabbed
        bindsym Mod1+e layout toggle split

        # toggle tiling / floating
        bindsym Mod1+Shift+space floating toggle

        # change focus between tiling / floating windows
        bindsym Mod1+space focus mode_toggle

        # focus the parent container
        bindsym Mod1+a focus parent

        # focus the child container
        #bindsym Mod1+d focus child

        # move the currently focused window to the scratchpad
        bindsym Mod1+Shift+minus move scratchpad

        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        bindsym Mod1+minus scratchpad show

        # Define names for default workspaces for which we configure key bindings later on.
        # We use variables to avoid repeating the names in multiple places.
        set $ws1 "1"
        set $ws2 "2"
        set $ws3 "3"
        set $ws4 "4"
        set $ws5 "5"
        set $ws6 "6"
        set $ws7 "7"
        set $ws8 "8"
        set $ws9 "9"
        set $ws10 "10"

        # switch to workspace
        bindsym Mod1+1 workspace number $ws1
        bindsym Mod1+2 workspace number $ws2
        bindsym Mod1+3 workspace number $ws3
        bindsym Mod1+4 workspace number $ws4
        bindsym Mod1+5 workspace number $ws5
        bindsym Mod1+6 workspace number $ws6
        bindsym Mod1+7 workspace number $ws7
        bindsym Mod1+8 workspace number $ws8
        bindsym Mod1+9 workspace number $ws9
        bindsym Mod1+0 workspace number $ws10

        # move focused container to workspace
        bindsym Mod1+Shift+1 move container to workspace number $ws1
        bindsym Mod1+Shift+2 move container to workspace number $ws2
        bindsym Mod1+Shift+3 move container to workspace number $ws3
        bindsym Mod1+Shift+4 move container to workspace number $ws4
        bindsym Mod1+Shift+5 move container to workspace number $ws5
        bindsym Mod1+Shift+6 move container to workspace number $ws6
        bindsym Mod1+Shift+7 move container to workspace number $ws7
        bindsym Mod1+Shift+8 move container to workspace number $ws8
        bindsym Mod1+Shift+9 move container to workspace number $ws9
        bindsym Mod1+Shift+0 move container to workspace number $ws10

        # reload the configuration file
        bindsym Mod1+Shift+c reload
        # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
        bindsym Mod1+Shift+r restart
        # exit i3 (logs you out of your X session)
        bindsym Mod1+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"

        # resize window (you can also use the mouse for that)
        mode "resize" {
          # These bindings trigger as soon as you enter the resize mode

          # Pressing left will shrink the window’s width.
          # Pressing right will grow the window’s width.
          # Pressing up will shrink the window’s height.
          # Pressing down will grow the window’s height.
          bindsym $left       resize shrink width 10 px or 10 ppt
          bindsym $down       resize grow height 10 px or 10 ppt
          bindsym $up         resize shrink height 10 px or 10 ppt
          bindsym $right      resize grow width 10 px or 10 ppt

          # same bindings, but for the arrow keys
          bindsym Left        resize shrink width 10 px or 10 ppt
          bindsym Down        resize grow height 10 px or 10 ppt
          bindsym Up          resize shrink height 10 px or 10 ppt
          bindsym Right       resize grow width 10 px or 10 ppt

          # back to normal: Enter or Escape or Mod1+r
          bindsym Return mode "default"
          bindsym Escape mode "default"
          bindsym Mod1+r mode "default"
        }

        bindsym Mod1+r mode "resize"

        # start i3bar to display a workspace bar (plus the system information i3status
        # finds out, if available)
        bar {
          position bottom
          status_command ${pkgs.i3status-rust}/bin/i3status-rs
        }

        # use rofi as our launcher
        #bindsym Mod1+space exec ${pkgs.rofi}/bin/rofi -show run

        set $mode_launcher Launch: [b]rowser [l]auncher [p]assmenu [t]erminal
        bindsym Mod1+o mode "$mode_launcher"

        mode "$mode_launcher" {
          bindsym b exec --no-startup-id ${pkgs.firefox}/bin/firefox; mode "default"
          bindsym l exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run; mode "default"
          bindsym p exec --no-startup-id ${pkgs.pass}/bin/passmenu; mode "default"
          bindsym t exec --no-startup-id ${pkgs.kitty}/bin/kitty; mode "default"
          bindsym Enter mode "default"
          bindsym Escape mode "default"
          bindsym Mod1+o mode "default"
        }

        # startup things:
        focus_follows_mouse no

        exec --no-startup-id xmodmap ~/.xmodmaprc
      '';

      "i3status-rust/config.toml".text = ''
        icons = "awesome5"
        theme = "plain"
        [[block]]
        block = "speedtest"
        format = "{ping}{speed_down}{speed_up}"
        interval = 1800

        [[block]]
        block = "disk_space"
        format = "{icon} {used}/{total} ({available} free)"
        info_type = "used"
        path = "/"
        unit = "GB"

        [[block]]
        block = "cpu"
        interval = 1

        [[block]]
        block = "load"
        format = "{1m}"
        interval = 1

        [[block]]
        block = "sound"

        [[block]]
        block = "battery"
        format = "{percentage} {time}"
        interval = 10

        [[block]]
        block = "time"
        format = "%a %m/%d %R"
        interval = 60
      '';
    };
  };
}
