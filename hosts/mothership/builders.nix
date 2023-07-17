{
  nix.buildMachines = [
    {
      hostName = "ecthelion";
      protocol = "ssh-ng";
      system = "x86_64-linux";
      sshUser = "bombadil";
      maxJobs = 8;
      speedFactor = 2;
    }
  ];
}
