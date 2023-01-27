{
  config = {
    services.keyd = {
      enable = true;
      altGrNav = true;
      invertShiftKey = true;
      config = ''
        [ids]
        *

        [main]
        capslock = overload(control, esc)
        esc = capslock
      '';
    };
  };
}
