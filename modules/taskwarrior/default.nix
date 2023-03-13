{ config, pkgs, ...}: {

  programs.taskwarrior = {
    enable = true;
    dataLocation = "$XDG_DATA_HOME/task";
    extraConfig = builtins.readFile ./taskrc;
  };
}
