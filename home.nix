{ config, pkgs, stylix, userSettings, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "frisch";
  home.homeDirectory = "/home/frisch";

  imports = [
    stylix.homeModules.stylix
    ./modules/home/stylix.nix
    ./modules/home/vim.nix
    ./modules/home/zsh.nix
    ./modules/home/alacritty.nix
    ./modules/home/sway.nix
    ./modules/home/git.nix
    ./modules/home/waybar.nix
    ./modules/home/packages.nix
    ./modules/home/setupenv.nix
    ./modules/home/flatpaks.nix
    ./modules/home/kanshi.nix
    ./modules/home/vscode.nix
  ];

  home.sessionVariables = {
    BROWSER = userSettings.browser;
    EDITOR = userSettings.editor;
    VISUAL = userSettings.editor;
    TERM = userSettings.terminal;
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello # just a test
    userSettings.fontPkg
    wl-clipboard
    networkmanager_dmenu
    papirus-icon-theme
    hicolor-icon-theme
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

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  programs.ranger = {
    enable = true;
    settings = {
      show_hidden = true;
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
