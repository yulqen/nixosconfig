{ pkgs, ... }:

{
  /*
  If you look at the repo I've copied to structure these files:
  https://git.sbruder.de/simon/nixos-config.git, you will see that
  his files do not duplicate the home-manager.users.lemon line here,
  he just references home.packages somehow. If I do that, I get an error   telling me that home isn't found. I don't know how he gets the home var  iable in there. Anyway - this works for now.

It is because of flakes... See 3.3 in the home-manager manual for example config. This puts home-manager in the user config.
  */
  home-manager.users.lemon = { lib, pkgs, ... }: {
    
    home.packages = with pkgs; [
      aerc
      abook
      clojure
      clojure-lsp
      leiningen
      clj-kondo
      git-annex
      tmux
      hugo
      git
      fish
      pass
      tor-browser-bundle-bin
      spotify
      alacritty
      fzf
      gajim
      mpv
      ffmpeg
      yt-dlp
      clipmenu
      firefox
      gnome.seahorse
      xclip
      hledger
      ledger
      wget
      emacs-gtk
      file
      isync
    ];
  };
}
