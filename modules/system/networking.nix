{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  services.openssh.enable = true;

  # Keep running when lid is closed (useful for external monitor setups)
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };
}
