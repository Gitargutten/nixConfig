{ pkgs, lib, config, ... }:

{
  programs.ghostty = {
    enable = true;

    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;

    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 13;
      theme = "Catppuccin Latte";

      macos-option-as-alt = true;
      window-decoration = false;
    };
  };

  home.file = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      "Library/Application Support/com.mitchellh.ghostty/config" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/ghostty/config";
      };
    };
}
