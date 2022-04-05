{pkgs, ...}:
pkgs.appimageTools.wrapType2 {
  name = "omniverse";
  src = builtins.fetchurl {
    url = "https://install.launcher.omniverse.nvidia.com/installers/omniverse-launcher-linux.AppImage";
    sha256 = "sha256:1wz63rpqzzzxi7smhrs4bycyvxrmdbpgr8f4yjmi5j97zhg5i21h";
  };
  extraPkgs = pkgs: with pkgs; [];
}
