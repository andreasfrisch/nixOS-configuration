{
  config,
  pkgs,
  userSettings,
  ...
}:

let
  repository = userSettings.templateRepository;

  setupenvScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    REPO="${repository}"
    ENV_NAME="$1"

    nix flake init -t "github:$REPO#$ENV_NAME"
    direnv allow
  '';

  showenvScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    REPO="${repository}"
    nix flake show "github:$REPO"
  '';
in {
  home.file."bin/setupenv" = {
    text = setupenvScript;
    executable = true;
  };

  home.file."bin/showenv" = {
    text = showenvScript;
    executable = true;
  };

  home.sessionPath = [ "$HOME/bin" ];
}
