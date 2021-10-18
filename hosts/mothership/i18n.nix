{ lib }:

with lib;

{
  time.timeZone = mkDefault "America/Denver";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
}
