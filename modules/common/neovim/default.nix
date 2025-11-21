{
  environment = {
    variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };

  programs.fish.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}
