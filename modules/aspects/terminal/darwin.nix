{
  den.aspects.terminal.homeManager =
    {
      host,
      lib,
      pkgs,
      ...
    }:
    lib.optionalAttrs (host.class == "darwin") {
      # Keep the OS login shell conventional for compatibility, but use Fish
      # for interactive sessions. macOS uses BSD ps.
      programs.zsh = {
        enable = true;
        initContent = import ./_fish-handoff.nix {
          inherit lib;
          fishBin = "${pkgs.fish}/bin/fish";
          parentCommand = "ps -o comm= -p \"$PPID\"";
          executionStringVar = "\${ZSH_EXECUTION_STRING}";
          fishArgs = "-l";
        };
      };
    };
}
