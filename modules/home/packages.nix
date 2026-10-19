{ pkgs, ... }:

{
  home.packages = with pkgs; [
    networkmanager_dmenu
  ];
}
