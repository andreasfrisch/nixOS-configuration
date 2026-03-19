{ pkgs, ... }:

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

    history = {
      size = 50000;
      save = 50000;
      extended = true;   # save timestamps — makes format more resilient
      share = true;      # share history across terminals
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" ];
      theme = "";
    };

    shellAliases = {
       ls = "eza --icons -a";
       ll = "eza --icons -a -l -T -L=1";
       tree = "eza --icons -T";
       open = "ranger";
    };

    initContent = ''
      setopt NO_BEEP
      source ${theme}
    '';
  };
}
