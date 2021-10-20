lib: { ... } @ inputs:
{
  makeHome = import ./makeHome.nix { inherit inputs lib; };
  mapFilterAttrs = import ./mapFilterAttrs.nix lib;
  mapModules = import ./mapModules.nix lib;
  reduceModules = import ./reduceModules.nix lib;
  mapModulesRec = import ./mapModulesRec.nix lib;
  reduceModulesRec = import ./reduceModulesRec.nix lib;
}
