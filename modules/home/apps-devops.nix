{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    unzip
    uv
    wget
  ];
}
