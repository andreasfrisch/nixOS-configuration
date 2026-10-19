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

  # Suspend immediately, then hibernate after an hour if still asleep. This
  # applies both to lid-close and to the "Hibernate" power-menu action, so
  # triggering one manually and then closing the lid doesn't restart the
  # timer — the system is already suspended, so the lid event is a no-op.
  systemd.sleep.settings.Sleep.HibernateDelaySec = "1h";

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    # Docked/on external power: keep running when lid is closed (useful for
    # external monitor setups).
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
