# colorctl

A commandline utility to unify your system (and application) colorschemes.

## Usage

```sh
$ colorctl build bat && bat cache --clear && bat cache --build
```

## Description

colorctl essentially brings together many forks of existing solutions to similar problems. Notably;

- [lush.nvim][lush]
- [shipwright.nvim][shipwright]

The original idea (which started out a simple script) was to use [lush][lush] to define a color scheme/palette, and then use [shipwright][shipwright] to generate application-specific theme files.
This is actually exactly what shipwright already allows you to do! (for a minimal, pre-defined set of applications, mainly terminals)

## TODO

[ ] Configuration file
[ ] Automation; maybe a "build all" command, "build-and-apply all", etc
[ ] AwesomeWM; so annoying

[lush]: https://github.com/rktjmp/lush.nvim
[shipwright]: https://github.com/rktjmp/shipwright.nvim
