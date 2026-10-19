{ stylix, ... }:

# Everything that assumes a sway/Wayland graphical session.
{
  disabledModules = [ (stylix + "/modules/hyprland/hm.nix") ];

  imports = [
    stylix.homeModules.stylix
    ../stylix.nix
    ../sway.nix
    ../waybar.nix
    ../mako.nix
    ../kanshi.nix
    ../nm-applet.nix
    ../battery-warning.nix
    ../clipboard.nix
    ../desktop.nix
    ../alacritty.nix
    ../fonts.nix
    ../apps-creative.nix
    ../apps-comms.nix
    ../flatpaks.nix
    ../zed.nix
    ../vscode.nix
    ../packages.nix
  ];
}
