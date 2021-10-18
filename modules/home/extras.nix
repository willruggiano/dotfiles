{ options, config, lib, pkgs, ... }:

with lib;

let cfg = config.suites.extras;
in
{
  options = {
    suites.extras = {
      awscli.enable = mkEnableOption "Enable awscli v2";
      curl.enable = mkEnableOption "Enable curl";
      fd.enable = mkEnableOption "Enable fd";
      file.enable = mkEnableOption "Enable file";
      jq.enable = mkEnableOption "Enable jq";
      qrcp.enable = mkEnableOption "Enable qrcp";
      ranger.enable = mkEnableOption "Enable ranger";
      ripgrep.enable = mkEnableOption "Enable ripgrep";
      thefuck.enable = mkEnableOption "Enable thefuck";
      trash-cli.enable = mkEnableOption "Enable trash-cli";
      unzip.enable = mkEnableOption "Enable unzip";
      wget.enable = mkEnableOption "Enable wget";
      xplr.enable = mkEnableOption "Enable xplr";
      yq.enable = mkEnableOption "Enable yq";
    };
  };

  config = (mkMerge [
    (mkIf cfg.awscli.enable {
      home.packages = [ pkgs.awscli2 ];
    })
    (mkIf cfg.curl.enable {
      home.packages = [ pkgs.curl ];
    })
    (mkIf cfg.fd.enable {
      home.packages = [ pkgs.fd ];
    })
    (mkIf cfg.file.enable {
      home.packages = [ pkgs.file ];
    })
    (mkIf cfg.jq.enable {
      home.packages = [ pkgs.jq ];
    })
    (mkIf cfg.qrcp.enable {
      home.packages = [ pkgs.qrcp ];
    })
    (mkIf cfg.ranger.enable {
      home.packages = [ pkgs.ranger ];
    })
    (mkIf cfg.ripgrep.enable {
      home.packages = [ pkgs.ripgrep ];
    })
    (mkIf cfg.thefuck.enable {
      home.packages = [ pkgs.thefuck ];
    })
    (mkIf cfg.trash-cli.enable {
      home.packages = [ pkgs.trash-cli ];
    })
    (mkIf cfg.unzip.enable {
      home.packages = [ pkgs.unzip ];
    })
    (mkIf cfg.wget.enable {
      home.packages = [ pkgs.wget ];
    })
    (mkIf cfg.xplr.enable {
      home.packages = [ pkgs.xplr ];
    })
    (mkIf cfg.yq.enable {
      home.packages = [ pkgs.yq ];
    })
  ]);
}
