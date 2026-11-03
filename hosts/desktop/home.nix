{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common/starship.nix
    ../../modules/common/programs.nix
  ];

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    htop
  ];
}
