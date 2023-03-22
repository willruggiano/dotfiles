{
  config,
  pkgs,
  ...
}: {
  config = {
    programs.flavours.items.lazygit = {
      template = ./lazygit.mustache;
    };

    home.configFile = {
      "lazygit/theme.yml".source = config.programs.flavours.build.lazygit;
    };
  };
}
