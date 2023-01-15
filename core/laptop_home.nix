{ config, options, pkgs, ... }:

{

  imports = [ ../modules ];

  home.sessionVariables = {
    BROWSER = "firefox";
    LEDGER_FILE = "/home/lemon/Documents/Budget/ledger/hledger/budget.ledger";
    FZF_DEFAULT_COMMAND = "ag --nocolor -g \"\"";
    # FZF_CTRL_T_COMMAND = "${FZF_DEFAULT_COMMAND}";
    # FZF_ALT_C_COMMAND = "${FZF_DEFAULT_COMMAND}";
    FZF_DEFAULT_OPTS = "--color info:108,prompt:109,spinner:108,pointer:168,marker:168";
  };

  
  

  #gnupg agent
  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 28800;
  };

  # notifications
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      normal = {
        timeout = 0;        
      };
      global = {
        width = 600;
        height = 300;
        transparency = 10;
        font = "Iosevka 16";
      };
    };
  };
  
  home.stateVersion = "22.11";

  # showing an example of how to put a verbatim config file in.
  home.file = {
    ".config/alacritty/alacritty.yml".text = ''
        window:
          decorations: none
        font:
          normal:
            family: Iosevka
            style: Regular
          size: 12.0
      '';
  };

  # tmux
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      bind | split-window -h
      bind - split-window -v
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      set -g mouse on
      set-window-option -g xterm-keys on
      bind -n C-Left previous-window
      bind -n C-Right next-window
      bind -n C-Up new-window
      bind -n C-Down confirm-before -p "kill-window #P? (y/n)" kill-window
      setw -g monitor-activity off
      set -g visual-activity off
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-style dim
      set -g status-left ""
      set -g status-right "#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S "
      set -g status-right-length 50
      set -g status-left-length 20

      setw -g window-status-current-style fg=colour81
      setw -g window-status-current-style bg=colour238
      setw -g window-status-current-style bold
      setw -g window-status-current-format " #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F "
      setw -g window-status-style fg=colour138
      setw -g window-status-style bg=colour235
      setw -g window-status-style none
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

      setw -g window-status-bell-style bold
      setw -g window-status-bell-style fg=colour255
      setw -g window-status-bell-style bg=colour1
      set -g status-right-length 100
      setw -g mode-keys vi
    '';
  };
  #qutebrowser
  programs.qutebrowser = {
    keyBindings = {
      normal = {
        ",m" = "spawn mpv {url}";
        ",p" = "spawn --userscript qute-pass";
        ",M" = "hint links spawn mpv {hint-url}";
      };
    };
    enable = true;
    searchEngines = {
      ddg = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?hl=en&q={}";
      yt = "https://www.youtube.com/results?search_query={}";
    };
    settings = {
      content.javascript.enabled = false;
      auto_save.session = true;
      tabs.background = true;
      zoom.default = "110%";
    };
  };
  
  # FOR x1 qutebrowser - find a way to get this in
  #  programs.qutebrowser = {
  #  settings = {
  #   qt.highdpi = true;
  #   zoom.default = "120%";
  # };
  # };
  
  programs.zathura.enable = true;
  programs.ncspot.enable = true;
  programs.info.enable = true;
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
      abook = "abook --datafile ~/Documents/sync/.abook/addressbook";
      et = "emacsclient -nw";
      bud = "cd ~/Documents/Budget/ledger/hledger/";
    };
  };

  # XDG desktop entries - org-protocol
  xdg.desktopEntries = {
    org-protocol = {
      name = "org-protocol";
      comment = "Intercept calls from emacsclient to trigger custom actions";
      categories = [ "X-Other" ];
      icon = "emacs";
      type = "Application";
      exec = "emacsclient -- %u";
      terminal = false;
      mimeType = [ "x-scheme-handler/org-protocol" ];
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
}
