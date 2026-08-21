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

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        image = config.stylix.image;
        clock = true;
        indicator-idle-visible = true;
        indicator-radius = 100;
        indicator-thickness = 7;
        timestr = "%H:%M";
        datestr = "%d %B";
      };
    };

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
      }

      spawn-at-startup "swaylock"
      spawn-sh-at-startup "pkill -x kanshi 2>/dev/null || true; exec kanshi"

      binds {
          Mod+D { spawn "fuzzel"; }
          Mod+L { spawn "swaylock"; }
          Mod+Shift+L { spawn "sh" "-lc" "~/.local/bin/power-menu.sh"; }
          Mod+Shift+T { spawn "sh" "-lc" "~/.local/bin/theme-switcher.sh"; }

          Print { spawn "shotman" "-c" "output" "-C"; }
          Shift+Print { spawn "shotman" "-c" "region" "-C"; }
          Ctrl+Shift+Print { spawn "shotman" "-c" "window" "-i"; }

          XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn "pamixer" "-i" "5"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "pamixer" "-d" "5"; }
          XF86AudioMute allow-when-locked=true { spawn "pamixer" "-t"; }

          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Ctrl+1 { move-column-to-workspace 1; }
          Mod+Ctrl+2 { move-column-to-workspace 2; }
          Mod+Ctrl+3 { move-column-to-workspace 3; }
          Mod+Ctrl+4 { move-column-to-workspace 4; }
          Mod+Ctrl+5 { move-column-to-workspace 5; }
          Mod+Ctrl+6 { move-column-to-workspace 6; }
          Mod+Ctrl+7 { move-column-to-workspace 7; }
          Mod+Ctrl+8 { move-column-to-workspace 8; }
          Mod+Ctrl+9 { move-column-to-workspace 9; }
      }
    '';
  };
}
