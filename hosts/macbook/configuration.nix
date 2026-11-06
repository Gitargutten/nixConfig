{ pkgs, self, ...}:

{

  system.primaryUser = "andreasfosshaug";
  programs.zsh.enable = true;

  users.users.andreasfosshaug = {
      name = "andreasfosshaug";
      home = "/Users/andreasfosshaug";
      shell = pkgs.zsh;
    };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    casks = [
      "emacs"
      "actual"
      "android-studio"
      "anki"
      "autodesk-fusion"
      "balenaetcher"
      "bambu-studio"
      "bruno"
      "clion"
      "devutils"
      "discord"
      "draw-things"
      "espanso"
      "figma"
      "geogebra"
      "ghostty"
      "google-gemini"
      "grandperspective"
      "iina"
      "intellij-idea"
      "keka"
      "keyclu"
      "kicad"
      "mattermost"
      "moonlight"
      "musescore"
      "ngrok"
      "numi"
      "obsidian"
      "prismlauncher"
      "racket"
      "raycast"
      "spotify"
      "steam"
      "tailscale-app"
      "topaz-photo-ai"
      "topaz-video-ai"
      "tor-browser"
      "transmission"
      "utm"
      "visual-studio-code"
      "vlc"
      "vorssaint"
      "webstorm"
      "wireshark-app"
      "xquartz"
      "zed"
      "zen"
    ];
    brews = [

    ];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.macpm
    pkgs.moonlight
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };
}
