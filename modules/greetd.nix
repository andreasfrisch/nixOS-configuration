{ config, pkgs, ... }:

{
#  services.greetd = {
#    enable = true;
#    settings = {
#      default_session = {
#        command = "${pkgs.greetd.regreet}/bin/regreet";
#        user = "greeter";
#      };
#    };
#  };
#
#  users.users.greeter = {
#    isSystemUser = true;
#    group = "greeter";
#    shell = pkgs.bash;
#  };
#
#  users.groups.greeter = {};
#
#  environment.systemPackages = with pkgs; [
#    greetd.regreet
#  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd sway
      '';
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
  '';

# services.greetd = {
#    enable = true;
#    settings.default_session = {
#      command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet --command sway --background ${wallpaper}";
#      user = "greeter";
#    };
#  };
#          #--remember \
#          #--user frisch \
#          #--time \
#          #--background ${wallpaper};
#
#  users.users.greeter = {
#    isSystemUser = true;
#    group = "greeter";
#    shell = pkgs.bash;
#  };
#
#  users.groups.greeter = {};
#
#  environment.systemPackages = with pkgs; [
#    greetd.gtkgreet
#    cage
#  ];
}
