{
  config = {
    services.keyd = {
      enable = true;
      altGrNav = true;
      invertShiftKey = true;
      config = ''
        [ids]
        0951:16d2

        [main]
        capslock = overload(control, esc)
        esc = capslock
      '';
    };
  };
}
