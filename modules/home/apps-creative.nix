{ pkgs, ... }:

{
  home.packages = with pkgs; [
    feh
    freecad
    gimp3
    imagemagick
    inkscape
    mupdf
    openscad
    vassal
  ];
}
