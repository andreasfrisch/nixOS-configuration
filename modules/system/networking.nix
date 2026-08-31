{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Expo/React Native (Metro bundler) dev server, for testing on a physical
  # device over LAN: 8081 is the current default, 19000-19002 cover the
  # legacy Expo CLI protocol/dev tools.
  networking.firewall.allowedTCPPorts = [ 8081 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 19000; to = 19002; } ];

  services.openssh.enable = true;

  # Keep running when lid is closed (useful for external monitor setups)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
