{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rpi-imager

    # 1Password CLI
    _1password-cli
  ];
}
