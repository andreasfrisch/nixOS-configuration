{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = false;
      xkb = {
         layout = "dk";
         variant = "";
      };
      displayManager = {
         startx.enable = true;
         gdm.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    xwayland # some apps still need this
    wl-clipboard
    qt6.qtwayland
    glib # for GDK
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # fix invisible cursor on some GPUs
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
  };
}

