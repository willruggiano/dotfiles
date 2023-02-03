{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "base16-schemes";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "cf6bc892a24af19e11383adedc6ce7901f133ea7";
    hash = "sha256-U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp *.yaml $out
    runHook postInstall
  '';
}
