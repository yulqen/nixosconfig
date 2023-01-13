
{ config, pkgs, ...}:
{
  # garbage collection
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # emacs as a systemd service
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
    defaultEditor = true; # this can be overriden by EDTIOR environment variable, so get rid of them.
  };

  # shell
  users.users.lemon.shell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    alsa-utils
    vim
    emacs
    pavucontrol
    syncthing
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
	  iosevka-bin
    terminus_font
	  jetbrains-mono
	  dejavu_fonts
	  noto-fonts
	  hack-font
  ];
    
  fonts.fontconfig.defaultFonts = {
	  monospace = ["Iosevka Fixed"];
	  sansSerif = ["Noto Sans"];
	  serif = ["Noto Serif"];
  };
  
  # caps lock!
  services.xserver.xkbOptions = "ctrl:swapcaps";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lemon = {
    isNormalUser = true;
    description = "lemon";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;
    windowManager.i3.extraPackages = with pkgs; [
      dmenu
      i3status
      i3lock
    ];
     displayManager.defaultSession = "none+i3";
    displayManager.gdm.enable = true;
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
  
  # wireguard
  # networking.firewall = {
  #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  # };
  # # Enable WireGuard
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     # CHANGE THIS FROM DEFAULT DEPENDING ON LAPTOP
  #     ips = [ "10.100.56.5/32" ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     privateKeyFile = "/home/lemon/wireguard-keys/private";

  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.

  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "b4jbmc6tcZNle7Tr/7h5+I5YEZU/jsKs4exz5fyjbg8=";

  #         # Forward all the traffic via VPN.
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #         # Set this to the server IP and port.
  #         endpoint = "16693433.xyz:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
}
