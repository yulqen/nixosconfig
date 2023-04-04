{ config, options, pkgs, ... }:

{

  imports = [ ../modules ];

  home.sessionVariables = {
    LEDGER_FILE = "/home/lemon/Documents/Budget/ledger/hledger/budget.ledger";
    EDITOR = "vim";
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
            family: Dejavu Sans Mono
            style: Regular
          size: 9.0
      '';
  };

  # mailcap
  home.file = {
    ".mailcap" = {
      target = ".mailcap";
      text = ''
# Images
image/jpg; ~/.mutt/view_attachment.sh %s jpg feh
image/jpeg; ~/.mutt/view_attachment.sh %s jpg feh
image/pjpeg; ~/.mutt/view_attachment.sh %s jpg feh
image/png; ~/.mutt/view_attachment.sh %s png feh
image/gif; ~/.mutt/view_attachment.sh %s gif feh
#
# patches
text/x-patch; vimdiff '%s'; needsterminal

# PDFs
application/pdf; ~/.mutt/view_attachment.sh %s pdf zathura

# HTML
#text/html; ~/.mutt/view_attachment.sh %s html w3m # try different
# text/html; w3m %s; nametemplate=%s.html
# text/html; w3m -dump %s; nametemplate=%s.html; copiousoutput
# text/html; lynx -dump %s; nametemplate=%s.html; copiousoutput
text/html; firefox %s; nametemplate=%s.html

# Plain Text
text/plain; cat; copiousoutput; edit=$VISUAL %s 
'';
    };
  };

  home.file = {
    ".taskopenrc".text = builtins.readFile ../modules/taskopen/taskopenrc;
  };

  # tmux
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tmux-fzf;
        extraConfig = ''
TMUX_FZF_LAUNCH_KEY="C-f"
'';
      }
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
set -g @resurrect-save 'Q'
set -g @resurrect-restore 'R'
'';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
                    set -g @continuum-restore 'on'
                    set -g @continuum-save-interval '60' # minutes
                    '';
      }
    ];
    extraConfig = ''
      set -g default-terminal "screen-256color"
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

  #password-store (unix pass)
  programs.password-store = {
    package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/lemon/.password-store";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
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

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true; # for fzf-tmux (see above
    colors = {
      info = "108";
      prompt = "109";
      spinner = "108";
      pointer = "168";
      marker = "168";
    };
    defaultCommand = "ag --nocolor -g \"\"";
    fileWidgetOptions = [ "--preview 'head {}'" ];
    historyWidgetOptions = [ "--sort" "--exact" ];
  };

  programs.newsboat = {
    enable = true;
    urls = [
      { url = "https://hnrss.org/newcomments?q=openbsd"; }
      { url = "https://hnrss.org/newest?q=openbsd"; }
      { url = "https://hnrss.org/newest?q=plaintext"; }
      { url = "https://hnrss.org/newest?q=taskwarrior"; }
      { url = "https://hnrss.org/newest?q=Roam"; }
      { url = "https://hnrss.org/newest"; }
      { url = "https://herbertlui.net/feed/"; }
      { url = "https://cheapskatesguide.org/cheapskates-guide-rss-feed.xml"; }
      { url = "https://reallifemag.com/rss"; }
      { url = "https://yulqen.org/blog/index.xml"; }
      { url = "https://yulqen.org/stream/index.xml"; }
      { url = "https://perso.pw/openbsd-current.xml"; }
      { url = "https://dataswamp.org/~solene/rss.xml"; }
      { url = "https://baty.net/feed/"; }
      { url = "https://bsdly.blogspot.com/feeds/posts/default"; }
      { url = "https://sivers.org/en.atom"; }
      { url = "http://feeds.bbci.co.uk/news/rss.xml"; }
      { url = "http://feeds.bbci.co.uk/sport/rugby-union/rss.xml?edition=uk"; }
      { url = "https://krebsonsecurity.com/feed/"; }
      { url = "https://www.computerweekly.com/rss/IT-security.xml"; }
      { url = "https://undeadly.org/errata/errata.rss"; }
      { url = "https://eli.thegreenplace.net/feeds/all.atom.xml"; }
      { url = "https://m-chrzan.xyz/rss.xml"; }
      { url = "https://plaintextproject.online/feed.xml"; }
      { url = "http://ebb.org/bkuhn/blog/rss.xml"; }
      { url = "https://usesthis.com/feed.atom"; }
      { url = "http://www.linuxjournal.com/node/feed"; }
      { url = "http://www.linuxinsider.com/perl/syndication/rssfull.pl"; }
      { url = "http://feeds.feedburner.com/mylinuxrig"; }
      { url = "https://landchad.net/rss.xml"; }
      { url = "https://lukesmith.xyz/rss.xml"; }
      { url = "https://yewtu.be/feed/channel/UCs6KfncB4OV6Vug4o_bzijg"; }
      { url = "https://idle.nprescott.com/"; }
      { url = "https://eradman.com/"; }
      { url = "https://hunden.linuxkompis.se/feed.xml"; }
      { url = "https://greghendershott.com/"; }
      { url = "https://www.romanzolotarev.com/rss.xml"; }
      { url = "https://feeds.feedburner.com/StudyHacks"; }
      { url = "https://www.theregister.com/Design/page/feeds.html"; }
      { url = "https://stevenpressfield.com/feed"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCrqM0Ym_NbK1fqeQG2VIohg"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhAh"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCittVh8imKanO_5KohzDbpgph"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UChWbNrHQHvKK6paclLp7WYw"; }
      { url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5A6gpksxKgudZxrTOpz0XA"; }
      { url = "https://www.reddit.com/r/stallmanwasright.rss"; }
      { url = "http://feeds2.feedburner.com/Command-line-fu"; }
      { url = "https://www.debian.org/News/news"; }
      { url = "https://opensource.org/news.xml"; }
      { url = "https://www.fsf.org/static/fsforg/rss/news.xml"; }
      { url = "https://jordanorelli.com/rss"; }
      { url = "https://www.c0ffee.net/rss/"; }
      { url = "http://tonsky.me/blog/atom.xml"; }
      { url = "https://akkshaya.blog/feed"; }
      { url = "https://miguelmota.com/index.xml"; }
      { url = "https://web3isgoinggreat.com/feed.xml"; }
      { url = "https://feeds.feedburner.com/arstechnica/open-source"; }
      { url = "https://karl-voit.at/feeds/lazyblorg-all.atom_1.0.links-only.xml"; }
      { url = "https://nitter.net/openbsdnow/rss"; }
      { url = "https://nitter.net/openbsd/rss"; }
      { url = "https://nitter.net/webzinepuffy/rss"; }
      { url = "https://nitter.net/bsdnow/rss"; }
      { url = "https://nitter.net/jcs/rss"; }
      { url = "https://nitter.net/openbsdjournal/rss"; }
      { url = "https://nitter.net/pitrh/rss"; }
      { url = "https://nitter.net/sizeofvoid/rss"; }
      { url = "https://nitter.net/canadianbryan/rss"; }
      { url = "https://nitter.net/wesley974/rss"; }
      { url = "https://nitter.net/slashdot/rss"; }
      { url = "https://www.romanzolotarev.com/rss.xml"; }
      { url = "https://www.romanzolotarev.com/n/rss.xml"; }
    ];
    extraConfig = ''
auto-reload no
run-on-startup toggle-show-read-feeds
bind-key j down
bind-key k up
bind-key j next articlelist
bind-key k prev articlelist
bind-key J next-feed articlelist
bind-key K prev-feed articlelist
bind-key G end
bind-key g home
bind-key d pagedown
bind-key u pageup
#bind-key l open
bind-key h quit
bind-key a toggle-article-read
bind-key n next-unread
bind-key N prev-unread
bind-key D pb-download
bind-key U show-urls
bind-key x pb-delete

refresh-on-startup no
define-filter "Linux articles" "title =~ \"Linux\""
color info color15 color6
#macro y set browser "mpv %u"; open-in-browser ; set browser "elinks %u"
#color listfocus color15 color0
color listfocus color14 color0
color listfocus_unread color15 color0 bold
#highlight-article "title =~ \"Productivity\"" white red bold
#highlight-article "title =~ \"Setup\"" yellow red bold
#highlight all "Linux" yellow red bold
notify-program "notify-send"
notify-screen yes
notify-xterm yes

max-items 40
download-path "~/Downloads"

player mpv
#browser /home/lemon/bin/lynx
macro m set browser "mpv %u" ; open-in-browser ; set browser "/home/lemon/dotfiles/lynx/lynx %u"
macro y set browser "get-newsboat-comment.sh %u" ; open-in-browser ; set browser "/home/lemon/dotfiles/lynx/lynx %u"

confirm-mark-all-feeds-read no
confirm-mark-feed-read no

show-read-articles no

highlight article "^(Title):.*$" blue default
highlight article "https?://[^ ]+" red default
highlight article "\\[image\\ [0-9]+\\]" green default
    '';
  };
  
  programs.zathura.enable = true;
  programs.ncspot.enable = true;
  programs.info.enable = true;
  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
    };
  };
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc;
    initExtra = ''
#      source ${pkgs.pass}/share/bash/vendor_completions.d/pass.bash
#      source ${pkgs.taskwarrior}/share/bash/vendor_completions.d/task.bash
    '';
    shellAliases = {
      vi = "vim";
      llynx = "~/.config/lynx/lynx";
      am = "append_to_masterlist";
      ns = "nix shell";
      qnv = "vim ~/Documents/Notes/quicknote.md";
      qnl = "less ~/Documents/Notes/quicknote.md";
      h = "hey_openai";
      hd = "openai_data";
      nrs = "sudo nixos-rebuild switch --flake .#";
      abook = "abook --datafile ~/Documents/sync/.abook/addressbook";
      notes = "cd ~/Documents/Notes";
      bud = "cd ~/Documents/Budget/ledger/hledger/";
      getip = "curl ifconfig.me";
      tprojects = "task rc.list.all.projects=1 projects";
      ttags = "task rc.list.all.tags=1 tags";
      tkilled = "task +killlist list";
      ttagged = "task tags.any: list";
      tuntagged = "task tags.none: list";
      ttoday = "task ml_due_or_scheduled_today";
      tl = "/home/lemon/Documents/Notes/todo/todo.sh list";
      t = "/home/lemon/Documents/Notes/todo/todo.sh";
    };
  };
  programs.fish = {
    functions = {
	};
    shellInit = ''
         set fish_greeting ""
         set -gx LESS '-iMRS -x2'
         source ${pkgs.pass}/share/fish/vendor_completions.d/pass.fish
         source ${pkgs.taskwarrior}/share/fish/vendor_completions.d/task.fish
      '';
    enable = true;
    shellAliases = {
      ns = "nix shell";
      qnv = "vim ~/Documents/Notes/quicknote.md";
      qnl = "less ~/Documents/Notes/quicknote.md";
      nrs = "sudo nixos-rebuild switch --flake .#";
      chubby = "echo 'chubby bobbins!'";
      abook = "abook --datafile ~/Documents/sync/.abook/addressbook";
      notes = "cd ~/Documents/Notes";
      et = "emacsclient -nw";
      bud = "cd ~/Documents/Budget/ledger/hledger/";
      getip = "curl ifconfig.me";
      tprojects = "task rc.list.all.projects=1 projects";
      ttags = "task rc.list.all.tags=1 tags";
      tkilled = "task +killlist list";
      ttagged = "task tags.any: list";
      tuntagged = "task tags.none: list";
      ttoday = "task ml_due_or_scheduled_today";
      tl = "/home/lemon/Documents/Notes/todo/todo.sh list";
      t = "/home/lemon/Documents/Notes/todo/todo.sh";
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
