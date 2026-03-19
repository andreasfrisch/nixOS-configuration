{ pkgs, userSettings, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = userSettings.iconTheme;
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.wofi = {
    enable = true;
    settings = {
      term = userSettings.terminal;
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = userSettings.iconTheme;
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        icon-theme = userSettings.iconTheme;
        icons-enabled = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.ranger = {
    enable = true;
    settings = {
      show_hidden = true;
    };
  };
}
