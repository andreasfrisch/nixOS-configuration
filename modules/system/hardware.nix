{ lib, pkgs, ... }:

{
  # Hibernate via swapfile
  swapDevices = [{ device = "/swapfile"; }];
  boot.resumeDevice = "/dev/disk/by-uuid/c00ed73b-21ed-4ba7-ba9e-90a0885b1ff9";
  boot.kernelParams = [ "resume_offset=28878848" ];

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

  # Battery management (ThinkPad optimised)
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;

      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      USB_AUTOSUSPEND = 1;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      NATACPI_ENABLE = 1;
    };
  };

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
