{ config, pkgs, stylix, userSettings, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "frisch";
  home.homeDirectory = "/home/frisch";


  imports = [
    stylix.homeModules.stylix
    ./modules/stylix.nix
    ./modules/vim.nix
    ./modules/zsh.nix
    ./modules/alacritty.nix
    ./modules/sway.nix
    ./modules/waybar.nix
    ./modules/packages.nix
  ];

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    VISUAL = userSettings.editor;
    TERM = userSettings.terminal;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello # just a test
    userSettings.fontPkg
    wl-clipboard
    networkmanager_dmenu
    papirus-icon-theme
    swaybg
    networkmanagerapplet
  ];

  fonts.fontconfig.enable = true;

  programs.wofi = {
    enable = true;
    settings = {
      term = "alacritty"; # Set your preferred terminal
      modi = "drun,run,window"; # App launcher, shell command, window switcher
      show-icons = true;
      icon-theme = "Papirus";  # Optional, install Papirus if needed
    };
  };

  programs.fuzzel.enable = true;

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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
