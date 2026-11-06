{ pkgs, ...}:

{
  home.packages = with pkgs; [
    pkgs.ffmpeg
    pkgs.imagemagick
    pkgs.magic-wormhole
    pkgs.mole-cleaner
    pkgs.poppler
    pkgs.qrencode
    pkgs.yt-dlp
  ];
}
