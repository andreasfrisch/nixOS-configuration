{ ... }:

{
  # Persistent ssh-agent as a systemd user service — starts on login,
  # survives across terminals, and is reused by git over SSH.
  services.ssh-agent.enable = true;
}
