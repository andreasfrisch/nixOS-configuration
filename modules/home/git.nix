{ userSettings, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = userSettings.name;
      user.email = userSettings.email;
      init.defaultBranch = "main";
      core.editor = userSettings.editor;
      alias = {
        co = "checkout";
        st = "status";
        cm = "commit -m";
        lg = "log --oneline --graph --decorate";
      };
    };
  };
}
