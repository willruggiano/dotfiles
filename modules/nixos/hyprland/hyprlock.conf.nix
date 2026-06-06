{
  config,
  monitor,
  ...
}: let
  inherit (config.lib.stylix) colors;
in ''
  # vim: ft=hyprlang

  background {
    monitor =
    path = screenshot
    blur_size = 7
    blur_passes = 3
  }

  input-field {
    monitor = ${monitor}
    dots_center = true
    dots_spacing = 0.3
    fade_on_empty = false
    font_color = ${colors.withHashtag.base05}
    inner_color = ${colors.withHashtag.base03}
    outer_color = ${colors.withHashtag.base0A}
    outline_thickness = 2
    placeholder_text = Password...
    size = 250, 50
  }

  label {
    monitor = ${monitor}
    text = cmd[update:1000] echo "$TIME"
    font_family = ${builtins.head config.fonts.fontconfig.defaultFonts.sansSerif}
    font_size = 50
    color = ${colors.withHashtag.base08}
    position = 0, 80
    valign = center
    halign = center
  }
''
