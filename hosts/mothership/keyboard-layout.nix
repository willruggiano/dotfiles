{
  config = {
    services.keyd = {
      enable = true;
      keyboards.default.ids = [
        "0001:0001" # builtin
        "045e:0917" # Surface Keyboard
      ];
    };
  };
}
