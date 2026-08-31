{ lib, ... }:

{
  # Enable Nix-LD for specific libraries related to Github Copilot
  programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = lib.mkForce (with pkgs; [
  #  glibc
  #  gcc.cc.lib
  #]);

  # Automatic updating — disabled: it was configured for a flake-based
  # system but never pointed at the flake (`system.autoUpgrade.flake` was
  # unset), so it silently failed every week trying to fall back to
  # legacy channel-based rebuilds. Upgrade manually via `make system`/`make home`.
  system.autoUpgrade.enable = false;

  # Automatic cleanup
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  systemd.services.dbus.reloadIfChanged = lib.mkOverride 90 false;
  systemd.services.dbus.restartIfChanged = true;

  systemd.user.services.dbus.reloadIfChanged = lib.mkOverride 90 false;
  systemd.user.services.dbus.restartIfChanged = true;
}
