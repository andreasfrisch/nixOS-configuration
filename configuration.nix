# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ systemSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/nix.nix
    ./modules/system/hardware.nix
    ./modules/system/audio.nix
    ./modules/system/printing.nix
    ./modules/system/user.nix
    ./modules/system/networking.nix
    ./modules/system/containers.nix
    ./modules/system/flatpak.nix
    ./modules/system/packages.nix
    ./modules/system/regreet.nix
    ./modules/system/wayland.nix
    ./modules/system/gaming.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Identity
  networking.hostName = systemSettings.hostname;
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.defaultLocale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS      = systemSettings.secondaryLocale;
    LC_IDENTIFICATION = systemSettings.secondaryLocale;
    LC_MEASUREMENT  = systemSettings.secondaryLocale;
    LC_MONETARY     = systemSettings.secondaryLocale;
    LC_NAME         = systemSettings.secondaryLocale;
    LC_NUMERIC      = systemSettings.secondaryLocale;
    LC_PAPER        = systemSettings.secondaryLocale;
    LC_TELEPHONE    = systemSettings.secondaryLocale;
    LC_TIME         = systemSettings.secondaryLocale;
  };

  system.stateVersion = "25.05"; # Did you read the comment?
}
