{ inputs, pkgs, pkgs-unstable, ... }:

{
  # Enable PWA support
  home.packages = [
    pkgs-unstable.firefoxpwa
  ];
  programs.firefox.nativeMessagingHosts = [
    pkgs-unstable.firefoxpwa
  ];

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
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "signon.rememberSignons" = false; # Disable built-in password manager
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardwaremediakeys.enabled" = false;
      };
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [ # See https://github.com/nix-community/nur-combined/tree/main/repos/rycee
        ublock-origin
        bitwarden
        i-dont-care-about-cookies
        jabref
        user-agent-string-switcher
          pwas-for-firefox

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

        (let inherit (inputs.firefox-addons.lib.${pkgs.system}) buildFirefoxXpiAddon;
        in
          buildFirefoxXpiAddon {
          pname = "obsidian-clipper";
          version = "0.9.5";
          addonId = "clipper@obsidian.md";
          url = "https://addons.mozilla.org/firefox/downloads/file/4386495/web_clipper_obsidian-0.9.5.xpi";
          sha256 = "sha256-7v8BkoT2Ex3t1dUlpKQLPkK2QDVdH/6VBKMwjIfbZGg=";
          meta = {};
        })

        (let inherit (inputs.firefox-addons.lib.${pkgs.system}) buildFirefoxXpiAddon;
        in
          buildFirefoxXpiAddon {
          pname = "definer";
          version = "1.7.2";
          addonId = "definer@lumetrium.com";
          url = "https://addons.mozilla.org/firefox/downloads/file/4458575/lumetrium_definer-1.7.2.xpi";
          sha256 = "sha256-8qqt2/yXW8X8xWrIRgljyXq3PA/NIs51Pj6Yzo2raUs=";
          meta = {};
        })
      ];

      search = {
        default = "Google";

        force = true;

        engines =
          let 
            snowflake_icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            github_icon = "${pkgs.fetchurl {
              url = "https://github.githubassets.com/favicons/favicon.svg";
              sha256 = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
            }}";
            youtube_icon = "${pkgs.fetchurl {
              url = "https://www.youtube.com/favicon.ico";
              sha256 = "sha256-i7HQ+kOhdDbVndVG9vdMdtxEc13vdSLCLYAxFm24kR0=";
            }}";
          in {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = snowflake_icon;
              definedAliases = [ "@np" ];
            };

            "NixOS Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = snowflake_icon;
              definedAliases = [ "@no" ];
            };

            "Nixpkgs Issues" = {
              urls = [{
                template = "https://github.com/NixOS/nixpkgs/issues";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = snowflake_icon;
              definedAliases = [ "@ni" ];
            };

            "Nixpkgs PR Tracker" = {
              urls = [{
                template = "https://nixpkgs-tracker.ocfox.me";
                params = [
                  { name = "pr"; value = "{searchTerms}"; }
                ];
              }];
              icon = snowflake_icon;
              definedAliases = [ "@npr" ];
            };
            
            "Home Manager Option Search" = {
              urls = [{
                template = "https://home-manager-options.extranix.com";
                params = [
                  { name = "release"; value = "master"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = snowflake_icon;
              definedAliases = [ "@hm" ];
            };

            "GitHub" = {
              urls = [{
                template = "https://github.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = github_icon;
              definedAliases = [ "@gh" ];
            };

            "youtube" = {
              urls = [{
                template = "https://www.youtube.com/results";
                params = [
                  { name = "search_query"; value = "{searchTerms}"; }
                ];
              }];
              icon = youtube_icon;
              definedAliases = [ "@yt" ];
            };
          };
      };
    };
  };
}