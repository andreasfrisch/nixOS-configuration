{ ... }:

{
  # Local LLM server, used by Zed and opencode via the OpenAI-compatible API.
  # Models are NOT managed by Nix — pull/update them manually:
  #   ollama pull deepseek-coder:6.7b
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
  };
}
