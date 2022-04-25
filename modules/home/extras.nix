{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.suites;
  mkExtra = name: packages:
    mkIf cfg."${name}".enable {
      home.packages = packages;
    };
in {
  options.suites = {
    aws.enable = mkEnableOption "Enable aws tools";
    file.enable = mkEnableOption "Enable file system/transfer tools";
  };

  config = mkMerge [
    (mkExtra "aws" [pkgs.awscli2])
    (mkExtra "file" [
      pkgs.curl
      pkgs.fd
      pkgs.file
      pkgs.qrcp
      pkgs.ripgrep
      pkgs.sad
      pkgs.speedtest-cli
      pkgs.trash-cli
      pkgs.unzip
      pkgs.wget
    ])
  ];
}
