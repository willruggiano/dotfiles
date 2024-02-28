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
    path = screenshot
    blur_size = 5
    blur_passes = 4
  }

  input-field {
    dots_center = true
    dots_spacing = 0.3
    fade_on_empty = false
    font_color = ${rgb base05}
    inner_color = ${rgb base03}
    monitor = ${monitor}
    outer_color = ${rgb base0A}
    outline_thickness = 2
    placeholder_text = <span font_family="${font_family}" foreground="##${base05}">Password...</span>
    size = 250, 50
  }

  label {
    monitor =
    text = $TIME
    font_family = ${font_family}
    font_size = 50
    color = ${rgb base08}
    position = 0, 80
    valign = center
    halign = center
  }
''
