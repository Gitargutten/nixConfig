{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/common/starship.nix
    ../../modules/common/programs.nix
    inputs.noctalia.homeModules.default
  ];

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";
  home.stateVersion = "26.05";

  programs.noctalia = {
    enable = true;
  };

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia"

    inputs {
      keyboard {
        xkb {
          layout "no"
        }
      }
    }

    binds {
      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "noctalia" "launcher"; }
      Mod+Q { close-window; }
      Mod+Shift+E { quit; }
    }
  '';

  home.packages = with pkgs; [
    htop
    wl-clipboard
    libnotify
  ];
}
