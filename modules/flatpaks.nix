{ config, pkgs, lib, ... }:

let
  flatpak = "${pkgs.flatpak}/bin/flatpak";
  scope = "--user";

  # List of desired Flatpaks
  flatpakApps = [
    "com.bambulab.BambuStudio"
  ];

  # Function to generate installation commands
  installCommands = lib.concatStringsSep "\n" (map (app: ''
    if ! ${flatpak} list ${scope} --app | grep -q ${lib.escapeShellArg app}; then
      echo "Installing Flatpak: ${app}"
      ${flatpak} install ${scope} -y flathub ${lib.escapeShellArg app}
    else
      echo "Flatpak already installed: ${app}"
    fi
  '') flatpakApps);
in
{
  # Run this after Home Manager finishes writing configuration files
  home.activation.installFlatpaks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Ensure Flathub remote exists
    if ! ${flatpak} remotes ${scope} | grep -q '^flathub'; then
      echo "Adding Flathub remote"
      ${flatpak} remote-add ${scope} --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    ${installCommands}
  '';
}

