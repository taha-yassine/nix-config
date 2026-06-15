{
  den.aspects.dev-tools.homeManager =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        uv
        gnumake
        code2prompt
        sqlitebrowser
        posting
        claude-code
        cabextract
      ];

      programs.direnv = {
        enable = true;
        # Better as it prevents gc of the environment.
        nix-direnv.enable = true;
      };

      programs.codex.enable = true;
      programs.pandoc.enable = true;
    };
}
