{
  inputs,
  pkgs,
  config,
  ...
}: {
  nix.package = pkgs.nixUnstable;

  users.users.marshall = {
    name = "marshall";
    home = "/Users/marshall";
  };

  home-manager.users.marshall = {pkgs, ...}: {
    specialArgs = { inherit inputs; };
    imports = [ ../../home/mac.nix ];
  };
}
