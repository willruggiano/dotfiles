{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.git;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      delta
      git
      gitflow
      pre-commit
      sublime-merge
      tig
    ];

    programs.gh = {
      enable = true;
      enableGitCredentialHelper = false;
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };

    programs.git = {
      extraConfig = {
        color = {
          ui = "auto";
        };
        core = {
          pager = "delta";
        };
        credential = {
          "https://github.com" = {
            helper = "!gh auth git-credential";
          };
        };
        delta = {
          features = "side-by-side line-numbers decorations";
          whitespace-error-style = "22 reverse";
        };
        include = {
          path = "${config.home.homeDirectory}/.gitconfig";
        };
        init = {
          defaultBranch = "main";
        };
        interactive = {
          diffFilter = "delta --color-only";
        };
        merge.tool = "smerge";
        mergetool = {
          keepBackup = false;
          nvim = {
            cmd = "nvim -f -c \"Gdiffsplit!\" $MERGED";
          };
          smerge = {
            cmd = "${pkgs.sublime-merge}/bin/smerge $MERGED";
          };
        };
        user = {
          signingkey = "79303BEC95097CB6";
        };
      };
      aliases = {
        dag = "log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)\"%an\" <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order";
        ll = "log -n1";
        lo = "log --oneline";
        llo = "log -n1 --oneline";
        loq = "log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative";
        amend = "commit -a --amend --no-edit";
      };
    };
  };
}
