{ pkgs, userSettings, ... }:

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
      swaylock.enable = true;
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

  home.packages = if userSettings.wm == "sway" then [ pkgs.swaybg ] else [ ];

  systemd.user.services.set-wallpaper = if userSettings.wm == "sway" then {
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
  } else {
    Unit = {
      Description = "Disabled under Niri/Noctalia";
    };
    Service = {
      ExecStart = "${pkgs.coreutils}/bin/true";
    };
  };
}
