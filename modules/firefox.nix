{ pkgs, lib, inputs, ... }:

let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.browserpass.enable = true;
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      ublock-origin
      browserpass
    ];
    profiles.lemon = {
      bookmarks = {};
    };
  };
  home = {
    sessionVariables.BROWSER = "firefox";
    persistence = {
      "/persist/home/lemon".directories = [ ".mozilla/firefox" ];
    };
  };
}
