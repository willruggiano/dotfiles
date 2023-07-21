{
  inputs,
  system,
  ...
}: {
  config = {
    environment.systemPackages = [
      inputs.neovim.packages."${system}".default
    ];

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
  };
}
