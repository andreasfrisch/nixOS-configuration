{ config, pkgs, ... }:

let
  theme = ./zsh-themes/frisch.zsh-theme;
in {
  home.packages = with pkgs; [
    eza
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" ]; # include others if you want
      theme = ""; # We're overriding the theme manually below
    };

    shellAliases = {
       ls = "eza --icons";
       ll = "eza --icons -l -T -L=1";
       tree = "eza --icons -T";
       open = "ranger";
    };

    initContent = ''
      setopt NO_BEEP
      source ${theme}
    '';
  };
}
