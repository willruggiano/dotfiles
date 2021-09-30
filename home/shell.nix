{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    awscli2
    curl
    fd
    file
    jq
    ranger
    ripgrep
    thefuck
    trash-cli
    unzip
    wget
    xplr
    yq
  ];

  programs.bat = {
    enable = true;
    config = {
      map-syntax = "*.tpp:C++";
    };
  };

  programs.command-not-found.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.starship = {
    enable = true;

    settings = {
      format = lib.concatStrings [
        "$hostname"
        "$line_break"
        "$directory"
        "$git_branch"
        "$nix_shell"
        "$line_break"
        "$character"
      ];
      scan_timeout = 30;
      command_timeout = 500;
      add_newline = true;

      character = {
        disabled = false;
        format = "$symbol ";
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vicmd_symbol = "[❮](bold green)";
      };

      directory = {
        disabled = false;
        truncation_length = 3;
        truncate_to_repo = true;
        fish_style_pwd_dir_length = 0;
        use_logical_path = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "cyan bold";
        read_only = "🔒";
        read_only_style = "red";
        truncation_symbol = "";
        home_symbol = "~";
      };

      git_branch = {
        disabled = false;
        format = "on [$symbol$branch]($style)(:[$remote]($style)) ";
        style = "bold purple";
        symbol = "";
        truncation_length = 9223372036854775807;
        truncation_symbol = "...";
        only_attached = false;
        always_show_remote = false;
      };

      nix_shell = {
        disabled = false;
        format = "using [nix-shell/$name](bold blue)";
      };

      hostname = {
        ssh_only = true;
        format = lib.concatStrings [
          "[$hostname](bold red)"
        ];
      };

      line_break = {
        disabled = false;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    completionInit = "autoload -Uz compinit && compinit";

    plugins = with pkgs; [
      {
        name = "fast-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
          sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
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
        src = fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "9d003fc02dbaa6db06e6b12e8c271398478e0b5d";
          sha256 = "0s4xj7yv75lpbcwl4s8rgsaa72b41vy6nhhc5ndl7lirb9nl61l7";
        };
      }
      {
        name = "fzf-marks";
        src = fetchFromGitHub {
          owner = "urbainvaes";
          repo = "fzf-marks";
          rev = "f5c986657bfee0a135fd14277eea857d58ea8cdc";
          sha256 = "11n33kx1v9mdgklhz7mkr673vln27nl02lyscybgc29fchwxfn8k";
        };
      }
      {
        name = "fzf-tab";
        src = fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "89a33154707c09789177a893e5a8ebbb131d5d3d";
          sha256 = "1g8011ldrghbw5ibchsp0p93r31cwyx2r1z5xplksd779jw79wdx";
        };
      }
      {
        name = "material-colors";
        src = fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "material-colors";
          rev = "47cbf2d955220cddc4d3e3845999f22ef270c90a";
          sha256 = "1g2dwl9siihcc0ixidfbsw99ywv2xd3v68kq270j2g3l1j2z59zn";
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
        name = "forgit";
        src = fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          rev = "9f3a4239205b638b8c535220bfec0b1fbca2d620";
          sha256 = "1w29ryc4l9pz60xbcwk0czxnhmjjh8xa6amh60whcapbsm174ssz";
        };
      }
    ];

    initExtra = with pkgs; ''
      eval $(thefuck --alias)

      # Completion settings
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
      zstyle ':completion:*:default' menu select=2
      zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
      zstyle ':completion:*:warnings' format '%F{RED}No matches for:%F{YELLOW} %d'$DEFAULT
      zstyle ':completion:*:options' description 'yes'
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*' list-separator '-->'
      zstyle ':completion:*:manuals' separate-sections true
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
      zstyle ':prompt:pure:git:stash' show yes
      autoload colors
      colors
      setopt hist_ignore_dups
      setopt hist_find_no_dups
      setopt share_history
      setopt noauto_cd
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt pushd_to_home
      setopt auto_param_slash
      setopt auto_param_keys
      setopt extended_glob

      # Gpg
      export GPG_TTY=$(tty)

      function encrypt() {
          local out="$1.$(date +%s).enc"
          ${pkgs.gnupg}/bin/gpg --encrypt --armor --output $out -r wmruggiano@gmail.com "$1" && echo "$1 -> $out"
      }

      function decrypt() {
          local out=$(echo "$1" | rev | cut -c16- | rev)
          ${pkgs.gnupg}/bin/gpg --decrypt --output $out "$1" && echo "$1 -> $out"
      }

      function gpg-reset-card() {
          ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
      }
      function git-turtle() {
          local n=""
          local branch=""
          local dryrun=false
          for a in "$@"; do
          case "$a" in
              -n)
                  shift; n="$1"; shift
                  ;;
              -b)
                  shift; branch="$1"; shift
                  ;;
              --dryrun)
                  shift; dryrun=true
                  ;;
          esac
          done
          [[ -z $n ]] || [[ -z $branch ]] && die '-n and -b|--branch are required'
          local git_reset="git reset --keep HEAD~$n"
          local git_check="git checkout -t -b $branch"
          local git_pick="git cherry-pick ..HEAD@{2}"
          if $dryrun; then
              echo "+ $git_reset"
              echo "+ $git_check"
              echo "+ $git_pick"
          else
              eval "$git_reset && $git_check && $git_pick"
          fi
      }

      [ -e $HOME/.user.zshrc ] && source $HOME/.user.zshrc
    '';

    shellAliases = with pkgs; {
      bat = "${bat}/bin/bat --paging=never";
      batp = "${bat}/bin/bat --paging=auto";
      cat = "${bat}/bin/bat";
      grep = "${ripgrep}/bin/rg --color=auto";
      hm = "home-manager";
      ls = "${exa}/bin/exa -F";
      la = "${exa}/bin/exa -a";
      ll = "${exa}/bin/exa -l";
      lla = "${exa}/bin/exa -al";
      lt = "${exa}/bin/exa --tree";
      tree = "${exa}/bin/exa --tree";
    };
  };

}
