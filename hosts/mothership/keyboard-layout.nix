{
  config = {
    services.keyd = {
      enable = true;
      settings = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };
}
