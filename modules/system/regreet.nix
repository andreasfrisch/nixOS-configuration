{ pkgs, userSettings, ... }:

{
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = userSettings.username;
      command = "${pkgs.niri}/bin/niri-session";
    };
  };
}
