{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
in {
  home-manager.users.lemon.xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      fonts = {
        names = ["monospace-10"];
        style = "Regular";
        size = 11.0;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/passmenu";        

        # Focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
      };
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }
      ];
    };
  };
}
