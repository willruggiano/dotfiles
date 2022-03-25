{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.git;
  smerge =
    if pkgs.stdenv.isDarwin
    then "smerge" # Will be installed via homebrew
    else "${pkgs.sublime-merge}/bin/smerge $MERGED";
in
{
  config = mkIf cfg.enable
    {
      home.packages = with pkgs; [
        delta
        git
        gitflow
        git-quickfix
        lazygit
        pre-commit
        tig
      ] ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        sublime-merge
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
            diffFilter = "${pkgs.delta}/bin/delta --color-only";
          };
          merge = {
            conflictStyle = "zdiff3";
            tool = "smerge";
          };
          mergetool = {
            keepBackup = false;
            fugitive = {
              cmd = ''nvim -f -c "Gvdiffsplit!" $MERGED'';
            };
            nvim = {
              cmd = ''nvim -d $LOCAL $MERGED $REMOTE'';
            };
            smerge = {
              cmd = "${smerge}";
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

      xdg.configFile = {
        "lazygit/config.yml".text = ''
          git:
            autoFetch: false
          keybinding:
            universal:
              quit: '<c-c>'
              return: 'q'
        '';
      };
    };
}
