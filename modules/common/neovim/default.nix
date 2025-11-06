{
  config,
  pkgs,
  ...
}: {
  environment = {
    interactiveShellInit = ''
      export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.anthropic.path})"
      export GEMINI_API_KEY="$(cat ${config.age.secrets.gemini.path})"
      export LLM_GEMINI_KEY="$GEMINI_API_KEY"
      export OPENAI_API_KEY="$(cat ${config.age.secrets.openai.path})"
    '';
    systemPackages = with pkgs; [
      # datasette
      python3.pkgs.datasette
      # llm + plugins
      (python3.withPackages (ps:
        with ps; [
          llm
          llm-anthropic
          llm-docs
          llm-gemini
          llm-gguf
          llm-ollama
        ]))
    ];
    variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
  };
}
