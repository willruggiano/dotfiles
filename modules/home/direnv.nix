{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.direnv;
in {
  config = mkIf cfg.enable {
    programs.direnv.nix-direnv.enable = true;
    # programs.direnv.nix-direnv.enableFlakes = true;

    xdg.configFile = {
      "direnv/lib/export_alias.sh".source = let
        script = pkgs.writeShellApplication {
          name = "direnv-export-alias";
          text = ''
            export_alias() {
              local name=$1
              shift
              local alias_dir=$PWD/.direnv/aliases
              local target="$alias_dir/$name"
              local oldpath="$PATH"
              mkdir -p "$alias_dir"
              if ! [[ ":$PATH:" == *":$alias_dir:"* ]]; then
                PATH_add "$alias_dir"
              fi

              echo "#!/usr/bin/env bash" > "$target"
              echo "PATH=\"$oldpath\"" >> "$target"
              echo "$@" >> "$target"
              chmod +x "$target"
            }
          '';
        };
      in "${script}/bin/direnv-export-alias";
    };
  };
}
