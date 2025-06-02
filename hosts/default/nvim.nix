{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set clipboard+=unnamedplus

      " Tab configuration
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set smarttab
      set autoindent
      set smartindent
      
      " Move lines up or down
      nnoremap <a-j> :m .+1<cr>==
      nnoremap <a-k> :m .-2<cr>==
      inoremap <a-j> <esc>:m .+1<cr>==gi
      inoremap <a-k> <esc>:m .-2<cr>==gi
      vnoremap <a-j> :m '>+1<cr>gv=gv
      vnoremap <a-k> :m '<-2<cr>gv=gv
    '';
  };
}
