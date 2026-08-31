{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cage
    networkmanager_dmenu
    wl-clipboard
  ];
}
