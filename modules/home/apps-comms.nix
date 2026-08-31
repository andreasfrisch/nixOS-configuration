{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium # keep as backup browser
    discord
    firefox
    slack
  ];
}
