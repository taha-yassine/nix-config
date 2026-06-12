{
  den.aspects.git.homeManager =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user.email = "yassinetaha1997@gmail.com";
          user.name = "Taha YASSINE";
          feature.manyFiles = true;

          # Enable mouse scrolling in delta.
          # https://github.com/dandavison/delta/issues/630#issuecomment-860046929
          pager =
            let
              cmd = "LESS='LRc --mouse' ${pkgs.delta}/bin/delta";
            in
            {
              diff = cmd;
              show = cmd;
              stash = cmd;
              log = cmd;
              reflog = cmd;
            };
        };
      };

      programs.lazygit = {
        enable = true;
        settings.git.pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\" --diff-args=-U999";
          }
        ];
      };

      programs.gh-dash = {
        enable = true;
        settings.pager.diff = "diffnav";
      };

      home.packages = [ pkgs.diffnav ];

      programs.delta = {
        enable = true;
        # Git integration is wired manually via programs.git.settings.pager
        # above (with a LESS wrapper for mouse scrolling).
        enableGitIntegration = false;
        options = {
          side-by-side = true;
          hyperlinks = true;
        };
      };

      programs.gh.enable = true;
    };
}
