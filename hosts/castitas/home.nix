{ ... }:

# This host's home-manager composition: shared base + the profiles
# this machine needs. Add/remove profiles here per-host, without
# touching the shared home.nix or any other host.
{
  imports = [
    ../../home.nix
    ../../modules/home/profiles/cli-base.nix
    ../../modules/home/profiles/desktop-sway.nix
  ];
}
