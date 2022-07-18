# docsets

This is my custom docset package which comes with [Dash][dash] documentation for all languages that I care about.

## Updating

1. (optionally) add a new language
1. Run `nix run .#update-docsets` to update the docsets, which really just means updating the hashes for the respective source urls.
1. Run `sudo nixos-rebuild switch` to make the changes effective.

[dash]: https://kapeli.com/dash
