{ lib, userSettings, ... }:

{
  config = lib.mkIf (userSettings.wm == "niri") {
    programs.niri.enable = true;
  };
}
