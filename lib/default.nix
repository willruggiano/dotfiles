lib:
{
  mapFilterAttrs = import ./mapFilterAttrs.nix lib;
  mapModules = import ./mapModules.nix lib;
  mapModules' = import ./mapModulesPrime.nix lib;
  mapModulesRec = import ./mapModulesRec.nix lib;
  mapModulesRec' = import ./mapModulesRecPrime.nix lib;
}
