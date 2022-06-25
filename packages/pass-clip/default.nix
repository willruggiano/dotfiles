{stdenv}:
stdenv.mkDerivation rec {
  pname = "pass-clip";
  version = "0.3";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    install -Dm0755 pass-clip.bash $out/lib/password-store/extensions/clip.bash
  '';
}
