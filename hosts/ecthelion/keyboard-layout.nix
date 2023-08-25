{
  config = {
    services.keyd = {
      enable = true;
      keyboards.default.ids = ["0951:16d2"];
    };
  };
}
