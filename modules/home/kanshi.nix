{ ... }:

{
  services.kanshi = {
    enable = true;
    settings = [
      # Docked: external monitor, disable laptop panel
      {
        profile = {
          name = "docked";
          outputs = [
            { criteria = "eDP-1"; status = "disable"; }
            {
              criteria = "Ancor Communications Inc ASUS VS247 D8LMTF050582";
              status = "enable";
              mode = "1920x1080@60Hz";
              position = "0,0";
            }
          ];
        };
      }

      # Undocked: only laptop panel
      {
        profile = {
          name = "undocked";
          outputs = [
            { criteria = "eDP-1"; status = "enable"; }
          ];
        };
      }
    ];
  };
}
