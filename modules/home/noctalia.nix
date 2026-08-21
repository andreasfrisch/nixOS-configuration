{ lib, config, userSettings, ... }:

let
  themePath = ../../themes/${userSettings.theme};
  wallpaper = themePath + "/wallpaper.jpg";
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      general = {
        background_image = wallpaper;
      };
      colors = {
        background = config.stylix.base16Scheme.base00;
        foreground = config.stylix.base16Scheme.base07;
        primary = config.stylix.base16Scheme.base0D;
        accent = config.stylix.base16Scheme.base0B;
      };
    };
  };
}
