{ config, pkgs, ...}: {
  
  home-manager.users.lemon = {
    programs.vim = {
      plugins = with pkgs.vimPlugins; [
        vim-sensible
      ];
      enable = true;
      settings = {
        ignorecase = true;
        number = true;
        relativenumber = true;
        tabstop = 4;
      };
      extraConfig = ''
        set nocompatible
      '';
    };    
  };
}
