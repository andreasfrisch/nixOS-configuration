{ pkgs, ... }:

{
  home.packages = with pkgs; [ libnotify ];

  systemd.user.services.battery-warning = {
    Unit = {
      Description = "Battery low warning notifier";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "battery-warning" ''
        export PATH="${pkgs.coreutils}/bin:${pkgs.libnotify}/bin:$PATH"
        WARN_THRESHOLD=20
        CRIT_THRESHOLD=10
        WARNED_LOW=false
        WARNED_CRIT=false

        while true; do
          STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
          LEVEL=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "100")

          if [[ "$STATUS" != "Charging" && "$STATUS" != "Full" ]]; then
            if [[ "$LEVEL" -le "$CRIT_THRESHOLD" && "$WARNED_CRIT" == false ]]; then
              notify-send \
                --urgency=critical \
                --expire-time=0 \
                "⚠ Battery Critical" \
                "Battery at ''${LEVEL}%. Plug in now!"
              WARNED_CRIT=true
              WARNED_LOW=true
            elif [[ "$LEVEL" -le "$WARN_THRESHOLD" && "$WARNED_LOW" == false ]]; then
              notify-send \
                --urgency=normal \
                --expire-time=10000 \
                "🔋 Battery Low" \
                "Battery at ''${LEVEL}%. Consider plugging in."
              WARNED_LOW=true
            fi
          else
            # Reset warnings when charging
            WARNED_LOW=false
            WARNED_CRIT=false
          fi

          sleep 60
        done
      '';
      Restart = "on-failure";
      RestartSec = "10s";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
