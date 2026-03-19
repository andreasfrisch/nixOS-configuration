{ config, stylix, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

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
    ./modules/home/battery-warning.nix
    ./modules/home/mako.nix
    ./modules/home/nm-applet.nix
    ./modules/home/desktop.nix
  ];

  home.sessionVariables = {
    BROWSER = userSettings.browser;
    EDITOR = userSettings.editor;
    VISUAL = userSettings.editor;
    TERM = userSettings.terminal;
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share";
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05"; # Please read the comment before changing.
}
