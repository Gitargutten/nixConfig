{ config, pkgs, ...}:

{
  imports = [
    ../../modules/common/starship.nix
  ];

  home = {
    username = "andreasfosshaug";
    homeDirectory = "/Users/andreasfosshaug";
    stateVersion = "24.05";
  };

}
