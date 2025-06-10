{config, ...}: {
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };
  environment.interactiveShellInit = ''
    export ANTHROPIC_API_KEY="$(cat ${config.age.secrets.anthropic.path})"
    export OPENAI_API_KEY="$(cat ${config.age.secrets.openai.path})"
  '';
}
