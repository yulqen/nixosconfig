{ pkgs, home-manager, ... }:

{
  /*
  If you look at the repo I've copied to structure these files:
  https://git.sbruder.de/simon/nixos-config.git, you will see that
  his files do not duplicate the home-manager.users.lemon line here,
  he just references home.packages somehow. If I do that, I get an error   telling me that home isn't found. I don't know how he gets the home var  iable in there. Anyway - this works for now.

It is because of flakes... See 3.3 in the home-manager manual for example config. This puts home-manager in the user config.
  */
  home.packages = with pkgs; [
#      (jetbrains.pycharm-professional.overrideAttrs (oldAttrs: {
#        version = "2021.3.3";
#      }))
      aerc
      nil
      jetbrains-mono
      vistafonts
      gnome.seahorse
      gnome.gnome-keyring
      poetry
      python311
      marksman
      gcc
      gh
      sxiv
      ctags
      lynx
      jq
      urlscan
      newsboat
      bat
      ranger
      gnumake
      nodejs
      anki-bin
      black
      isort
      yapf
      pandoc
      font-manager
      texlive.combined.scheme-small
      taskwarrior
      imagemagick
      taskopen
      feh
      jdk
      openvpn
      logseq
      mumble
      neomutt
      tree
      chromium
      qutebrowser
      ripgrep
      abook
      # clojure
      # clojure-lsp
      leiningen
      # clj-kondo
      alacritty
      git-annex
      tmux
      hugo
      git
      fish
      zip
      unzip
      tor-browser-bundle-bin
      spotify
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
      file
      silver-searcher
      isync
      notmuch
      ncspot
      zathura
      zoom-us
      zotero
      xdotool
    ];
}
