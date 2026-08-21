{ lib, userSettings, ... }:

lib.mkIf false {
  services.mako = {
    enable = false;
  };
}
