{
  writeShellApplication,
  alsa-utils,
  coreutils,
  gawk,
  gnugrep,
  ...
}:
writeShellApplication {
  name = "eww-vol";
  runtimeInputs = [alsa-utils coreutils gawk gnugrep];
  text = ''
    # shellcheck disable=SC2016
    amixer sget Master | grep 'Left:' | awf -F'[][]' '{ print $2 }' | tr -d '%' | head -1
  '';
}
