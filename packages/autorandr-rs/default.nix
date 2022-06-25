{
  rustPlatform,
  fetchFromGitHub,
  scdoc,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "monitor-layout";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "theotherjimmy";
    repo = "autorandr-rs";
    rev = "408764f2b42f4fea28e03a04f9826a8fee699086";
    hash = "sha256-ulAxffFWCHzuM1/GzSloesoMYQ8Lzc/7yvLRmHeeubs=";
  };
  cargoHash = "sha256-2D2iKgtYdJZ7AypPhJ2n0GCpEfwFKNEPbjRxtcicbmw=";
  nativeBuildInputs = [scdoc installShellFiles];
  preFixup = ''
    installManPage $releaseDir/build/${pname}-*/out/monitor-layout.1
    installManPage $releaseDir/build/${pname}-*/out/monitor-layout.5
  '';
}
