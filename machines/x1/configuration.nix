# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../core/laptop.nix
    ./extra.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes" ];

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-e7f5887c-fce6-4244-9624-526e8c2c9de7".device = "/dev/disk/by-uuid/e7f5887c-fce6-4244-9624-526e8c2c9de7";
  boot.initrd.luks.devices."luks-e7f5887c-fce6-4244-9624-526e8c2c9de7".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos-x1"; # Define your hostname.
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

  # To install logseq
  nixpkgs.config.permittedInsecurePackages = [ "electron-19.0.7" ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lemon = {
    isNormalUser = true;
    description = "lemon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # the following is a vscode configuration that I used
  # when NOT using nixos unstable - it allowed me grab the
  # most recent extensions from the marketplace, using the
  # script mentioned in the NixOS Wiki page about VSCode, 
  # under heading "Updating extensions versions".
  # I had problems with stable NixOS because running the
  # versionof Github Copilot referenced here, the stable
  # VSCode was not new enough.
  # Because as of 16 April 23, I am running unstable,
  # I have reverted to installing extensions with Home Manager
  # in laptop_home.nix - this does not afford the same control
  # with extensions here, but with unstable, everything should
  # be up to date.
  environment.systemPackages = with pkgs; [
	# (vscode-with-extensions.override {
	#   vscodeExtensions = with vscode-extensions; [
	# 	ms-vscode-remote.remote-ssh
	#   ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	# 	{
	# 	  name = "copilot";
	# 	  publisher = "GitHub";
	# 	  version = "1.79.10634";
	# 	  sha256 = "1a0s09aq66wkgc7560ggwh7sr0li5z2zrv65c8p080l3znc9lipi";
	# 	}
	# 	{
	# 	  name = "bash-ide-vscode";
	# 	  publisher = "mads-hartmann";
	# 	  version = "1.36.0";
	# 	  sha256 = "1fbwh51av0lqqi99b4yl4hllxcpzw90nzdf3akx3cjh95qykd9hf";
	# 	}
	# 	{
	# 	  name = "python";
	# 	  publisher = "ms-python";
	# 	  version = "2023.7.11011538";
	# 	  sha256 = "0wm9d75jvrra9abyknn8nksbc27rr274zjwd5jyrf488i1mha8s0";
	# 	}
	# 	{
	# 	  name = "vscode-pylance";
	# 	  publisher = "ms-python";
	# 	  version = "2023.4.11";
	# 	  sha256 = "1gayih5z1d0f7vljrzzdhaw5hf9q9gycasri273y5a0h7gw1hh7f";
	# 	}
	# 	{
	# 	  name = "vim";
	# 	  publisher = "vscodevim";
	# 	  version = "1.25.2";
	# 	  sha256 = "0j0li3ddrknh34k2w2f13j4x8s0lb9gsmq7pxaldhwqimarqlbc7";
	# 	}
	#   ];
	# })
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

  #gnome keyring
  services.gnome.gnome-keyring.enable = true;

}
