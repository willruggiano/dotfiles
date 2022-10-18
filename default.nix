{
  inputs,
  config,
  lib,
  pkgs,
  system,
  ...
}:
with lib; {
  imports = reduceModules ./modules/common import;

  environment.variables.DOTFILES = config.dotfiles.dir;

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

  environment.systemPackages = let
    inherit (builtins) pathExists readDir;
    mkBins = dir:
      mapAttrs'
      (n: v: nameValuePair "${removeSuffix ".nix" n}" (pkgs.callPackage "${toString dir}/${n}" {inherit config;}))
      (filterAttrs (n: v: v == "regular" && !(hasPrefix "_" n) && (hasSuffix ".nix" n)) (readDir dir));

    hasSystemBin = pathExists ./bin/${system};
    bins =
      if hasSystemBin
      then (mkBins ./bin) // (mkBins ./bin/${system})
      else mkBins ./bin;
  in
    attrValues bins;
}
