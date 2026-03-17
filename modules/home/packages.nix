{ config, pkgs, userSettings, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    chromium
    gnumake
    wget
    neofetch
    htop
    jq
    imagemagick
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
    uv
    mupdf
  ];
}
