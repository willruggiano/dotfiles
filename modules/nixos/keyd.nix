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

          meta = "layer(meta)";
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

        meta = {
          "1" = "M-1";
          "2" = "M-2";
          "3" = "M-3";
          "4" = "M-4";
          "5" = "M-5";
          "6" = "M-6";
          "7" = "M-7";
          "8" = "M-8";
          "9" = "M-9";
          "0" = "M-0";
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
        "meta+shift" = {
          "1" = "M-S-1";
          "2" = "M-S-2";
          "3" = "M-S-3";
          "4" = "M-S-4";
          "5" = "M-S-5";
          "6" = "M-S-6";
          "7" = "M-S-7";
          "8" = "M-S-8";
          "9" = "M-S-9";
          "0" = "M-S-0";
        };
      };
    };
  };
}
