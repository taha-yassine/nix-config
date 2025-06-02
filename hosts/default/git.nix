{
  pkgs,
  ...
}: {
  programs.git = {
    userEmail = "yassinetaha1997@gmail.com";
    userName = "Taha YASSINE";
    enable = true;
    extraConfig = {
      feature.manyFiles = true;

      # Enable mouse scrolling in delta
      # https://github.com/dandavison/delta/issues/630#issuecomment-860046929
      pager = let
        cmd = "LESS='LRc --mouse' ${pkgs.delta}/bin/delta";
      in {
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
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\" --diff-args=-U999";
      };
    };
  };

  programs.git.delta = {
    enable = true;
    options = {
      side-by-side = true;
      hyperlinks = true;
    };
  };
}
