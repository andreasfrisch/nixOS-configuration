{ pkgs, ... }:

let
  exts = pkgs.vscode-extensions;

  # Seeded once; VSCode owns the file after that (mutableExtensionsDir = true)
  initialSettings = {
    # --- General ---
    "editor.formatOnSave" = true;
    "editor.tabSize" = 2;
    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;

    # --- Copilot ---
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = true;
    };
    "github.copilot.nextEditSuggestions.enabled" = true;

    # --- Python ---
    "python.defaultInterpreterPath" = "python";
    "python.formatting.provider" = "black";
    "editor.codeActionsOnSave" = {
      "source.fixAll.ruff" = true;
    };

    # --- ESLint / Prettier ---
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "eslint.validate" = [
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
    ];

    # --- Typescript ---
    "typescript.tsdk" = "node_modules/typescript/lib";

    # --- Nix ---
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";

    # --- Direnv ---
    "direnv.restart.automatic" = true;
  };
in
{
  # Language server for nix-ide
  home.packages = with pkgs; [ nil ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;

    # Required for Copilot
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with exts; [
        # --- Core ---
        github.copilot
        github.copilot-chat

        # --- Python ---
        ms-python.python
        ms-python.vscode-pylance

        # --- JS / React ---
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        
        # --- Docker ---
        ms-azuretools.vscode-docker

        # --- Data ---
        mechatroner.rainbow-csv

        # --- Nix ---
        jnoortheen.nix-ide

        # --- Direnv integration ---
        mkhl.direnv
      ];

      userSettings = initialSettings;
    };
  };
}
