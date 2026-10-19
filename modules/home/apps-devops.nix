{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _1password-cli
    curl
    eas-cli
    gnumake
    htop
    jq
    k9s
    kubectl
    nil # Nix language server
    opencode
    podman
    ripgrep
    rpi-imager
    unzip
    uv
    wget
  ];
}
