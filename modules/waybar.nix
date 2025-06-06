{ config, pkgs, ... }:
let
  waybarConfig = {
    layer = "top";
    position = "bottom";
    modules-left = [ "sway/workspaces" "sway/mode" ];
    modules-center = [ "clock" ];
    modules-right = [
      #"network"
      "bluetooth"
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
    };

    battery = {
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-icons = [ "" "" "" "" "" ];
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
    #clock, #network, #pulseaudio, #battery, #memory, #cpu, #disk #tray {
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
    settings = [ waybarConfig ];  # <- this applies your config
    style = waybarStyle;          # <- this applies your CSS
  };

  home.packages = with pkgs; [
    networkmanager_dmenu
    networkmanager
    pulseaudio
    acpi
  ];
}

