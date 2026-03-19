{ lib, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Layout
      anchor = "top-center";
      width = 600;
      height = 110;
      margin = "10";
      padding = "15";
      border-size = 2;
      border-radius = 8;

      # Timing
      default-timeout = 5000;
      ignore-timeout = false;

      # Urgency overrides
      "urgency=low" = {
        default-timeout = 3000;
      };
      "urgency=critical" = {
        default-timeout = lib.mkForce 0;
        background-color = lib.mkForce "#810101ff";
        border-color = lib.mkForce "#ff0000";
        text-color = lib.mkForce "#ffffff";
      };
    };
  };
}
