{ config, pkgs, lib, ... }:

{
  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --hidden --glob \"!.git\" --no-ignore ";
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
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'bat {}'" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [
      "--select-1"
      "--exit-0"
    ];
  };
}
