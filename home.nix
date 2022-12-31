{ config, pkgs, ...}:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.lemon = { pkgs, ... }: {
    home.sessionVariables = {
      LEDGER_FILE = "/home/lemon/Documents/Budget/ledger/hledger/budget.ledger";
      FZF_DEFAULT_COMMAND = "ag --nocolor -g \"\"";
      # FZF_CTRL_T_COMMAND = "${FZF_DEFAULT_COMMAND}";
      # FZF_ALT_C_COMMAND = "${FZF_DEFAULT_COMMAND}";
      FZF_DEFAULT_OPTS = "--color info:108,prompt:109,spinner:108,pointer:168,marker:168";
    };
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      pkgs.git-annex
      pkgs.tmux
      pkgs.git
      pkgs.fish
      pkgs.pass
      pkgs.spotify
      pkgs.alacritty
      pkgs.fzf
      pkgs.gajim
      pkgs.mpv
      pkgs.ffmpeg
      pkgs.yt-dlp
      pkgs.clipmenu
      pkgs.firefox
      pkgs.gnome.seahorse
      pkgs.xclip
      pkgs.hledger
      pkgs.ledger
      pkgs.wget
      pkgs.emacs-gtk
      pkgs.file
    ];
    # showing an example of how to put a verbatim config file in.
    home.file = {
      ".config/alacritty/alacritty.yml".text = ''
        window:
          decorations: none
        font:
          normal:
            family: Iosevka
            style: Regular
          size: 10.0
      '';
    };
    programs.mpv = {
      enable = true;
      config = {
        save-position-on-quit = true;
      };
    };
    programs.fish = {
      shellInit = ''
       set fish_greeting "";
       set -gx LESS '-iMRS -x2'
      '';
      enable = true;
      shellAliases = {
        chubby = "echo 'chubby bobbins!'";
        bud = "cd ~/Documents/Budget/ledger/hledger/";
      };
    };

    programs.git = {
      enable = true;
      userName = "Matthew Lemon";
      userEmail = "y@yulqen.org";
      aliases = {
          co = "checkout";
          ci = "commit";
          br = "branch";
          st = "status -sb --ignore-submodules=all";
          ac = "!git add -A && git commit -m";
          lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
	        d = "difftool";
      };
      extraConfig = {
        color = {
             ui = true;
             branch = true;
             diff = true;
             interactive = true;
             status = true;
             log = false;
        };
        push = {
          default = "simple";
        };
        pull = {
          rebase = false;
        };
        init = {
          defaultBranch = "master"; # yes, snowflakes!
        };
        difftool = {
          prompt = false;
        };
        diff = {
          tool = "vimdiff";
        };
      };
    };
    home.stateVersion = "22.11";
  };
}
