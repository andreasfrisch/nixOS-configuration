{ config, pkgs, userSettings, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    gnumake
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
    slack
    discord
    cage
    openscad
  ];
}
