lib: inputs:
{
  makeHome = import ./makeHome.nix { inherit inputs lib; };
  mapFilterAttrs = import ./mapFilterAttrs.nix lib;
  mapModules = import ./mapModules.nix lib;
  mkOpt = type: default: inputs.self.lib.mkOption { inherit type default; };
  mkOpt' = type: default: description: inputs.self.lib.mkOption { inherit type default description; };
  reduceModules = import ./reduceModules.nix lib;
  mapModulesRec = import ./mapModulesRec.nix lib;
  reduceModulesRec = import ./reduceModulesRec.nix lib;
}
