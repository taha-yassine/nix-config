{
  den.aspects.dev-tools.homeManager =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        uv
        gnumake
        nixfmt
        code2prompt
        sqlitebrowser
        nixd
        devcontainer
        posting
        jq
        comma
        claude-code
        cabextract
      ];

      programs.direnv = {
        enable = true;
        # Better as it prevents gc of the environment.
        nix-direnv.enable = true;
      };

      programs.codex.enable = true;

      programs.zed-editor = {
        enable = true;
        userSettings = {
          telemetry.metrics = false;
          vim_mode = true;
          theme = "Ayu Dark";
        };
      };

      programs.pandoc.enable = true;

      # TODO: move GitHub token to secrets.
      programs.nix-init = {
        enable = true;
      };
    };
}
