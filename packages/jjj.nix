{
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jjj";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "icorbrey";
    repo = "jjj";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VHeoCVDqkdAMVQo9JAABzQaT72L5qTzKmgKZvmm5pLs=";
  };
  cargoHash = "sha256-sA+LflPee3QmIhpRAXFXxX+co7397jx+2GF+mq2z63c=";
})
