{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "html2text";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "k3a";
    repo = "html2text";
    rev = "v${version}";
    hash = "";
  };

  vendorSha256 = null;
}
