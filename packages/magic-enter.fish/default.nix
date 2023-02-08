{fishPlugins, ...}:
fishPlugins.buildFishPlugin {
  pname = "magic-enter-fish";
  version = "master";
  src = ./.;
}
