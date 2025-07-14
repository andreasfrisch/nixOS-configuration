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
    gimp3
    feh
    podman
    firefox
    eas-cli
  ];
}
