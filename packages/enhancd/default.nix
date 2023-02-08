{
  fishPlugins,
  fetchFromGitHub,
  ...
}:
fishPlugins.buildFishPlugin {
  pname = "enhancd-fish";
  version = "master";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "enhancd";
    rev = "c6967f7f70f18991a5f9148996afffc0d3ae76e4";
    hash = "sha256-p7ZG4NC9UWa55tPxYAaFocc0waIaTt+WO6MNearbO0U=";
  };
}
