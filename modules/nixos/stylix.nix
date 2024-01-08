{
  config,
  pkgs,
  ...
}: {
  config = {
    stylix = {
      autoEnable = false;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.programs.flavours.colorscheme}.yaml";
      image = ../../wallpapers/gandalf.jpg;
    };
  };
}
