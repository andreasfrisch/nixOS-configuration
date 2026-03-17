{ config, pkgs, userSettings, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      bell = {
        animation = "Linear";
        duration = 0;
      };

      window = {
        padding = { x = 3; y = 3; };
        dynamic_title = true;
      };

      cursor = {
        style = "Beam";
      };
    };
  };
}

