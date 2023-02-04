{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.zsh;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [atuin bc thefuck units];

    programs.nix-index.enable = true;

    programs.zsh = {
      dotDir = ".config/zsh";

      enableCompletion = true;
      completionInit = "autoload -Uz compinit && compinit";

      plugins = with pkgs; [
        {
          name = "fzf-tab";
          src = fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "master";
            hash = "sha256-ixUnuNtxxmiigeVjzuV5uG6rIBPY/1vdBZF2/Qv0Trs=";
          };
        }
        {
          name = "clipboard";
          src = fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "7a4f4ad91e1f937b36a54703984b958abe9da4b8";
            sha256 = "1p43x3sx54h4vgbaa4iz3j1yj4d0qcnxlcq9c2z4q6j7021gjbvi";
          };
          file = "lib/clipboard.zsh";
        }
        {
          name = "enhancd";
          src = fetchFromGitHub {
            owner = "b4b4r07";
            repo = "enhancd";
            rev = "master";
            hash = "sha256-p7ZG4NC9UWa55tPxYAaFocc0waIaTt+WO6MNearbO0U=";
          };
          file = "init.sh";
        }
        {
          name = "fast-syntax-highlighting";
          inherit (pkgs.zsh-fast-syntax-highlighting) src;
        }
        {
          name = "forgit";
          src = fetchFromGitHub {
            owner = "wfxr";
            repo = "forgit";
            rev = "master";
            hash = "sha256-9ApobX4Q2v/87uzFpNGmV245K4Lueo67VTzvg3QHeM4=";
          };
        }
        {
          name = "fzf-marks";
          src = fetchFromGitHub {
            owner = "urbainvaes";
            repo = "fzf-marks";
            rev = "master";
            hash = "sha256-QXJkt/62gPv3pN0jqyNlHNx6K1OocTGaAg87dL1vwJE=";
          };
        }
        {
          name = "magic-enter";
          src = fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "7a4f4ad91e1f937b36a54703984b958abe9da4b8";
            sha256 = "1p43x3sx54h4vgbaa4iz3j1yj4d0qcnxlcq9c2z4q6j7021gjbvi";
          };
          file = "plugins/magic-enter/magic-enter.plugin.zsh";
        }
        {
          name = "zsh-autopair";
          inherit (pkgs.zsh-autopair) src;
        }
        {
          name = "zsh-autosuggestions";
          inherit (pkgs.zsh-autosuggestions) src;
        }
      ];

      initExtraBeforeCompInit = ''
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions "${config.home.profileDirectory}"/share/zsh/vendor-completions)

        for f in $HOME/.config/zsh/extra/0[0-9]-*.zsh; do
          source "$f"
        done
      '';

      initExtra = ''
        for f in $HOME/.config/zsh/extra/1[0-9]-*.zsh; do
          source "$f"
        done

        [ -e $HOME/.zshrc ] && source $HOME/.zshrc
      '';

      shellAliases = with pkgs; {
        bat = "${bat}/bin/bat --paging=never";
        batp = "${bat}/bin/bat --paging=auto";
        cat = "${bat}/bin/bat";
        grep = "${ripgrep}/bin/rg --color=auto";
        ls = "${exa}/bin/exa -F";
        la = "${exa}/bin/exa -a";
        ll = "${exa}/bin/exa -l";
        lla = "${exa}/bin/exa -al";
        lt = "${exa}/bin/exa --tree";
        tree = "${exa}/bin/exa --tree";
      };
    };

    home.sessionVariables = {
      ENHANCD_FILTER = "fzf";
      ENHANCD_DISABLE_DOT = 1;
    };

    xdg.configFile = {
      "zsh/extra" = {
        source = ../../.config/zsh;
        recursive = true;
      };
    };
  };
}
