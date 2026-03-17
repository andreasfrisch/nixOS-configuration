# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, stylix, pkgs, systemSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/system/greetd.nix
      ./modules/system/wayland.nix
      ./modules/system/gaming.nix
    ];


  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = systemSettings.hostname;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  services.udev.packages = [ pkgs.qmk-udev-rules ];

  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.defaultLocale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.secondaryLocale;
    LC_IDENTIFICATION = systemSettings.secondaryLocale;
    LC_MEASUREMENT = systemSettings.secondaryLocale;
    LC_MONETARY = systemSettings.secondaryLocale;
    LC_NAME = systemSettings.secondaryLocale;
    LC_NUMERIC = systemSettings.secondaryLocale;
    LC_PAPER = systemSettings.secondaryLocale;
    LC_TELEPHONE = systemSettings.secondaryLocale;
    LC_TIME = systemSettings.secondaryLocale;
  };

  programs.dconf.enable = true;

  # wayland style
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  security.pam.services.swaylock = {};

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # battery management software
  services.tlp = {
    enable = true;

    settings = {
      # --- BATTERY CARE ---

      # Charge thresholds (only available on ThinkPads)
      # Keep battery between 40-80% to preserve battery lifespan
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;

      # Runtime Power Management
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # USB autosuspend
      USB_AUTOSUSPEND = 1;

      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Sound power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      # PCIe ASPM (Active State Power Management)
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";

      # CPU energy policy
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Enable battery recalibration support (optional, see below)
      NATACPI_ENABLE = 1;
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;

    # Ensure Bluetooth is powered off at boot
    settings = {
      General = {
        AutoEnable = false;
      };
    };
  };


  virtualisation.containers.enable = true;

  virtualisation.containers.policy = {
    default = [
      {
        type = "insecureAcceptAnything";
      }
    ];
  };

  environment.etc."bluetooth/main.conf".text = lib.mkForce ''
    [General]
    AutoEnable=false
    ControllerMode=dual

    [Policy]
    AutoEnable=false
  '';

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # define groups
  users.groups.bluetooth = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frisch = {
    isNormalUser = true;
    description = "Andreas Frisch";
    extraGroups = [
      "networkmanager"
      "wheel"
      "bluetooth"
      "disk"
      "storage"
      "lp"
      "lpadmin"
    ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "vscode-extension-github-copilot"
    "vscode-extension-github-copilot-chat"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ifuse
    libimobiledevice
    usbmuxd
    rpi-imager
    cups
    cups-filters
    ghostscript
    wireplumber
    pavucontrol
    wofi
  ];

  environment.shells = with pkgs; [zsh];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # Flatpak enabling
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "wlr";
  };
  services.flatpak = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
