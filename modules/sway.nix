{ config, pkgs, userSettings, ... }:

{
  imports = [
    ./scripts/power-menu.nix
  ];

  home.packages = with pkgs; [
    shotman
    brightnessctl
    pamixer
    bluez
  ];

  programs.swaylock = {
    enable = true;
    settings.image = config.stylix.image;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      input = {
        "*" = {
          xkb_layout = "dk";
        };
      };
      bars = [];
      startup = [
         { command = "waybar"; }
      ];
      gaps = {
        inner = 10;
        outer = 5;
        smartGaps = true;
      };
    };
    extraConfig = ''
      bindsym Print               exec shotman -c output
      bindsym Print+Shift         exec shotman -c region
      bindsym Print+Shift+Control exec shotman -c window

      unbindsym Mod4+d
      bindsym Mod4+d exec fuzzel

      unbindsym Mod4+l
      bindsym Mod4+l exec swaylock
      unbindsym Mod4+Shift+l
      bindsym Mod4+Shift+l exec ~/.local/bin/power-menu.sh

      bindsym XF86MonBrightnessUp exec brightnessctl set +5%
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-

      bindsym XF86AudioRaiseVolume exec pamixer -i 5
      bindsym XF86AudioLowerVolume exec pamixer -d 5
      bindsym XF86AudioMute exec pamixer -t

      bindsym XF86Bluetooth exec bluetoothctl power toggle
    '';
  };

}
