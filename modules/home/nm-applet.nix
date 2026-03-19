{ pkgs, ... }:

{
  home.packages = [ pkgs.networkmanagerapplet ];

  systemd.user.services.nm-applet = {
    Unit = {
      Description = "NetworkManager Applet";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      Restart = "on-failure";
      Environment = "XDG_CURRENT_DESKTOP=sway";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
