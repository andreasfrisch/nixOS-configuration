{ userSettings, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    userSettings.fontPkg

    # Fonts for 3D-print-friendly engraved/embossed text (bold, no thin serifs)
    montserrat
    open-sans
    oswald
    roboto

    # Icon themes
    hicolor-icon-theme
    papirus-icon-theme
  ];
}
