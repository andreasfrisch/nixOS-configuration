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

    nix flake init -t "github:andreasfrisch/nix-environments#$1"
    direnv allow
  '';
in {
  home.file."bin/setupenv" = {
    text = setupenvScript;
    executable = true;
  };

  home.sessionPath = [ "$HOME/bin" ];
}
