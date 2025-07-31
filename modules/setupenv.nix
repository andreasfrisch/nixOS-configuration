{
  config,
  pkgs,
  ...
}:

let
  setupenvScript = ''
    #!/usr/bin/env bash
    set -euo pipefail

    ENV_NAME="$1"

    echo "use flake \"github:andreasfrisch/nix-environments#$ENV_NAME\"" >> .envrc

    echo ".envrc written for $ENV_NAME"
    direnv allow
  '';
in {
  home.file."bin/setupenv" = {
    text = setupenvScript;
    executable = true;
  };

  home.sessionPath = [ "$HOME/bin" ];
}
