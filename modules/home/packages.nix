{ pkgs, userSettings, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    userSettings.fontPkg

    # Fonts for 3D-print-friendly engraved/embossed text (bold, no thin serifs)
    montserrat
    open-sans
    oswald
    roboto

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
    freecad
    gimp3
    gnumake
    htop
    imagemagick
    inkscape
    jq
    k9s
    kubectl
    mupdf
    opencode
    openscad
    podman
    ripgrep
    slack
    uv
    unzip
    vassal
    wget
  ];
}
