{ pkgs, userSettings, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Fonts
    userSettings.fontPkg

    # Desktop utilities
    hicolor-icon-theme
    networkmanager_dmenu
    papirus-icon-theme
    wl-clipboard

    # Applications
    cage
    chromium # keep as backup browser
    curl
    discord
    eas-cli
    feh
    firefox
    gimp3
    gnumake
    htop
    imagemagick
    jq
    kubectl
    mupdf
    neofetch
    openscad
    podman
    slack
    uv
    wget
  ];
}
