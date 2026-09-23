{ pkgs, ... }:

{
  home.packages = with pkgs; [
    networkmanager_dmenu
    wl-clipboard
  ];
}
