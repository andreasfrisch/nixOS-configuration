{ config, lib, pkgs, ... }:

let
  wallpaper = ./../../../themes/gruvbox/wallpaper.jpg;
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.regreet}/bin/regreet
      '';
    };
  };

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = wallpaper;
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = lib.mkForce "Adwaita";
        icon_theme_name = lib.mkForce "Papirus";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';
}
