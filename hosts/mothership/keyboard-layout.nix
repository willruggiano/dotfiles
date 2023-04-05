{
  config = {
    services.keyd = {
      enable = true;
      ids = ["*"];
    };
  };
}
