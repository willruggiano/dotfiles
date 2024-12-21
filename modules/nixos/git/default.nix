{
  config,
  inputs,
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

  config = mkIf cfg.enable {
    environment.interactiveShellInit = ''
      export GH_TOKEN="$(cat ${config.age.secrets."willruggiano@github".path})"
    '';

    environment.systemPackages = with pkgs; [
      delta
      difftastic
      gh
      git-absorb
      git-branchless
      git-crypt
      git-lfs
      git-quickfix
      git-trim
      gitflow
      lazygit
      rs-git-fsmonitor
      spr
      sublime-merge
      watchman
      inputs.mergiraf.packages.${pkgs.system}.default
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

    programs.git = {
      config = {
        advice.detachedHead = false;
        alias = {
          can = "commit -a --amend --no-edit";
          co = "checkout";
          pristine = "clean -dffx";
          ss = "sync 'stack()'";
          stack = "!spr";
        };
        color.ui = "auto";
        commit.gpgsign = true;
        core = {
          attributesfile = config.environment.etc.gitattributes.source;
          excludesfile = config.environment.etc.gitignore.source;
          pager = "delta";
        };
        credential = {
          "https://github.com" = {
            helper = "!gh auth git-credential";
          };
        };
        delta = {
          navigate = true; # use n and N to move between diff sections
          side-by-side = true;
          whitespace-error-style = "22 reverse";
        };
        diff.external = "difft";
        init.defaultBranch = "main";
        interactive.diffFilter = "delta --color-only";
        lfs.enable = true;
        merge = {
          conflictStyle = "zdiff3";
          keepBackup = false;
          tool = "nvim";
          # driverz
          mergiraf = {
            name = "mergiraf";
            driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
          };
        };
        mergetool = {
          keepBackup = false;
          prompt = false; # run the mergetool immediately
          push.followTags = true;
          # toolz
          diffview.cmd = "nvim +DiffviewOpen";
          fugitive.cmd = ''nvim -f -c "Gdiffsplit!" $MERGED'';
          nvim.cmd = "nvim -d $LOCAL $MERGED $REMOTE";
          smerge.cmd = "smerge $MERGED";
        };
        push.autoSetupRemote = true;
        rebase = {
          autoSquash = true;
          autoStash = true;
          stat = true;
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

    environment.etc = {
      "gitattributes".text = ''
        # generated by nix
        *.c merge=mergiraf
        *.cc merge=mergiraf
        *.cpp merge=mergiraf
        *.cs merge=mergiraf
        *.dart merge=mergiraf
        *.go merge=mergiraf
        *.h merge=mergiraf
        *.hpp merge=mergiraf
        *.htm merge=mergiraf
        *.html merge=mergiraf
        *.java merge=mergiraf
        *.js merge=mergiraf
        *.json merge=mergiraf
        *.jsx merge=mergiraf
        *.py merge=mergiraf
        *.rs merge=mergiraf
        *.sbt merge=mergiraf
        *.scala merge=mergiraf
        *.ts merge=mergiraf
        *.xhtml merge=mergiraf
        *.xml merge=mergiraf
        *.yaml merge=mergiraf
        *.yml merge=mergiraf
      '';
      "gitignore".text = ''
        # generated by nix
        .envrc
        .devenv/
        .direnv/
      '';
    };

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
  };
}
