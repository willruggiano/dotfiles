{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
}:
buildDotnetModule rec {
  pname = "marksman";
  version = "2022-11-25";

  src = fetchFromGitHub {
    owner = "artempyanykh";
    repo = "marksman";
    rev = version;
    hash = "sha256-f5vbYp+7Ez96lbK0yvPekt3W3X6kKPXO6Lowb+hLLsc=";
  };

  projectFile = "Marksman.sln";
  nugetDeps = ./deps.nix;

  patches = [./version.diff];
  executables = ["marksman"];
}
