{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.fzf;
in {
  config = mkIf cfg.enable {
    programs.fzf = {
      defaultCommand = ''${pkgs.ripgrep}/bin/rg --files --hidden --glob "!.git" --no-ignore'';
      defaultOptions = [
        "--no-mouse"
        "--height 50%"
        "-1"
        "--reverse"
        "--multi"
        "--preview='[[ \\$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2>/dev/null | head -30\'"
        "--preview-window='right:hidden:wrap'"
        "--bind='f3:execute(bat --style=numbers {} || less -f {}),ctrl-p:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept'"
      ];
      changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
      changeDirWidgetOptions = ["--preview '${pkgs.bat}/bin/bat {}'"];
      fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
      fileWidgetOptions = [
        "--select-1"
        "--exit-0"
      ];
    };

    xdg.configFile."zsh/extra/99-fzf.zsh".text = ''
      # Generated by Nix
      is_in_git_repo() {
        git rev-parse HEAD > /dev/null 2>&1
      }

      gf() {
        is_in_git_repo || return
        git -c color.status=always status --short |
        fzf -m --ansi --nth 2..,.. \
            --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
          cut -c4- | sed 's/.* -> //'
      }

      gb() {
        is_in_git_repo || return
        git branch -a --color=always | grep -v '/HEAD\s' | sort |
        fzf --ansi --multi --tac --preview-window right:70% \
            --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
          sed 's/^..//' | cut -d' ' -f1 |
          sed 's#^remotes/##'
      }

      gt() {
        is_in_git_repo || return
        git tag --sort -version:refname |
        fzf --multi --preview-window right:70% --preview 'git show --color=always {}'
      }

      gc() {
        is_in_git_repo || return
        git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
        fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
            --header 'Press CTRL-S to toggle sort' \
            --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
          grep -o "[a-f0-9]\{7,\}"
      }

      gr() {
        is_in_git_repo || return
        git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf --tac --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
          cut -d$'\t' -f1
      }

      gs() {
        is_in_git_repo || return
        git stash list | fzf --reverse -d: --preview 'git show --color=always {1}' |
          cut -d: -f1
      }
    '';
  };
}
