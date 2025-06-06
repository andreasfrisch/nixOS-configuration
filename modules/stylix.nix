{ pkgs, config, stylix, userSettings, ... }:

let
  themePath = ../themes/${userSettings.theme};
  colors = import (themePath + "/colors.nix");
  wallpaper = themePath + "/wallpaper.png";
in
{
  stylix = {
    enable = true;

    base16Scheme = colors;

    image = wallpaper;

    targets = {
      rofi.enable = true;
      alacritty.enable = true;
      waybar.enable = true;
      swaylock.enable = true;
      gtk.enable = true;
    };

    opacity = {
      terminal = 0.9;
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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # Set swaybg wallpaper (see later)
  home.packages = [ pkgs.swaybg ];
  systemd.user.services.set-wallpaper = {
    Unit = {
      Description = "Set wallpaper using swaybg";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -m fill";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
