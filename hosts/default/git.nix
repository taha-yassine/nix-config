{
  programs.git = {
    userEmail = "yassinetaha1997@gmail.com";
    userName = "Taha YASSINE";
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
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
