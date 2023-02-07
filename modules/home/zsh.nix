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
    home.packages = with pkgs; [atuin bc exa thefuck units];

    programs.zsh = {
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      enableCompletion = true;

      history.path = "$XDG_DATA_HOME/zsh/history";

      plugins = with pkgs; [
        {
          name = "atuin";
          inherit (pkgs.atuin) src;
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
          inherit (pkgs.oh-my-zsh) src;
          file = "plugins/magic-enter/magic-enter.plugin.zsh";
        }
      ];

      initExtra = ''
        setopt auto_pushd
        setopt pushd_ignore_dups
        setopt pushd_to_home
        setopt auto_param_slash
        setopt auto_param_keys
        setopt extended_glob

        bindkey '^y' autosuggest-accept
        bindkey '^p' _atuin_search_widget

        zstyle ':prompt:pure:git:stash' show yes

        eval "$(thefuck --alias)"

        export GPG_TTY=$(tty)

        autoload colors
        colors

        zstyle ':completion:*' verbose yes
        zstyle ':completion:*' completer _extensions _complete _history
        zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
        zstyle ':completion:*:warnings' format '%F{RED}No matches for:%F{YELLOW} %d'$DEFAULT
        zstyle ':completion:*:options' description 'yes'
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*' list-separator '-->'
        zstyle ':completion:*:manuals' separate-sections true

        for f in $HOME/.config/zsh/extra/*.zsh; do
          source "$f"
        done

        [ -e $HOME/.zshrc ] && source $HOME/.zshrc
      '';

      shellAliases = {
        bat = "bat --paging=never";
        batp = "bat --paging=auto";
        cat = "bat";
        fvim = "nvim $(fzf)";
        nvim-clear = "nvim --headless -c LuaCacheClear -c q && nvim";
        git = "lg";
        grep = "rg --color=auto";
        ls = "exa -F";
        la = "exa -a";
        ll = "exa -l";
        lla = "exa -al";
        lt = "exa --tree";
        nix = "noglob nix";
        tree = "exa --tree";
      };
    };

    home.sessionVariables = {
      ATUIN_NOBIND = "true";
      ENHANCD_FILTER = "fzf";
      ENHANCD_DISABLE_DOT = 1;
    };

    xdg.configFile = let
      toml = pkgs.formats.toml {};
    in {
      "atuin/config.toml".source = toml.generate "atuin-config" {
        update_check = false;
        search_mode = "fuzzy";
        filter_mode = "directory";
      };

      "zsh/extra" = {
        source = ../../.config/zsh/extra;
        recursive = true;
      };
    };
  };
}
