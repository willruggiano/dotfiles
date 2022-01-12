# vim: ft=nix
{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.zsh;
in
{
  options.programs.zsh = {
    colorscheme = mkOption {
      type = types.str;
      default = "snazzy";
      description = "The vivid colorscheme to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ atuin bc thefuck units ];

    programs.nix-index.enable = true;

    programs.zsh = {
      dotDir = ".config/zsh";

      enableAutosuggestions = true;

      enableCompletion = true;
      completionInit = "autoload -Uz compinit && compinit";

      plugins = with pkgs; [
        {
          name = "atuin";
          src = fetchFromGitHub {
            owner = "ellie";
            repo = "atuin";
            rev = "v0.7.1";
            hash = "sha256-jjGP8YeHnEr0f9RONwA6wZT872C0jXTvSRdt9zAu6KE=";
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
            rev = "aec0e0c1c0b1376e87da74b8940fda5657269948";
            hash = "sha256-j50+2cOXhmJ8VmYj5oVQRJXP/iayrEk3VugVIadgwo4=";
          };
          file = "init.sh";
        }
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
          name = "forgit";
          src = fetchFromGitHub {
            owner = "wfxr";
            repo = "forgit";
            rev = "9f3a4239205b638b8c535220bfec0b1fbca2d620";
            sha256 = "1w29ryc4l9pz60xbcwk0czxnhmjjh8xa6amh60whcapbsm174ssz";
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
      ];

      initExtraBeforeCompInit = ''
        fpath+=("${config.home.profileDirectory}"/share/zsh/site-functions "${config.home.profileDirectory}"/share/zsh/$ZSH_VERSION/functions "${config.home.profileDirectory}"/share/zsh/vendor-completions)
      '';
      initExtra = with pkgs; ''
        for f in $HOME/.config/zsh/extra/[0-9][0-9]-*.zsh; do
          source "$f"
        done

        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate ${cfg.colorscheme})"

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
