{pkgs, ...}: {
  nix = {
    buildMachines = [
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        hostName = "192.168.4.106"; # ecthelion
        protocol = "ssh-ng";
        maxJobs = 8;
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        sshUser = "bombadil";
        supportedFeatures = ["benchmark" "big-parallel"];
      }
      {
        inherit (pkgs.stdenv.hostPlatform) system;
        hostName = "eu.nixbuild.net";
        protocol = "ssh-ng";
        maxJobs = 100;
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        supportedFeatures = ["benchmark" "big-parallel"];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
