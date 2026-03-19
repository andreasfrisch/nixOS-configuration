{ ... }:

let
  # Nerd Font icons
  iconLock = "";
  iconSleep = "";
  iconHibernate = "";  # Options below
  iconPoweroff = "⏻";
  iconReboot = "";
  iconLogout = "󰗽";

  # Actions
  actionLock = "${iconLock} Lock";
  actionSleep = "${iconSleep} Sleep";
  actionHibernate = "${iconHibernate} Hibernate";
  actionPowerOff = "${iconPoweroff} Poweroff";
  actionReboot = "${iconReboot} Reboot";
  actionLogout = "${iconLogout} Logout";

  # Fuzzel command base
  fuzzelCmd = "fuzzel --dmenu --prompt='Select: ' --lines=6 --width=20";

  # The actions to display in fuzzel
  actions = "${actionLock}\\n${actionLogout}\\n${actionSleep}\\n${actionHibernate}\\n${actionReboot}\\n${actionPowerOff}";

  # Script contents
  script = ''
    #!/usr/bin/env bash
    (
      sleep 0.1
      choice=$(${fuzzelCmd} <<< $'${actions}')
      case "$choice" in
        "${actionLock}") swaylock ;;
        "${actionLogout}") loginctl terminate-user $USER ;;
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
