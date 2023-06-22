{
  config,
  inputs,
  system,
  ...
}: {
  config = {
    environment.systemPackages = [
      inputs.neovim.packages."${system}".default
    ];

    programs.flavours.items.neovim = {
      template = ./neovim.mustache;
    };

    home.configFile = {
      "nvim/lua/flavours/palette.lua".source = config.programs.flavours.build.neovim;
    };

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
  };
}
