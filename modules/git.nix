{ config, pkgs, ... }:

{
  home.packages = [ pkgs.git ];

  programs.git = {
    enable = true;

    userName = "Andreas Frisch";
    userEmail = "andreas.frisch@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
    };

    aliases = {
      co = "checkout";
      st = "status";
      cm = "commit -m";
      lg = "log --oneline --graph -- decorate";
    };
  };
}
