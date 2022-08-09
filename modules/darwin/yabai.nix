{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.yabai-homebrew;

  toYabaiConfig = opts:
    concatStringsSep "\n" (mapAttrsToList
    (p: v: "yabai -m config ${p} ${toString v}")
    opts);

  configFile =
    mkIf (cfg.config != {} || cfg.extraConfig != "")
    "${
      pkgs.writeScript "yabairc" (
        (
          if (cfg.config != {})
          then "${toYabaiConfig cfg.config}"
          else ""
        )
        + optionalString (cfg.extraConfig != "") ("\n" + cfg.extraConfig + "\n")
      )
    }";

  off = "off";
  on = "on";
  centered = "4:4:1:1:2:2";
in {
  options = with types; {
    services.yabai-homebrew.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable the yabai window manager.";
    };

    services.yabai-homebrew.config = mkOption {
      type = attrs;
      default = {};
      example = literalExpression ''
        {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          window_placement    = "second_child";
          window_opacity      = "off";
          top_padding         = 36;
          bottom_padding      = 10;
          left_padding        = 10;
          right_padding       = 10;
          window_gap          = 10;
        }
      '';
      description = ''
        Key/Value pairs to pass to yabai's 'config' domain, via the configuration file.
      '';
    };

    services.yabai-homebrew.extraConfig = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        yabai -m rule --add app='System Preferences' manage=off
      '';
      description = "Extra arbitrary configuration to append to the configuration file";
    };
  };

  config = mkIf cfg.enable {
    homebrew.taps = ["koekeishiya/formulae"];
    homebrew.brews = ["yabai"];

    services.yabai-homebrew = {
      config = {
        # global settings
        mouse_follows_focus = on;
        focus_follows_mouse = off;

        window_placement = "second_child";
        window_topmost = off;
        window_opacity = off;
        window_opacity_duration = 0.0;
        window_shadow = on;
        active_window_opacity = 1.0;
        normal_window_opacity = 0.90;
        window_border = off;
        window_border_width = 6;
        split_ratio = 0.50;
        auto_balance = off;

        # mouse support
        mouse_modifier = "alt";
        mouse_action1 = "move";
        mouse_action2 = "resize";

        # general space settings
        layout = "bsp";
        top_padding = 0;
        bottom_padding = 0;
        left_padding = 0;
        right_padding = 0;
        window_gap = 0;
      };
      extraConfig = let
        float = what: "yabai -m rule --add ${what} manage=off grid=${centered}";
      in
        concatStringsSep "\n" [
          "# float system prefrences"
          (float "app='^System Information$'")
          (float "app='^System Preferences$'")
          (float "title='Preferences$'")
          "# float settings windows"
          (float "title='Settings$'")
          "# float comms apps"
          (float "app='^Amazon Chime$'")
          (float "app='^Cisco AnyConnect Secure Mobility Client$'")
          (float "app='^Messages$'")
          "# float other apps"
          (float "app='^Dictionary$'")
          "# spacebar padding"
          "SPACEBAR_HEIGHT=$(${pkgs.spacebar}/bin/spacebar -m config height)"
          "yabai -m config external_bar all:0:$SPACEBAR_HEIGHT"
        ];
    };

    home.configFile = {
      "yabai/yabairc".source = configFile;
    };

    services.skhd = {
      enable = true;
      skhdConfig = let
        mod = "alt";
        jq = "${pkgs.jq}/bin/jq";
        xargs = "${pkgs.findutils}/bin/xargs";
      in ''
        # open terminal
        ${mod} - return : open -na kitty --args --single-instance -d ${config.user.home}

        # change focus
        ${mod} - h : yabai -m window --focus west
        ${mod} - j : yabai -m window --focus south
        ${mod} - k : yabai -m window --focus north
        ${mod} - l : yabai -m window --focus east

        # shift window in current workspace
        ${mod} + shift - h : yabai -m window --swap west || $(yabai -m window --display west; yabai -m display --focus west)
        ${mod} + shift - j : yabai -m window --swap south || $(yabai -m window --display south; yabai -m display --focus south)
        ${mod} + shift - k : yabai -m window --swap north || $(yabai -m window --display north; yabai -m display --focus north)
        ${mod} + shift - l : yabai -m window --swap east || $(yabai -m window --display east; yabai -m display --focus east)

        # set insertion point in focused container
        ${mod} + ctrl - h : yabai -m window --insert west
        ${mod} + ctrl - j : yabai -m window --insert south
        ${mod} + ctrl - k : yabai -m window --insert north
        ${mod} + ctrl - l : yabai -m window --insert east

        # go back to previous workspace (kind of like back_and_forth in i3)
        ${mod} - b : yabai -m space --focus recent
        # move focused window to previous workspace
        ${mod} + shift - b : yabai -m window --space recent; yabai -m space --focus recent

        # move focused window to next/prev workspace
        ${mod} + shift - 1 : yabai -m window --space 1
        ${mod} + shift - 2 : yabai -m window --space 2
        ${mod} + shift - 3 : yabai -m window --space 3
        ${mod} + shift - 4 : yabai -m window --space 4
        ${mod} + shift - 5 : yabai -m window --space 5
        ${mod} + shift - 7 : yabai -m window --space 7
        ${mod} + shift - 6 : yabai -m window --space 6
        ${mod} + shift - 8 : yabai -m window --space 8
        ${mod} + shift - 9 : yabai -m window --space 9

        # change layout of desktop
        ${mod} - e : yabai -m space --layout bsp
        ${mod} - l : yabai -m space --layout float
        ${mod} - s : yabai -m space --layout stack

        # (un)float window and center on screen
        ${mod} - t : yabai -m window --toggle float;\
                     yabai -m window --grid ${centered}

        # cycle through stack windows
        # forwards
        ${mod} - p : yabai -m query --spaces --space \
            | ${jq} -re ".index" \
            | ${xargs} -I{} yabai -m query --windows --space {} \
            | ${jq} -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.x, .id) | reverse | nth(index(map(select(.focused == 1))) - 1).id" \
            | ${xargs} -I{} yabai -m window --focus {}
        # backwards
        ${mod} - n : yabai -m query --spaces --space \
            | ${jq} -re ".index" \
            | ${xargs} -I{} yabai -m query --windows --space {} \
            | ${jq} -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | nth(index(map(select(.focused == 1))) - 1).id" \
            | ${xargs} -I{} yabai -m window --focus {}

        # close focused window
        ${mod} + shift - q : yabai -m window --close

        # enter fullscreen mode for the focused container
        ${mod} - f : yabai -m window --toggle zoom-fullscreen
        # toggle window native fullscreen
        ${mod} + shift - f : yabai -m window --toggle native-fullscreen

        # reload yabai/skhd
        ${mod} + shift - r : pkill yabai && ${pkgs.skhd}/bin/skhd -r
      '';
    };

    services.spacebar = {
      enable = true;
      package = pkgs.spacebar;
      config = let
        cpuStat = pkgs.writeShellScriptBin "cpuStat" ''
          ps -A -o %cpu | awk '{s+=$1} END {print s "%"}'
        '';
      in {
        position = "bottom";
        height = 26;
        title = on;
        spaces = on;
        clock = on;
        power = on;
        padding_left = 20;
        padding_right = 20;
        spacing_left = 25;
        spacing_right = 15;
        # text_font = "JetBrains Mono:Regular:12.0";
        # icon_font = "JetBrainsMono Nerd Font:Regular:12.0";
        background_color = "0xff202020";
        foreground_color = "0xffa8a8a8";
        power_icon_color = "0xffcd950c";
        battery_icon_color = "0xffd75f5f";
        dnd_icon_color = "0xffa8a8a8";
        clock_icon_color = "0xffa8a8a8";
        power_icon_strip = " ";
        space_icon_color = "0xffffab91";
        space_icon_color_secondary = "0xff78c4d4";
        space_icon_color_tertiary = "0xfffff9b0";
        space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
        clock_icon = "";
        clock_format = ''"%m/%d/%y %R"'';
        dnd_icon = "";
        right_shell = on;
        right_shell_icon = "";
        right_shell_icon_color = "0xffd8dee9";
        right_shell_command = "${cpuStat}/bin/cpuStat";
      };
    };

    system.defaults = {
      dock = {
        autohide = true;
        showhidden = true;
        mru-spaces = false;
      };
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        NSWindowResizeTime = "0.001";
      };
    };
  };
}
