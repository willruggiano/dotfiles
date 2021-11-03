{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.suites.extras;
  mkExtra = name: packages:
    mkIf cfg.${name}.enable {
      home.packages = packages;
    };
in
{
  options.suites.extras = {
    awscli.enable = mkEnableOption "Enable awscli v2";
    curl.enable = mkEnableOption "Enable curl";
    fd.enable = mkEnableOption "Enable fd";
    file.enable = mkEnableOption "Enable file";
    qrcp.enable = mkEnableOption "Enable qrcp";
    ranger.enable = mkEnableOption "Enable ranger";
    ripgrep.enable = mkEnableOption "Enable ripgrep";
    thefuck.enable = mkEnableOption "Enable thefuck";
    trash-cli.enable = mkEnableOption "Enable trash-cli";
    unzip.enable = mkEnableOption "Enable unzip";
    wget.enable = mkEnableOption "Enable wget";
    xplr.enable = mkEnableOption "Enable xplr";
  };

  config = (mkMerge [
    # TODO: Could probably generate this by inspecting the attributes of options.suites.extras
    (mkExtra "awscli" [ pkgs.awscli2 ])
    (mkExtra "curl" [ pkgs.curl ])
    (mkExtra "fd" [ pkgs.fd ])
    (mkExtra "file" [ pkgs.file ])
    (mkExtra "qrcp" [ pkgs.qrcp ])
    (mkExtra "ranger" [ pkgs.ranger ])
    (mkExtra "ripgrep" [ pkgs.ripgrep ])
    (mkExtra "thefuck" [ pkgs.thefuck ])
    (mkExtra "trash-cli" [ pkgs.trash-cli ])
    (mkExtra "unzip" [ pkgs.unzip ])
    (mkExtra "wget" [ pkgs.wget ])
    (mkExtra "xplr" [ pkgs.xplr ])
  ]);
}
