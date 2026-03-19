{ lib, pkgs, userSettings, ... }:

{
  # Allow unfree packages (system-level)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "vscode-extension-github-copilot"
    "vscode-extension-github-copilot-chat"
    "vscode-extension-ms-python-vscode-pylance"
  ];

  # Default shell
  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # dconf needed for GTK apps
  programs.dconf.enable = true;

  # User account
  users.groups.bluetooth = {};
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    hashedPasswordFile = "/run/secrets/user/hashedPassword";
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
