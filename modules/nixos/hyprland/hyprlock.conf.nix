{
  colors,
  monitor,
  ...
}:
with colors; let
  inherit (import ./lib.nix) rgb;
  font_family = "JetBrains Mono";
in ''
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
    font_color = ${rgb base05}
    inner_color = ${rgb base03}
    outer_color = ${rgb base0A}
    outline_thickness = 2
    placeholder_text = Password...
    size = 250, 50
  }

  label {
    monitor = ${monitor}
    text = cmd[update:1000] echo "$TIME"
    font_family = ${font_family}
    font_size = 50
    color = ${rgb base08}
    position = 0, 80
    valign = center
    halign = center
  }
''
