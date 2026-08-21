{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ./scripts/power-menu.nix
    ./scripts/theme-switcher.nix
  ];

  config = lib.mkIf (userSettings.wm == "niri") {
    home.packages = with pkgs; [
      shotman
      brightnessctl
      pamixer
      bluez
      fuzzel
      kanshi
    ];

    home.file.".config/niri/config.kdl".text = ''
      input {
          keyboard {
              xkb {
                  layout "dk"
              }
          }

          touchpad {
              tap
              natural-scroll
          }
      }

      layout {
          gaps 10
          focus-ring {
              width 2
          }
      }

      prefer-no-csd

      workspace "1"
      workspace "2"
      workspace "3"
      workspace "4"
      workspace "5"
      workspace "6"
      workspace "7"
      workspace "8"
      workspace "9"

      spawn-at-startup "noctalia"
      spawn-sh-at-startup "pkill -x kanshi 2>/dev/null || true; exec kanshi"
    '';
  };
}
