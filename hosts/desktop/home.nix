{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/common/starship.nix
    ../../modules/common/programs.nix
    ../../modules/common/ghostty.nix
    inputs.noctalia.homeModules.default
    inputs.zen-browser.homeModules.default
    inputs.lig.homeModules.default
  ];

  home.username = "andreas";
  home.homeDirectory = "/home/andreas";
  home.stateVersion = "26.05";

  programs.noctalia = {
    enable = true;
  };
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.lig = {
    enable = true;
    settings = {
      ui.theme = "catppuccin";
    };
  };

  xdg.configFile."sunshine/sunshine.conf".text = ''
    capture = wlr
    encoder = software
  '';

  xdg.configFile."niri/config.kdl".text = ''
    output "DP-1" {
      focus-at-startup
      position x=1334 y=175
    }
    output "HDMI-A-1" {
      transform "90"
      scale 0.9
      position x=0 y=0
    }
    spawn-at-startup "noctalia"
    spawn-at-startup "pipewire"
    spawn-at-startup "pipewire-pulse"
    spawn-at-startup "wireplumber"
    spawn-at-startup "/run/wrappers/bin/sunshine"

    input {
      keyboard {
        xkb {
          layout "gb"
          variant "mac"
          options "altwin:swap_alt_win,lv3:ralt_switch,caps:escape"
        }
      }
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }
      F1              { show-hotkey-overlay; }

      Mod+Return { spawn "ghostty"; }
      Mod+Space      { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
      Mod+W      { close-window; }
      Mod+Shift+E { quit; }

      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-workspace-down; }
      Mod+K { focus-workspace-up; }

      Mod+Alt+H { focus-monitor-left; }
      Mod+Alt+L { focus-monitor-right; }

      Mod+Ctrl+H  { move-column-left; }
      Mod+Ctrl+L { move-column-right; }
      Mod+Ctrl+J  { move-column-to-workspace-down; }
      Mod+Ctrl+K  { move-column-to-workspace-up; }

      Mod+Ctrl+Alt+H { move-column-to-monitor-left; }
      Mod+Ctrl+Alt+L { move-column-to-monitor-right; }


      Mod+F         { maximize-column; }
    }

    window-rule {
      min-width 1200
      geometry-corner-radius 12
      clip-to-geometry true
    }

    layout {
      always-center-single-column
      default-column-width { proportion 0.5; }
      focus-ring {
        width 2
      }
    }
  '';

  home.packages = with pkgs; [
    htop
    wl-clipboard
    libnotify
  ];
}
