{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "None";
      font = {
        normal.family = "FiraCode Nerd Font";
        size = 13.0;
      };
    };
  };
}
