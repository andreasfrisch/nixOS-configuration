{ pkgs, ... }:
let
  waybarConfig = {
    layer = "top";
    position = "bottom";
    modules-left = [ "sway/workspaces" "sway/mode" ];
    modules-center = [ "clock" ];
    modules-right = [
      #"network"
      "bluetooth"
      "backlight"
      "pulseaudio"
      "battery"
      "memory"
      "cpu"
      "disk"
      "tray"
    ];

    clock = {
      format = " {:%Y-%m-%d  %H:%M}";
      tooltip = false;
    };

    network = {
      interface = "wlp0s20f3";
      format-wifi = "  {essid} ({signalStrength}%)";
      format-ethernet = "直 {ipaddr}/{cidr}";
      format-disconnected = "⚠️ Disconnected";
      format-no-inet = "⚠️ No Internet";
      on-click = "networkmanager_dmenu --dmenu wofi";
      tooltip = false;
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = " Muted";
      format-icons = {
        default = [ "" "" "" ];
      };
      on-click = "pavucontrol";
      on-click-right = "wpctl status | wofi --dmenu | awk '{print $1}' | xargs -r wpctl set-default";
      scroll-step = 5;
    };

    backlight = {
      device = "intel_backlight";
      format = "{icon} {percent}%";
      format-icons = {
        default = [ "" ];
      };
      #on-scroll-up = "brightnessctl set +5%";
      #on-scroll-down = "brightnessctl set 5%-";
    };

    battery = {
      format = "{icon} {capacity}% ({time})";
      format-charging = "󰂄 {capacity}% ({time})";
      format-full = "{icon} {capacity}%";
      format-time = "{H}h{M}m";
      format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    };

    memory = {
      format = " {used:0.1f}G";
    };

    cpu = {
      format = " {usage}%";
    };

    disk = {
      path = "/";
      format = " {free}";
    };

    bluetooth = {
      format = " {status}";
      format-disabled = " off";
      format-connected = " {num_connections} connected";
      on-click = "blueman-manager"; # Needs blueman installed
    };

    tray = {};
  };

  waybarStyle = ''
    #clock, #network, #pulseaudio, #backlight, #battery, #memory, #cpu, #disk #tray {
      padding: 0 10px;
    }

    #tray {
      margin-left: 5px;
      margin-right: 5px;
    }
  '';
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [ waybarConfig ];
    style = waybarStyle;
  };
}

