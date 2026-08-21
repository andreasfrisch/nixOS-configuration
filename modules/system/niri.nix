{ lib, userSettings, ... }:

{
  config = lib.mkIf (userSettings.wm == "niri") {
    programs.niri = {
      enable = true;
      settings = {
        prefer-no-csd = true;
        workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
        layout = {
          gaps = 10;
          focus-ring = {
            width = 2;
          };
        };
      };
    };
  };
}
