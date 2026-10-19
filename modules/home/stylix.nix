{ pkgs, userSettings, ... }:

let
  themePath = ../../themes/${userSettings.theme};
  colors = import (themePath + "/colors.nix");
  wallpaper = themePath + "/wallpaper.jpg";
in
{
  stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = colors;

    image = wallpaper;

    targets = {
      alacritty.enable = true;
      waybar.enable = true;
      swaylock.enable = true;
      gtk.enable = true;
      zed.enable = true;
      sway.enable = true; # useWallpaper defaults to true — sets output "*" bg natively
      mako.enable = true;
      fuzzel.enable = true;
      wofi.enable = true;
      # Stylix auto-enables vscode theming as soon as programs.vscode.enable
      # is set (it's on by default for every target, not just the ones
      # listed here). That manages settings.json as a read-only Nix-store
      # symlink, which blocks VS Code from saving its own settings — turned
      # off since VS Code is managed manually (see modules/home/vscode.nix).
      vscode.enable = false;
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
}
