{ pkgs, config, ... }:

let
  # Nerd Font icons
  iconLock = "";
  iconSleep = "";
  iconHibernate = "";  # Options below
  iconPoweroff = "⏻";
  iconReboot = "";

  # Actions
  actionLock = "${iconLock} Lock";
  actionSleep = "${iconSleep} Sleep";
  actionHibernate = "${iconHibernate} Hibernate";
  actionPowerOff = "${iconPoweroff} Poweroff";
  actionReboot = "${iconReboot} Reboot";

  # Fuzzel command base
  fuzzelCmd = "fuzzel --dmenu --prompt='Select: ' --lines=5 --width=20";

  # The actions to display in fuzzel
  actions = "${actionLock}\\n${actionSleep}\\n${actionHibernate}\\n${actionReboot}\\n${actionPowerOff}";

  # Script contents
  script = ''
    #!/usr/bin/env bash
    (
      sleep 0.1
      choice=$(${fuzzelCmd} <<< $'${actions}')
      case "$choice" in
        "${actionLock}") swaylock ;;
        "${actionSleep}") systemctl suspend ;;
        "${actionHibernate}") systemctl hibernate ;;
        "${actionReboot}") systemctl reboot ;;
        "${actionPowerOff}") systemctl poweroff ;;
      esac
    ) & disown
  '';
in
{
  home.file.".local/bin/power-menu.sh" = {
    executable = true;
    text = script;
  };
}
