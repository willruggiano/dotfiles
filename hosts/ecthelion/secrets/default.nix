let
  host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8WeTBtGhbaMf1TZ/aNFyJuEZpUo/N4ZA7F+5PIzjG1 root@ecthelion";
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWXJHDkOTwqq+3W5JgBxGWyDNlhxVcQB/2lwBRwg8/f bombadil@ecthelion";
in {
  "anthropic.age".publicKeys = [host user];
  "bombadil@ecthelion.age".publicKeys = [host user];
  "gemini.age".publicKeys = [host user];
  "openai.age".publicKeys = [host user];
  "willruggiano@github.age".publicKeys = [host user];
}
