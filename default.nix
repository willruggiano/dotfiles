{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = reduceModules ./modules/common import;

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.bin;

  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: {flake = v;}) filteredInputs;
  in {
    extraOptions = ''
      extra-sandbox-paths = /nix/var/cache/ccache
    '';
    nixPath =
      nixPathInputs
      ++ [
        "dotfiles=${config.dotfiles.dir}" # TODO: I'm not sure this is necessary?
        # "nixpkgs-overlays=${config.dotfiles.dir}" FIXME: Infinite recursion
      ];
    registry = registryInputs // {dotfiles.flake = inputs.self;};
    gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "plug";
      runtimeInputs = with pkgs; [niv];
      text = ''
        pushd "${config.dotfiles.dir}/modules/common/neovim/plugins" >/dev/null
        niv "$@"
        popd >/dev/null
      '';
    })
  ];
}
