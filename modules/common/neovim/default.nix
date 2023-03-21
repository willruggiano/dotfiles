{
  inputs,
  system,
  ...
}: {
  config = {
    user.packages = [
      inputs.neovim.packages."${system}".default
    ];

    # TODO: This needs to be migrated
    #   programs.flavours.items.neovim = {
    #     file = "~/.config/nvim/lua/bombadil/colors/flavours.lua";
    #     template = "custom/neovim";
    #   };

    # TODO: This needs to be migrated?
    #     "nvim/lua/bombadil/config/tree-sitter-vimdoc.lua".text = ''
    #       -- Generated by Nix
    #       return {
    #         url = "${pkgs.tree-sitter-vimdoc}"
    #       }
    #     '';

    environment.variables.EDITOR = "nvim";
    environment.variables.MANPAGER = "nvim +Man!";
  };
}
