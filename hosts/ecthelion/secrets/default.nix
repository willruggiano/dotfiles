let
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8WeTBtGhbaMf1TZ/aNFyJuEZpUo/N4ZA7F+5PIzjG1 root@ecthelion";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWXJHDkOTwqq+3W5JgBxGWyDNlhxVcQB/2lwBRwg8/f bombadil@ecthelion";
in {
  "bombadil@ecthelion.age".publicKeys = [root user];
  "willruggiano@github.age".publicKeys = [root user];
}
