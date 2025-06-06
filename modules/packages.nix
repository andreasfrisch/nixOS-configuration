{ config, pkgs, userSettings, ... }:

{
  home.packages = with pkgs; [
    gnumake
    git
    wget
    neofetch
    htop
    jq
    imagemagick
    feh
    curl
    kubectl
    ranger
    gimp3
    feh
  ];
}
