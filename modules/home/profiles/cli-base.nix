{ pkgs, ... }:

# Shell/CLI tooling that works on any host, with or without a graphical session.
{
  imports = [
    ../vim.nix
    ../zsh.nix
    ../git.nix
    ../ssh.nix
    ../setupenv.nix
    ../apps-devops.nix
    ../opencode.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
