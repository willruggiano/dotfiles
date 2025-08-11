{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.keyd;
in {
  config = mkIf cfg.enable {
    services.keyd = {
      keyboards.default.settings = {
        main = {
          capslock = "overload(control, esc)";
          esc = "capslock";

          shift = "layer(shift)";

          "1" = "!";
          "2" = "@";
          "3" = "#";
          "4" = "$";
          "5" = "%";
          "6" = "^";
          "7" = "&";
          "8" = "*";
          "9" = "(";
          "0" = ")";
        };

        shift = {
          "1" = 1;
          "2" = 2;
          "3" = 3;
          "4" = 4;
          "5" = 5;
          "6" = 6;
          "7" = 7;
          "8" = 8;
          "9" = 9;
          "0" = 0;
        };
      };
    };
  };
}
