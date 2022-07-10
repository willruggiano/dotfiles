{
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_14,
  libxml2,
  zlib,
  zig_0_10_0,
}: let
  libyaml = fetchFromGitHub {
    owner = "yaml";
    repo = "libyaml";
    rev = "0.2.5";
    hash = "sha256-S7PnooyfyAsIiRAlEPGYkgkVACGaBaCItuqOwrq2+qM=";
  };

  zig-ansi = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-ansi";
    rev = "d4a53bcac5b87abecc65491109ec22aaf5f3dc2f";
    hash = "sha256-eb9lwaH5PnTjfD5b9EqSouZFdOZ4r65GQeMOHvs7bOA=";
  };

  known-folders = fetchFromGitHub {
    owner = "ziglibs";
    repo = "known-folders";
    rev = "9db1b99219c767d5e24994b1525273fe4031e464";
    hash = "sha256-eqaZxIax8C75L2UwDbVKSUZ7iThm/iWblfoaTfPyHLM=";
  };

  zig-licenses = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-licenses";
    rev = "c9b8cbf3565675a056ad4e9b57cb4f84020e7680";
    hash = "sha256-lnqDt9yaK2Ed3W14vmxcd5kraG/QDSh2rSmvC/5naiU=";
  };

  zfetch = fetchFromGitHub {
    owner = "truemedian";
    repo = "zfetch";
    rev = "5a7ce5811ee19fb959b41c718018f461f45611d4";
    hash = "sha256-JdI10N+jriEHEVmfzicFqaBqcqNtc3uoBIRWZJo6Cug=";
  };

  zig-uri = fetchFromGitHub {
    owner = "MasterQ32";
    repo = "zig-uri";
    rev = "e879df3a236869f92298fbe2db3c25e6e84cfd4c";
    hash = "sha256-OUS/5wIg3Le0qjpO1WlvQcI05jhR1k49ABQY+aZSn5E=";
  };

  hzzp = fetchFromGitHub {
    owner = "truemedian";
    repo = "hzzp";
    rev = "bf5aaf224e94561e035a631c3c40fbf02faa27d2";
    hash = "sha256-Nwmj0jfdqBzlBfdXETfAqRrR5oVod0I0AuTN1EaWwqI=";
  };

  iguana-tls = fetchFromGitHub {
    owner = "nektro";
    repo = "iguanaTLS";
    rev = "09d9fe92f329484536dfb2b07cfa8b406151cde4";
    hash = "sha256-R+kCZrozGikZjtXrzx4H8QMNo9MyQ98bNAWCSoc8O2k=";
  };

  zig-json = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-json";
    rev = "a091eaa9f9ae91c3875630ba1983b33ea04971a3";
    hash = "sha256-iFrmpzD92wL+ldv/6ZKCtcNuNFkhcw56i5Yolp4xE8U=";
  };

  zig-extras = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-extras";
    rev = "b16f583d5af5c86c92237bf56fa8063a5e9961c3";
    hash = "sha256-XlafjHUqXZaVGXmVJZAIXSduaSxbvSXIQcncYJzKCVg=";
  };

  zig-range = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-range";
    rev = "4b2f12808aa09be4b27a163efc424dd4e0415992";
    hash = "sha256-Jmz2GFieXB4CALZ6XqMq9LbhkNoxF53/ovodQlg6PAM=";
  };

  zig-detect-license = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-detect-license";
    rev = "de5c285d999eea68b9189b48bb000243fef0a689";
    hash = "sha256-iqC1r+kPsKNkKGoF2z+93d/ryfnyYedLl5ioke/fE8U=";
  };

  zig-licenses-text = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-licenses-text";
    rev = "3c07c6e4eb0965dafd0b029c632f823631b3169c";
    hash = "sha256-Jygr1u2HYSRZNfq/aH+chaeV608dmvLIIPiFifKOWzY=";
  };

  zig-leven = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-leven";
    rev = "ab852cf74fa0b4edc530d925f0654b62c60365bf";
    hash = "sha256-XUPag1aHtC+yMm0loqgHESyN8ElUWGI7GT5DLN8vZe4=";
  };

  zig-inquirer = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-inquirer";
    rev = "14c3492c46f9765c3e77436741794d1a3118cbee";
    hash = "sha256-62+paPZiuyFdrV/TOZjec2y/sRgPtAvE36SLFsaSevo=";
  };

  ini = fetchFromGitHub {
    owner = "arqv";
    repo = "ini";
    rev = "b93f5b5ff9449f9af68ae3081f6a5e858b6698d9";
    hash = "sha256-pWF7iTBcENThRcPci5pL+Ht1jT7YSxKQkgGYwhxpduk=";
  };

  zig-time = fetchFromGitHub {
    owner = "nektro";
    repo = "zig-time";
    rev = "a22054de725ef19b3f91b9ad960d4093f852b7e0";
    hash = "sha256-/6uL3jj3lFFqkwPmQ6BxRt8Segr31yj5+BbI/T+9pUw=";
  };

  zigwin32 = fetchFromGitHub {
    owner = "marlersoft";
    repo = "zigwin32";
    rev = "18c9630b0198cc369088fa832f23e86f177b182f";
    hash = "sha256-lmQfp3zEj3LJqJCr1TgsU0EwuKJz81ybqfYv7ty+nBw=";
  };
in
  stdenv.mkDerivation rec {
    pname = "zigmod";
    version = "r80";

    src = fetchFromGitHub {
      owner = "nektro";
      repo = "zigmod";
      rev = version;
      hash = "sha256-NFcFQgzxB5Gm3XweKxBv+pQqKt406YJnu/oTXoVyj6E=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [zig_0_10_0];

    preBuild = let
      zigmodDepsV = ".zigmod/deps/v/git/github.com";
      zigmodDeps = ".zigmod/deps/git/github.com";
    in ''
      export HOME=$TMPDIR

      mkdir -p ${zigmodDepsV}/yaml/libyaml
      ln -s ${libyaml} ${zigmodDepsV}/yaml/libyaml/tag-0.2.5

      mkdir -p ${zigmodDeps}/nektro
      ln -s ${zig-ansi} ${zigmodDeps}/nektro/zig-ansi
      ln -s ${zig-licenses} ${zigmodDeps}/nektro/zig-licenses
      ln -s ${iguana-tls} ${zigmodDeps}/nektro/iguanaTLS
      ln -s ${zig-json} ${zigmodDeps}/nektro/zig-json
      ln -s ${zig-extras} ${zigmodDeps}/nektro/zig-extras
      ln -s ${zig-range} ${zigmodDeps}/nektro/zig-range
      ln -s ${zig-detect-license} ${zigmodDeps}/nektro/zig-detect-license
      ln -s ${zig-licenses-text} ${zigmodDeps}/nektro/zig-licenses-text
      ln -s ${zig-leven} ${zigmodDeps}/nektro/zig-leven
      ln -s ${zig-inquirer} ${zigmodDeps}/nektro/zig-inquirer
      ln -s ${zig-time} ${zigmodDeps}/nektro/zig-time

      mkdir -p ${zigmodDeps}/ziglibs
      ln -s ${known-folders} ${zigmodDeps}/ziglibs/known-folders

      mkdir -p ${zigmodDeps}/truemedian
      ln -s ${zfetch} ${zigmodDeps}/truemedian/zfetch
      ln -s ${hzzp} ${zigmodDeps}/truemedian/hzzp

      mkdir -p ${zigmodDeps}/MasterQ32
      ln -s ${zig-uri} ${zigmodDeps}/MasterQ32/zig-uri

      mkdir -p ${zigmodDeps}/arqv
      ln -s ${ini} ${zigmodDeps}/arqv/ini

      mkdir -p ${zigmodDeps}/marlersoft
      ln -s ${zigwin32} ${zigmodDeps}/marlersoft/zigwin32
    '';

    buildPhase = ''
      runHook preBuild
      zig build -Dbootstrap
      zig build --prefix $out
      runHook postBuild
    '';

    dontInstall = true;
  }
