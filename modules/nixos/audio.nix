{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (!config.services.pipewire.enable) {
    sound.enable = true;
    user.extraGroups = ["audio"];
  };
}
