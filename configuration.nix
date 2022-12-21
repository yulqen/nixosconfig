# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).


{ config, pkgs, ... }:


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  
  fonts.fonts = with pkgs; [
	iosevka
	jetbrains-mono
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

  # shell
  programs.fish.enable = true;
  users.users.lemon.shell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];
  # an example of setting a fish alias
  programs.fish.shellAliases = {
    chubby = "echo 'chubby bobbins!'";
  };
 
  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-046eead4-47c7-428b-820f-8ad6f764e239".keyFile = "/crypto_keyfile.bin";
  # Enable swap on luks
  boot.initrd.luks.devices."luks-921d7aba-5f10-43f8-bfe7-2be9990bd149".device = "/dev/disk/by-uuid/921d7aba-5f10-43f8-bfe7-2be9990bd149";
  boot.initrd.luks.devices."luks-921d7aba-5f10-43f8-bfe7-2be9990bd149".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager.gdm.enable = true;
    layout = "gb";
    xkbVariant = "";
  };

  services.syncthing = {
		enable = true;
    user = "lemon";
		dataDir = "/home/lemon/Documents";
		configDir = "/home/lemon/.config/syncthing";
	};

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lemon = {
    isNormalUser = true;
    description = "Matthew Lemon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    firefox
    syncthing
    gnupg
    iosevka
    alacritty
    emacs
    gajim
    fish
    notmuch
    notmuch.emacs
    tmux
    fzf
    sqlite
    hledger
    git-annex
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
