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
    initialPassword = "foobar"; # for vm
  };
}

