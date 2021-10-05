self: super:
{
  /* st = super.st.overrideAttrs (oldAttrs: rec {
    patches = [
    ./st-undercurl-0.8.4-20210822.diff
    ];
    }); */
  st = super.st.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "cjpbirkbeck";
      repo = "st";
      rev = "00e2d40de643f3f9cf0d8c8a9ff06cae70d4312e";
      hash = "sha256-UJTv5Mm65ibXJ/yJ6quwc8atvCLI/7dvm/oYGR9SGoc=";
    };

    buildInputs = with super.pkgs.xorg; [ libX11 libXft libXcursor ];

    preBuild = ''
      sed -i -e '/share\/applications/d' Makefile
    '';

    installPhase = ''
      TERMINFO=$out/share/terminfo make install PREFIX=$out

      mkdir -p $out/share/applications/
      install -D st.desktop $out/share/applications/
    '';
  });
}
