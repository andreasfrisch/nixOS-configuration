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

      hotkey-overlay {
          skip-at-startup
      }

      binds {
          Mod+Shift+Slash { show-hotkey-overlay; }

          // Applications
          Mod+T { spawn "alacritty"; }
          Mod+D { spawn "fuzzel"; }
          Mod+L { spawn "noctalia" "lock"; }
          Mod+Shift+L { spawn "sh" "-lc" "~/.local/bin/power-menu.sh"; }
          Mod+Shift+T { spawn "sh" "-lc" "~/.local/bin/theme-switcher.sh"; }

          // Screenshots
          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }

          // Brightness
          XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          // Audio
          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

          // Window management
          Mod+Q repeat=false { close-window; }
          Mod+O repeat=false { toggle-overview; }
          Mod+F { maximize-column; }
          Mod+Shift+F { fullscreen-window; }
          Mod+C { center-column; }
          Mod+V { toggle-window-floating; }

          // Focus navigation
          Mod+Left  { focus-column-left; }
          Mod+Right { focus-column-right; }
          Mod+Up    { focus-window-up; }
          Mod+Down  { focus-window-down; }
          Mod+H     { focus-column-left; }
          Mod+L     { focus-column-right; }
          Mod+K     { focus-window-up; }
          Mod+J     { focus-window-down; }

          // Move windows
          Mod+Ctrl+Left  { move-column-left; }
          Mod+Ctrl+Right { move-column-right; }
          Mod+Ctrl+Up    { move-window-up; }
          Mod+Ctrl+Down  { move-window-down; }
          Mod+Ctrl+H     { move-column-left; }
          Mod+Ctrl+L     { move-column-right; }
          Mod+Ctrl+K     { move-window-up; }
          Mod+Ctrl+J     { move-window-down; }

          // Workspaces
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          // Session
          Mod+Shift+E { quit; }
          Mod+Shift+P { power-off-monitors; }
          Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      }
    '';
  };
}
