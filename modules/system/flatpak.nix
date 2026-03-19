{ pkgs, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "wlr";
  };

  services.flatpak.enable = true;
}
