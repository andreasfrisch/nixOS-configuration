{ pkgs, userSettings, ... }:

{
  # Default shell
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # dconf needed for GTK apps
  programs.dconf.enable = true;

  # NixOS owns /etc/shadow — passwords come exclusively from hashedPasswordFile
  users.mutableUsers = false;

  # User account
  users.users.root.hashedPassword = "!"; # locked — sudo only
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    hashedPasswordFile = "/run/secrets-for-users/user/hashedPassword";
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
