{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
in {
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = "alacritty";
      modifier = mod;
      fonts  = {
        names = ["DejaVu Sans Mono"];
        # style = "Regular";
        size = 10.0;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'DejaVu Sans Mono-10'";
        "${mod}+p" = "exec ${pkgs.pass}/bin/passmenu -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'DejaVu Sans Mono-10'";
        "${mod}+t" = "exec ${pkgs.dmenu}/bin/i3-dmenu-desktop -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'DejaVu Sans Mono-10'";

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
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = [ "DejaVu Sans Mono" ];
            size = 10.0;
          };
        }
      ];
    };
  };
}
