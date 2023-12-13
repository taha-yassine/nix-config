# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # Hyperland
    inputs.hyprland.homeManagerModules.default

    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "tyassine";
    homeDirectory = "/home/tyassine";
    shellAliases = {
      "la" = "ls -la";
    };
  };

  # Applications
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      bookmarks = [
        {
          name = "NixOS Search";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "Home Manager Config options";
          url = "https://nix-community.github.io/home-manager/options.html";
        }
        {
          name = "IEEE INSA";
          url = "javascript:(function(){window.open('https://ieeexplore-ieee-org.rproxy.insa-rennes.fr'+location.pathname+location.search,'_blank')})();";
        }
      ];
      settings = {
        "browser.download.useDownloadDir" = false;
        "signon.rememberSignons" = false; # Disable built-in password manager
      };
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [ # See https://github.com/nix-community/nur-combined/tree/master/repos/rycee
        ublock-origin
        bitwarden
      ];
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "mail.compose.default_to_paragraph" = false;
      };
    };
  };
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
  };
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      james-yu.latex-workshop
      jnoortheen.nix-ide
      mhutchie.git-graph
      eamodio.gitlens
      streetsidesoftware.code-spell-checker
      arrterian.nix-env-selector
    ];
    userSettings = {
      "editor.wordWrap" = "on";
      "workbench.colorTheme" = "Default Dark Modern";
      "window.zoomLevel" = 1;
      "latex-workshop.intellisense.citation.type" = "browser";
      "[nix]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };

    };
  };

  home.packages = (with pkgs; [ # Stable
    #teams TODO: Package is marked as insecure. Needs investigation. 
  ]) ++ (with pkgs.unstable; [ # Unstable
    zoom-us
    python311
    jabref
    (inkscape-with-extensions.override {inkscapeExtensions = [ inkscape-extensions.textext ];})
    discord
    spotify
    emote
    libsForQt5.okular 
    htop
    libreoffice-fresh
    dnsutils
  ]);

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    userEmail = "yassinetaha1997@gmail.com";
    userName = "Taha YASSINE";
    enable = true;
  # ZSH
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = ["as:theme"]; }
      ];
    };
  };

  # Hyprland
  wayland.windowManager.hyprland.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
