{ lib, ... }:

with lib;
{
  options.programs.neovim = {
    enable = mkEnableOption "Enable neovim";
  };
}
