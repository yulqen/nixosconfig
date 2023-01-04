{ config, pkgs, ...}: {
  
  home-manager.users.lemon = {
    programs.vim = {
      plugins = with pkgs.vimPlugins; [
        vim-sensible
        bufexplorer
      ];
      enable = true;
      settings = {
        ignorecase = true;
        number = true;
        relativenumber = true;
        tabstop = 4;
      };
      extraConfig = ''
        autocmd filetype mail set textwidth=0
        set nocompatible
      '';
    };    
  };
}
