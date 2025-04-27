{
  rustPlatform,
  fetchFromGitHub,
  scdoc,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "autorandr-rs";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "theotherjimmy";
    repo = "autorandr-rs";
    rev = "408764f2b42f4fea28e03a04f9826a8fee699086";
    hash = "sha256-ulAxffFWCHzuM1/GzSloesoMYQ8Lzc/7yvLRmHeeubs=";
  };
  cargoHash = "sha256-9JSNEHXRv4lZ7ek9OC7rI8kKFc7VnweNpIU6xC+j6yE=";
  nativeBuildInputs = [scdoc installShellFiles];
  preFixup = ''
    installManPage $releaseDir/build/${pname}-*/out/monitor-layout.1
    installManPage $releaseDir/build/${pname}-*/out/monitor-layout.5
  '';
}
