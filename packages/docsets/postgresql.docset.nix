{
  stdenv,
  postgresql,
  python3,
}:
stdenv.mkDerivation {
  name = "postgresql-docset";
  src = ./.;

  dontFetch = true;
  dontPatch = true;
  dontConfigure = true;
  dontFixup = true;

  buildInputs = [
    (python3.withPackages (ps: with ps; [beautifulsoup4]))
  ];
  buildPhase = ''
    runHook preBuild
    mkdir -p postgresql.docset/Contents/Resources/Documents
    cp -R ${postgresql.doc}/share/doc/postgresql/html/* postgresql.docset/Contents/Resources/Documents
    python postgresql.docset.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/docsets
    mv ./postgresql.docset $out/share/docsets/postgresql.docset
    runHook postInstall
  '';
}
