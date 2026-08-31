{ ... }:

{
  # Registers the local Ollama server as an OpenAI-compatible provider so
  # pulled models show up in opencode's /models picker.
  #
  # Note: deepseek-coder:6.7b does NOT support Ollama tool-calling
  # (its capabilities are ["completion"] only), so opencode's agents
  # (which rely on tool calls to read/edit files and run commands) will
  # appear to do nothing when prompted with it. Use qwen2.5-coder:7b
  # (or another tool-calling capable model) for actual agent use.
  #
  # Pull models manually, e.g.:
  #   ollama pull qwen2.5-coder:7b
  #   ollama pull deepseek-coder:6.7b
  xdg.configFile."opencode/opencode.jsonc".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "provider": {
        "ollama": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "Ollama (local)",
          "options": {
            "baseURL": "http://127.0.0.1:11434/v1"
          },
          "models": {
            "qwen2.5-coder:7b": {
              "name": "Qwen2.5 Coder 7B (local, tool-calling)"
            },
            "deepseek-coder:6.7b": {
              "name": "DeepSeek Coder 6.7B (local, no tool-calling)"
            }
          }
        }
      }
    }
  '';
}
