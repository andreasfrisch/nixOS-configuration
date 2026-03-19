{ pkgs, userSettings, ... }:

let
  dotfilesDir = "$HOME/.dotfiles";
  previousTheme = userSettings.theme;
  hmBin = "${pkgs.home-manager}/bin/home-manager";

  script = ''
    #!/usr/bin/env bash
    set -euo pipefail

    DOTFILES="${dotfilesDir}"
    FLAKE="$DOTFILES/flake.nix"

    # Available themes (must match dirs in themes/)
    themes="🌲  gruvbox\n☀️  solarized\n🌸  pinkish"

    # Show fuzzel picker — strip the icon+spaces prefix after selection
    chosen=$(printf "$themes" | ${pkgs.fuzzel}/bin/fuzzel --dmenu \
      --prompt="Theme:" \
      --lines=3 \
      --width=20 | ${pkgs.gnused}/bin/sed 's/^.*  //')

    [[ -z "$chosen" ]] && exit 0

    # Patch the theme in flake.nix
    ${pkgs.gnused}/bin/sed -i "s|theme = \".*\";|theme = \"$chosen\";|" "$FLAKE"

    # Stage flake.nix so the flake evaluator picks up the change
    ${pkgs.git}/bin/git -C "$DOTFILES" add "$FLAKE"

    # Send a persistent progress notification and capture its ID
    NOTIFY_ID=$(${pkgs.libnotify}/bin/notify-send \
      --print-id \
      --expire-time=0 \
      "🎨 Theme Switcher" "Building $chosen...")

    # Spinner loop — replaces the notification every 4s while building
    spin() {
      local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
      local i=0
      while kill -0 "$1" 2>/dev/null; do
        ${pkgs.libnotify}/bin/notify-send \
          --replace-id="$NOTIFY_ID" \
          --expire-time=0 \
          "🎨 Theme Switcher" "''${frames[$i]} Building $chosen..."
        i=$(( (i + 1) % ''${#frames[@]} ))
        sleep 2
      done
    }

    # Run rebuild in background, spin while waiting
    LOG=$(mktemp)
    ${hmBin} switch --flake "$DOTFILES" >"$LOG" 2>&1 &
    BUILD_PID=$!
    spin $BUILD_PID &
    SPIN_PID=$!
    wait $BUILD_PID
    BUILD_EXIT=$?
    wait $SPIN_PID 2>/dev/null || true

    if [[ $BUILD_EXIT -eq 0 ]]; then
      ${pkgs.libnotify}/bin/notify-send \
        --replace-id="$NOTIFY_ID" \
        --expire-time=5000 \
        "🎨 Theme Switcher" "✓ Switched to $chosen"
    else
      ${pkgs.libnotify}/bin/notify-send \
        --replace-id="$NOTIFY_ID" \
        --urgency=critical \
        --expire-time=0 \
        "🎨 Theme Switcher" "✗ Build failed\n$(tail -3 $LOG)"
      # Revert flake.nix and re-stage
      ${pkgs.gnused}/bin/sed -i "s|theme = \".*\";|theme = \"${previousTheme}\";|" "$FLAKE"
      ${pkgs.git}/bin/git -C "$DOTFILES" add "$FLAKE"
    fi
    rm -f "$LOG"
  '';
in
{
  home.packages = with pkgs; [ libnotify ];

  home.file.".local/bin/theme-switcher.sh" = {
    executable = true;
    text = script;
  };
}
