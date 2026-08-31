{ lib, pkgs, ... }:

{
  # Wayland / sway requirements
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  security.pam.services.swaylock = {};

  # Console keymap
  console.keyMap = "dk-latin1";

  # Keyboard peripheral firmware flashing
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  # Battery / power info daemon
  services.upower.enable = true;

  # Bluetooth — disabled at boot, enable manually when needed
  hardware.bluetooth = {
    enable = true;
    settings.General.AutoEnable = false;
  };

  environment.etc."bluetooth/main.conf".text = lib.mkForce ''
    [General]
    AutoEnable=false
    ControllerMode=dual

    [Policy]
    AutoEnable=false
  '';

  services.blueman.enable = true;
  users.groups.bluetooth = {};
}
