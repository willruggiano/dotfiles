# nvim-treesitter, for nixos

This is my custom nvim-treesitter package which comes with all of the treesitter parsers that I care about.

## Why not just :TSInstall

`:TSInstall` works fine and dandy on non-NixOS systems. NixOS however is special.
Specifically in the context of treesitter parsers (or actually any linked program/library/etc), nix performs some magic under the hood to explicitly specify dynamic dependencies for compiled projects (naively: per program LD*LIBRARY_PATH, etc environment variables). This is how nix achieves both sandboxing and reproducibility. There are no "system" libraries.
Therein lies the problem. Many treesitter parsers require dynamically linked libraries (namely: libstdc++) which are typically \_system* libraries... but not on NixOS!
This results in dynamic library loading errors at runtime when treesitter parsers are loaded! There are workarounds (direnv for example) but these are just that: workarounds.

## Why not use nixpkg treesitter parsers

The short answer... we can't guarantee compatibility between the parsers and nvim-treesitter.

We could hack it together but that would require _manually_ mapping nixpkg versions of the parsers with whatever nvim-treesitter we are using (could be a nixpkg or not). That sounds excruciating, doesn't it?

So...

## How does it work?

It's pretty simple really. nvim-treesitter has a lockfile that identifies the specific revision of each parser for the current revision of nvim-treesitter; this is used when lay people (non-NixOS users) install parsers via `:TSInstall`. We use it too! However instead of invoking `:TSInstall` from within neovim, we build parsers at nixos-rebuild time.

1. We keep a table identifying the grammars we are interested in. This table, at a minimum, must specify the _owner_ of the git repository (typically "tree-sitter"). It can also optionally specify repository name (if it does not follow standard convention) and/or the url (if it not hosted on GitHub).
2. We provide a helper derivation that invokes nix-prefetch-git to determine the sha256 hash of each grammar. These are stored in [the grammar](./grammar) directory and committed to git.
3. We create derivations for each grammar in our table using the generated grammar revision data; we literally `lib.importJSON` the generated json file and use the value as the `src` argument to `stdenv.mkDerivation`.
4. When building the actual nvim-treesitter derivation (the neovim plugin), we copy the compiled parser library from each grammar derivation into the derivation output of nvim-treesitter where `:TSInstall` would install them (`$out/parser/$parserName.so` -> `stdpath("data")/site/pack/.../nvim-treesitter/parser/$parserName.so`). A nice consequence of this is that `:TSInstallInfo` shows our parsers as installed!

And that's really it! This method is nice because:

- We take advantage of nix's magic abilities to create fully self-contained compiled programs (which means we don't have to worry about environmental problems, e.g. direnv setting LD_LIBRARY_PATH, or manually recompiling treesitter parsers after we update nvim-treesitter).
- We avoid nixpkg incompatibility between nvim-treesitter and the installed parsers; we let nvim-treesitter tell us which revisions to use.
- It's all self-contained! No need to specify `user.packages = [pkgs.treesitter.withGrammars (gs: with gs; cpp lua nix python ...)]` (or whatever it is).

## Updating

1. Replace the `rev` for nvim-treesitter with whatever commit hash you want to use.
2. Run `nix run .#update-treesitter-parsers` to update the parsers based on the lockfile present within nvim-treesitter.
3. Run `sudo nixos-rebuild switch` to make the changes effective.
