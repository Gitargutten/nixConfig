{ pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;

    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;

    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 13;
      theme = "catppuccin-latte";
    };
  };
}
