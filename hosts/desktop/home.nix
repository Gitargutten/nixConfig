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

  xdg.configFile."sunshine/sunshine.conf".text = ''
    capture = wlr
    encoder = software
  '';

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia"
    spawn-at-startup "pipewire"
    spawn-at-startup "pipewire-pulse"
    spawn-at-startup "wireplumber"
    spawn-at-startup "/run/wrappers/bin/sunshine"

    input {
      keyboard {
        xkb {
          layout "no"
        }
      }
    }

    binds {
    Mod+Shift+Slash { show-hotkey-overlay; }
    F1              { show-hotkey-overlay; }

    Mod+Return { spawn "alacritty"; }
    Alt+Return { spawn "alacritty"; }
    Mod+D      { spawn "noctalia" "launcher"; }
    Alt+D      { spawn "noctalia" "launcher"; }
    Mod+Q      { close-window; }
    Mod+Shift+E { quit; }

    Mod+Left  { focus-column-left; }
    Mod+Right { focus-column-right; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }

    Mod+Ctrl+Left  { move-column-left; }
    Mod+Ctrl+Right { move-column-right; }

    Mod+Page_Down { focus-workspace-down; }
    Mod+Page_Up   { focus-workspace-up; }
    Mod+F         { maximize-column; }
    Mod+Shift+F   { fullscreen-window; }
  }
  '';

  home.packages = with pkgs; [
    htop
    wl-clipboard
    libnotify
  ];
}
