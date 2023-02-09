{
  fishPlugins,
  fetchFromGitHub,
  ...
}:
fishPlugins.buildFishPlugin {
  pname = "magic-enter.fish";
  version = "master";

  src = fetchFromGitHub {
    owner = "mattmc3";
    repo = "magic-enter.fish";
    rev = "bb82182";
    hash = "sha256-/I75w2NCthTqB/rrQiP2YzzsEU1xgiiupGrlVliWxkY=";
  };
}
