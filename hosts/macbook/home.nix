{ config, inputs, username, ...}:

{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa"];
  imports = [
    ../../modules/common/programs.nix
    ../../modules/common/starship.nix
    ../../modules/common/ghostty.nix
    ../../modules/common/zed.nix

    ../../modules/macbook/programs.nix

    inputs.paneru.homeModules.paneru
  ];
  services.skhd = {
    enable = true;
    config = ''
      cmd - h : :
    '';
  };


  services.paneru = {
      enable = true;
      # Paneru configuration
      # See CONFIGURATION.md for a list of all options
      settings = {
        options = {
          focus_follows_mouse = true;
          mouse_follows_focus = true;
          preset_column_widths = [0.25 0.33 0.5 0.66 0.75];
        };
        bindings = {
          window_focus_west = "cmd - h";
          window_focus_east = "cmd - l";
          window_swap_west = "cmd + shift - h";
          window_swap_east = "cmd + shift - l";
          window_resize = "alt - r";
          window_center = "alt - c";
          window_balance = "alt - b";
          quit = "ctrl + alt - q";
        };
      };
    };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
  };
}
