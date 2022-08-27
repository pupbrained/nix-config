let
  nix = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMaV1QnlyQn0eVe7Gl3j5K7BEedEdPe0IhYYnKOXPmeR";
  systems = [nix];

  mars = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA12eoS+C+n1Pa1XaygSmx4+CGkO6oYV5bZeSeBU28Y";
  users = [mars];
in {
  "secrets.age".publicKeys = users ++ systems;
}
