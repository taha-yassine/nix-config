{ inputs, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      bookmarks = [
        {
          name = "Toolbar";
          toolbar = true;
          bookmarks = [
            {
              name = "NixOS";
              bookmarks = [
                {
                  name = "NixOS Search";
                  url = "https://search.nixos.org/packages";
                }
                {
                  name = "Home Manager Config options";
                  url = "https://mipmip.github.io/home-manager-option-search/";
                }
                {
                  name = "Nix Starter Config - Misterio77";
                  url = "https://github.com/Misterio77/nix-starter-configs";
                }
                {
                  name = "Firefox Config";
                  url = "https://kb.mozillazine.org/Category:Preferences";
                }
                {
                  name = "Firefox Add-ons";
                  url = "https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix";
                }
                {
                  name = "Nix PR Tracker";
                  url = "https://nixpk.gs/pr-tracker.html";
                }
                {
                  name = "nixpkgs";
                  url = "https://github.com/NixOS/nixpkgs";
                }
              ];
            }
            {
              name = "IEEE INSA";
              url = "javascript:(function(){window.open('https://ieeexplore-ieee-org.rproxy.insa-rennes.fr'+location.pathname+location.search,'_blank')})();";
            }
          ];
        }
      ];
      settings = {
        "browser.download.useDownloadDir" = false;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.page" = 3; # Resume the previous session at startup
        "signon.rememberSignons" = false; # Disable built-in password manager
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardwaremediakeys.enabled" = false;
      };
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [ # See https://github.com/nix-community/nur-combined/tree/master/repos/rycee
        ublock-origin
        bitwarden
        i-dont-care-about-cookies
        jabref
        user-agent-string-switcher

        (let inherit (inputs.firefox-addons.lib.${pkgs.system}) buildFirefoxXpiAddon;
        in
          buildFirefoxXpiAddon {
          pname = "google-scholar-button-classic";
          version = "3.1";
          addonId = "button@scholar.google.com";
          url = "https://addons.mozilla.org/firefox/downloads/file/3656589/google_scholar_button-3.1.xpi";
          sha256 = "sha256-zscB0kG2VhP08EsofVJauCNfPF4YOEijNTsvA+7/YYc=";
          meta = {};
        })

      ];
    };
  };
}