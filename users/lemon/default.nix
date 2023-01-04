{ config, options, pkgs, ... }:
{
  imports = [
    ./modules
  ];

    users.users.lemon = {
    isNormalUser = true;
    description = "lemon";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [];
    # openssh.authorizedKeys.keys = config.sbruder.pubkeys.trustedKeys;
    initialPassword = "foobar"; # for vm
  };

}

