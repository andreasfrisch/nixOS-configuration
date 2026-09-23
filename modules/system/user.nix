{ pkgs, userSettings, ... }:

{
  # Default shell
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # dconf needed for GTK apps
  programs.dconf.enable = true;

  # Passwords are managed the normal NixOS way (set/changed via `passwd`,
  # persisted in /etc/shadow) rather than declared here — this repo is public,
  # so no password hash (even encrypted at rest) is stored in it.
  users.mutableUsers = true;

  # User account
  users.users.root.hashedPassword = "!"; # locked — sudo only
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "bluetooth"
      "disk"
      "storage"
      "lp"
      "lpadmin"
    ];
  };
}
