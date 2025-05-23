{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    autoEnable = false;
    # https://github.com/NTBBloodbath/doom-one.nvim
    base16Scheme = {
      base00 = "#282c34";
      base01 = "#21242b";
      base02 = "#2257a0";
      base03 = "#5b6268";
      base04 = "#21242b";
      base05 = "#bbc2cf";
      base06 = "#efefef";
      base07 = "#efefef";
      base08 = "#c678dd";
      base09 = "#da8548";
      base0A = "#ecbe7b";
      base0B = "#98be65";
      base0C = "#46d9ff";
      base0D = "#51afef";
      base0E = "#ffa8ff";
      base0F = "#ff6c6b";
    };
  };
}
