{
  config = {
    services.keyd = {
      enable = true;
      altGrNav = true;
      invertShiftKey = true;
      layers = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };
}
