{ inputs, ... }:
{
  den.aspects.ai-tools.homeManager =
    { lib, pkgs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.system};
    in
    {
      programs.claude-code = {
        enable = true;
        package = llm-agents.claude-code;
      };

      programs.codex = {
        enable = true;
        package = llm-agents.codex;
      };

      xdg.configFile."aichat/config.yaml".text = lib.generators.toYAML { } {
        prelude = "session:default";
        model = "openrouter:anthropic/claude-3-5-haiku";
        clients = [
          {
            type = "openai-compatible";
            name = "openrouter";
            api_base = "https://openrouter.ai/api/v1";
          }
        ];
      };
    };
}
