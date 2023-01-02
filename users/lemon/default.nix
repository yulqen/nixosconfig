{ config, options, pkgs, ... }:
{
   users.users.lemon = {
    isNormalUser = true;
    description = "lemon";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [];
    # openssh.authorizedKeys.keys = config.sbruder.pubkeys.trustedKeys;
    initialPassword = "foobar"; # for vm
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.lemon = { lib, pkgs, ... }: {
    imports = [ ./modules ];

    config = {
      home.stateVersion = config.system.stateVersion;
    };
  };
}

