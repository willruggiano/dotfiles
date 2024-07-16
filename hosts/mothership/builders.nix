{config, ...}: {
  nix = {
    buildMachines = [
      {
        hostName = "192.168.4.38";
        protocol = "ssh-ng";
        system = "x86_64-linux";
        sshUser = "bombadil";
        sshKey = "${config.user.home}/.ssh/id_ed25519";
        maxJobs = 32;
        speedFactor = 4;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
