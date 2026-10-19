{ pkgs, ... }:

# Wayland clipboard: wl-clipboard (cli-base.nix) only gives you wl-copy/wl-paste.
# Two gaps remain on top of that:
#   - Pasted content can go stale once the source app loses focus/exits, since
#     Wayland normally requires the source client to stay alive to serve a
#     paste request. wl-clip-persist takes ownership of the clipboard so it
#     keeps working regardless of what copied it.
#   - There's no history. cliphist records every copy (text + images) to a
#     small on-disk log, picked via fuzzel (bound to Mod4+v in sway.nix).
{
  home.packages = with pkgs; [ wl-clip-persist cliphist ];

  systemd.user.services.wl-clip-persist = {
    Unit = {
      Description = "Keep Wayland clipboard content after the source app closes";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard both";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.cliphist-text = {
    Unit = {
      Description = "Clipboard history (text)";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.cliphist-image = {
    Unit = {
      Description = "Clipboard history (images)";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
