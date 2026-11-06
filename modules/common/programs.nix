{ pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
    };
  };

  programs.tmux = {
    enable = true;
    newSession = true;
    keyMode = "vi";
  };

  home.packages = with pkgs; [
    fzf
    pkgs.neo-cowsay
    pkgs.docker
    pkgs.neovim
    pkgs.nmap
    pkgs.sl
    pkgs.tldr
    pkgs.tree
    pkgs.wget
  ];
}
