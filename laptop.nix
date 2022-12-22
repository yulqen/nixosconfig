
{ config, pkgs, ...}:
{
  # fonts
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
}
