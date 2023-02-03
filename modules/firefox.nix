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
      bitwarden
      vimium
    ];
    profiles.lemon = {
      search.default = "DuckDuckGo";
      search.force = true;
      isDefault = true;
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };

        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      };
      search.order = [ "DuckDuckGo" "Google" ];
      bookmarks = [
        {
          name = "wikipedia";
          keyword = "wiki";
          url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
        }
        {
          name = "Nix sites";
          bookmarks = [
            {
              name = "Nix Dev";
              keyword = "nix";
              url = "https://nix.dev/";
            }
            {
              name = "Nix Language guide";
              keyword = "nix";
              url = "https://nixos.org/guides/nix-language.html";
            }
            {
              name = "Nix Package Search";
              url = "https://search.nixos.org/packages";
            }
            {
              name = "NixOS Homepage";
              url = "https://nixos.org/";
            }
            {
              name = "Home Manager Options Search";
              url = "https://mipmip.github.io/home-manager-option-search/";
            }             
            {
              name = "NixOS Wiki";
              url = "https://nixos.wiki/";
            }
          ];
        }
      ];
      settings = {
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.enabled" = false;
        "browser.search.region" = "GB";
        "browser.search.isUS" = false;
        "distribution.searchplugins.defaultLocale" = "en-GB";
        "general.useragent.locale" = "en-GB";
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotecton.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        "reader.color_scheme" = "dark";
        "signon.rememberSignons" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.aboutConfig.showWarning" = false;
        "privacy.clearOnShutdown.history" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      };
    };
  };
  home = {
    sessionVariables.BROWSER = "firefox";

  };
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };
}
