{ pkgs, userSettings, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = userSettings.username;
      command = if userSettings.wm == "niri" then "${pkgs.niri}/bin/niri-session" else "${pkgs.sway}/bin/sway";
    };
  };
}
