{
  buildGo118Module,
  fetchFromGitHub,
  git,
}:
buildGo118Module rec {
  pname = "src-cli";
  version = "3.41.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = pname;
    rev = version;
    hash = "sha256-3esG1atn7RGGlG9Nwz05M21Qbx/5jlS++Zw3FtSCTh4=";
  };
  vendorSha256 = "sha256-wjGNVG/iK8EcJBWxbXIrA/e0JkCZlpxR67Lo8DleJ1Y=";

  doCheck = false;
}
