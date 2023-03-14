{ config, pkgs, ...}: {

  programs.taskwarrior = {
    enable = true;
    colorTheme = ./dark-blue-256.theme;
    dataLocation = "$XDG_DATA_HOME/task";
    extraConfig = builtins.readFile ./taskrc;
  };
}
