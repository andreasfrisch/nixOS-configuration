{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # iOS device support
    ifuse
    libimobiledevice
    usbmuxd

    # Raspberry Pi imaging (broken in nixos-25.05, re-enable when fixed on 25.11)
    rpi-imager

    # Printing
    cups
    cups-filters
    ghostscript

    # Audio
    wireplumber
    pavucontrol

    # App launcher (system-level, used by greetd session too)
    wofi

    # Secrets management
    age
    sops
    _1password-cli
  ];
}
