{ config, pkgs, ...}:

{
  imports = [
    ../../modules/common/programs.nix
    ../../modules/common/starship.nix
    ../../modules/common/ghostty.nix

    ../../modules/macbook/programs.nix
  ];

  home = {
    username = "andreasfosshaug";
    homeDirectory = "/Users/andreasfosshaug";
    stateVersion = "24.05";
  };
}
