{ config, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  home.sessionVariables = {
    BROWSER = userSettings.browser;
    EDITOR = userSettings.editor;
    VISUAL = userSettings.editor;
    TERM = userSettings.terminal;
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:${config.home.homeDirectory}/.local/share/flatpak/exports/share";

    # Local Ollama server, exposed as an OpenAI-compatible endpoint
    # for tools like opencode. Model must be pulled manually:
    #   ollama pull deepseek-coder:6.7b
    OLLAMA_HOST = "http://127.0.0.1:11434";
    OPENAI_BASE_URL = "http://127.0.0.1:11434/v1";
    OPENAI_API_KEY = "ollama";
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.05"; # Please read the comment before changing.
}
