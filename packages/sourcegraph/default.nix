{
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "src-cli";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = pname;
    rev = version;
    hash = "sha256-KqCH4f9QPfr/Hm4phR9qeCV925RkOawGnbCx8wz/QwE=";
  };
  vendorSha256 = "sha256-NMLrBYGscZexnR43I4Ku9aqzJr38z2QAnZo0RouHFrc=";

  doCheck = false; # FIXME: Build fails when running tests
  preBuild = ''
    export HOME=$TMPDIR
  '';
}
