{
  inputs,
  config,
  pkgs,
  ...
}: {
  nix.package = pkgs.nixUnstable;

  users.users.marshall = {
    name = "marshall";
    home = "/Users/marshall";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.marshall = {pkgs, ...}: {
      imports = [../../home/mac.nix];
    };
  };
}
