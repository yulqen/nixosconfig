
{ config, pkgs, ...}:
{
  imports = [ ./vim.nix ];
  
  # shell
  users.users.lemon.shell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # home-manager
  home-manager.users.lemon = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    home.packages = [
      pkgs.tmux
      pkgs.git
      pkgs.fish
      pkgs.pass
      pkgs.spotify
      pkgs.alacritty
      pkgs.fzf
      pkgs.gajim
      pkgs.mpv
    ];
    programs.fish.enable = true;
    programs.fish.shellAliases = {
      chubby = "echo 'chubby bobbins!'";
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alsa-utils
    vim
    pavucontrol
    wget
    firefox
    syncthing
    emacs
    notmuch.emacs
    notmuch
    gnupg
    pinentry
  ];
  

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # fonts
    fonts.fonts = with pkgs; [
	    iosevka
	  nnn  jetbrains-mono
	    dejavu_fonts
	    noto-fonts
	    hack-font
    ];
    
    fonts.fontconfig.defaultFonts = {
	      monospace = ["JetBrains Mono"];
	      sansSerif = ["Noto Sans"];
	      serif = ["Noto Serif"];
    };
    
    # caps lock!
    services.xserver.xkbOptions = "ctrl:swapcaps";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.lemon = {
      isNormalUser = true;
      description = "lemon";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };



    # Enable networking
    networking.networkmanager.enable = true;

    # Configure keymap in X11
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
      windowManager.i3.configFile = /home/lemon/.config/i3/config;
      displayManager.gdm.enable = true;
      layout = "gb";
      xkbVariant = "";
    };

    # syncthing
    services.syncthing = {
		  enable = true;
      user = "lemon";
		  dataDir = "/home/lemon/Documents";
		  configDir = "/home/lemon/.config/syncthing";
      devices = {
        "16693433.xyz" = { id = "7ZEQHKZ-3VWYMVX-ZAS527Q-HS2KQMF-VH7RNGO-MBB6QGU-6SENRAD-T7G2RQM"; };
      };
      folders = {
        "eahtt-9qkuk" = {
          path = "/home/lemon/Documents";
          devices = [ "16693433.xyz" ];
        };
        "yjed2-erxei" = {
          path = "/home/lemon/org";
          devices = [ "16693433.xyz" ];
        };        
      };
	  };


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };      
}
