{ lib, pkgs, userSettings, ... }:

let
  themePath = ../../themes/${userSettings.theme};
  colors = import (themePath + "/colors.nix");
  wallpaper = themePath + "/wallpaper.jpg";
in
{
  stylix = {
    enable = true;

    base16Scheme = colors;

    image = wallpaper;

    targets = {
      alacritty.enable = true;
      gtk.enable = true;
    };

    opacity = {
      terminal = 0.8;
    };

    fonts = {
      monospace = {
        package = userSettings.fontPkg;
        name = userSettings.font;
      };
      sansSerif = {
        package = userSettings.fontPkg;
        name = userSettings.font;
      };
      serif = {
        package = userSettings.fontPkg;
        name = userSettings.font;
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home.packages = [ ];
}
