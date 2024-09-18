{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.git;
  yaml = pkgs.formats.yaml {};
in {
  options.programs.git = {
    signingKey = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        awscli
        git-absorb
        git-branchless
        git-crypt
        git-lfs
        git-quickfix
        git-trim
        gitflow
        rs-git-fsmonitor
        spr
        sublime-merge
        watchman
      ];

      programs.git = {
        lfs.enable = true;
        config = {
          alias = {
            can = "commit -a --amend --no-edit";
            co = "checkout";
            pristine = "clean -dffx";
            ss = "sync 'stack()'";
            stack = "!spr";
          };
          color.ui = "auto";
          commit.gpgsign = true;
          include.path = "/home/bombadil/.gitconfig";
          init.defaultBranch = "main";
          merge = {
            conflictStyle = "zdiff3";
            tool = "diffview";
          };
          mergetool = {
            keepBackup = false;
            diffview.cmd = "nvim +DiffviewOpen";
            fugitive.cmd = ''nvim -f -c "Gdiffsplit!" $MERGED'';
            nvim.cmd = "nvim -d $LOCAL $MERGED $REMOTE";
            smerge.cmd = "smerge $MERGED";
            push.followTags = true;
          };
          spr = {
            requireTestPlan = false;
          };
          user = {
            email = "wmruggiano@gmail.com";
            name = "Will Ruggiano";
            signingkey = cfg.signingKey;
          };
        };
      };
    }
    {
      environment.systemPackages = [pkgs.delta];
      programs.git.config = {
        core.pager = "delta";
        delta = {
          features = "side-by-side line-numbers decorations";
          whitespace-error-style = "22 reverse";
        };
        interactive.diffFilter = "delta --color-only";
      };
    }
    {
      environment.systemPackages = [pkgs.gh];
      environment.interactiveShellInit = ''
        export GH_TOKEN="$(cat ${config.age.secrets."willruggiano@github".path})"
      '';
      programs.git.config = {
        credential = {
          "https://github.com" = {
            helper = "!gh auth git-credential";
          };
        };
      };
    }
    {
      environment.systemPackages = [
        pkgs.lazygit
        (pkgs.writeShellApplication {
          name = "git";
          text = ''
            if [[ $# -eq 0 ]]; then
                lazygit
            else
                ${cfg.package}/bin/git "$@"
            fi
          '';
        })
      ];
      home.configFile = {
        "lazygit/config.yml".source = yaml.generate "lazygit-config" {
          git = {
            autoFetch = false;
          };
          gui = {
            nerdFontsVersion = 3;
            theme = with config.lib.stylix.colors.withHashtag; {
              activeBorderColor = [base0B "bold"];
              # inactiveBorderColor = ["default"];
              # searchingActiveBorderColor = ["cyan" "bold"];
              optionsTextColor = [base04];
              selectedLineBgColor = [base04];
              # inactiveViewSelectedLineBgColor = ["bold"];
              # cherryPickedCommitFgColor = ["blue"];
              # cherryPickedCommitBgColor = ["cyan"];
              # markedBaseCommitFgColor = ["blue"];
              # markedBaseCommitBgColor = ["yellow"];
              unstagedChangesColor = [base08];
              defaultFgColor = ["default"];
            };
          };
        };
      };
    }
  ]);
}
