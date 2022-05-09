# ecthelion

## Specs

TODO: Fill me in!

## Setup

NOTE: This system came with Windows 11 already installed.

### Windows setup

1. Install rufus
2. Download the nixos-minimal installer
3. Use rufus to create bootable USB using nixos-minial ISO
4. Restart (from ???) to boot from the USB

### Nixos setup

NOTE: This section basically followed the NixOS manual.

1. Partition and format the disk
  a. `parted /dev/nvme1n1`
    - NOTE: nvme1 is a separate drive specifically for NixOS
  b. `mklabel gpt`
  c. `mkpart primary 0GB -32GB`
  d. `mkpart primary linux-swap -32GB 100%`
  e. `mkfs.ext4 -L nixos /dev/nvme1n1p1`
  f. `mkswap -L swap /dev/nvme1n1p2`
2. Mount disks
  a. `mount /dev/disk/by-label/nixos /mnt`
  b. `mkdir /mnt/boot`
  c. `mount /dev/nvme0n1p1 /mnt/boot`
    - NOTE: nvme0 is the Windows drive, but contains the boot partition
  d. `swapon /dev/nvme1n1p2`
3. Generate initial NixOS configuration
  a. `nixos-generate-config --root /mnt`
  b. Edit /mnt/etc/nixos/configuration.nix and set the following attributes:
    - `nix.package = pkgs.nixFlakes;`
    - `nix.extraOptions = ''experimental-features = nix-command flakes'';`
4. Build and reboot
  a. `nixos-install`
  b. `reboot`
