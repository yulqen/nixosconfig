{ config, pkgs, ...}: {
  
    programs.vim = {
      plugins = with pkgs.vimPlugins; [
        fzf-vim
        vim-sensible
        vim-polyglot
        vim-commentary
        vim-dispatch
        vim-fugitive
        vim-unimpaired
        vim-surround
        vim-signify
        vim-test
        vim-colors-solarized
        vim-snippets
        vim-javascript
        vim-go
        vim-plugin-AnsiEsc
        emmet-vim
        ultisnips
        nerdtree
        ale
        tabular
        gruvbox
        vim-ledger
        bufexplorer
      ];
      enable = true;
      settings = {
        ignorecase = true;
        number = true;
        relativenumber = true;
        tabstop = 4;
      };
      extraConfig = builtins.readFile ./vimrc;
    };    
}
