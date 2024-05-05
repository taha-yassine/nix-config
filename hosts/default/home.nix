# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  unstable,
  ...
}: {

  # Binds nixpkgs-unstable to unstable
  _module.args.unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };

  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./hyprland.nix
    ./vscode.nix
    ./firefox.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages

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

  home.packages = (with pkgs; [ # Stable
  ]) ++ (with unstable; [ # Unstable
    zoom-us
    python311
    jabref
    (inkscape-with-extensions.override {inkscapeExtensions = [ inkscape-extensions.textext ];})
    olive-editor
    discord
    spotify
    emote
    libsForQt5.okular 
    libreoffice-fresh
    dnsutils
    slack
  ]);

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    userEmail = "yassinetaha1997@gmail.com";
    userName = "Taha YASSINE";
    enable = true;
  };
  programs.git-credential-oauth.enable = true;

  # btop
  programs.btop = {
    enable = true;
	};

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

   xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
    };
    };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
