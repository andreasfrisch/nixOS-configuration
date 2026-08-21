{ lib, userSettings, ... }:

{
  config = lib.mkIf (userSettings.wm == "niri") {
    programs.noctalia = {
      enable = true;
      systemd.enable = false;
      settings = { };
    };
  };
}
