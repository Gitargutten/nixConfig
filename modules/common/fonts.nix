{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
}
