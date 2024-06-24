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

          rightalt = "layer(meta)";
          leftalt = "layer(leftalt)";

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

        "meta:G" = {
          "," = ",";
          "." = ".";
          "m" = "0";
          "j" = "1";
          "k" = "2";
          "l" = "3";
          "u" = "4";
          "i" = "5";
          "o" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
        };

        "leftalt:A" = {
          shift = "layer(leftalt_shift)";

          "1" = "A-1";
          "2" = "A-2";
          "3" = "A-3";
          "4" = "A-4";
          "5" = "A-5";
          "6" = "A-6";
          "7" = "A-7";
          "8" = "A-8";
          "9" = "A-9";
          "0" = "A-0";
        };

        "leftalt_shift:S" = {
          "1" = "A-S-1";
          "2" = "A-S-2";
          "3" = "A-S-3";
          "4" = "A-S-4";
          "5" = "A-S-5";
          "6" = "A-S-6";
          "7" = "A-S-7";
          "8" = "A-S-8";
          "9" = "A-S-9";
          "0" = "A-S-0";
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
