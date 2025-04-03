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

    # Allow unfree packages
    config.allowUnfree = true;
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
        "msgcompose.default_colors" = false;
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
    vesktop
    spotify
    emote
    libsForQt5.okular 
    libreoffice-fresh
    dnsutils
    slack
    neofetch
    steam
    heroic
    ffmpeg
    trayscale
    aichat
    wl-clipboard
    
    # Gnome
    gnomeExtensions.keep-awake
    gnomeExtensions.blur-my-shell
    gnomeExtensions.power-profile-indicator-2
    gnomeExtensions.media-controls
    gnomeExtensions.battery-health-charging
    gnomeExtensions.bluetooth-battery-meter

  ]) ++ [
    outputs.packages.x86_64-linux.cursor
  ];

  programs.home-manager.enable = true;

  # btop
  programs.btop = {
    enable = true;
    
    # GPU support
    # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    package = unstable.btop.override {
      cudaSupport = true;
      rocmSupport = true;
    };
	};

  # ZSH
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";

      lg = "lazygit";
      
      # Command to work with flakes without worrying about git; source: https://mtlynch.io/notes/use-nix-flake-without-git/ 
      git-ignoreflake = ''
        git add --intent-to-add -f flake.nix flake.lock &&
        git update-index --assume-unchanged flake.nix flake.lock
      '';
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "dracula/zsh"; tags = ["as:theme"]; }
      ];
    };

    initExtra = ''

        # Define autocomplete for devshell init
        # Credits: https://github.com/SoraTenshi/nixos-config/blob/a2db14ba3480f1ea265e152d0829c8c70783861e/home/shells/zsh/default.nix
        devshell() {
          nix flake init --template github:the-nix-way/dev-templates#$1 && ${pkgs.direnv}/bin/direnv allow
        }

        _devshell() {
          compadd clojure csharp cue dhall elixir elm gleam go \
             hashi haskell java kotlin latex nickel nim nix node ocaml \
             opa php protobuf purescript python ruby rust-toolchain rust scala shell zig
        }
        compdef _devshell devshell
        # End definition of devshell
      '';

    enableCompletion = false; # Temp fix for slow zsh startup; until https://github.com/nix-community/home-manager/pull/6063 is merged
  };

  # Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$all";
      line_break.disabled = true;
      command_timeout = 2000;
      # nix_shell.heuristic = true;
    };
  };

  programs.zellij.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
      set clipboard+=unnamedplus
    '';
  };
  
  programs.lazygit.enable = true;

  programs.fzf.enable = true;

  programs.bat.enable = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # Better as it prevents gc of the environment
  };

  # Terminal
  programs.kitty = {
    enable = true;
    # theme = "Dracula";
    # theme = "Molokai";
    # theme = "Japanesque";
    # theme = "Shaman";
    theme = "Spacedust";
    # theme = "Thayer Bright";
    # theme = "Treehouse";
    settings = {
      wayland_titlebar_color="system";
    };
    keybindings = {
      "ctrl+k" = "send_text all aichat -e\\x20"; # emulates cursor's ctrl+k
    };
  };

  programs.pandoc.enable = true;

  # VLC config
  xdg.configFile."vlc/vlcrc".text = lib.generators.toINI { } {
    # Stops VLC from asking for network metadata access
    qt.qt-privacy-ask = 0;
    core.metadata-network-access = 0;

    # Mirror Youtube keybindings
    core.global-key-rate-faster-fine = "Shift+.";
    core.global-key-rate-slower-fine = "Shift+,";
  };

  # Default apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
      "image/png" = ["org.gnome.Loupe.desktop"];
      "image/jpeg" = ["org.gnome.Loupe.desktop"];
    };
  };
  # Force mimeapps.list to be rewritten; useful when other programs change it.
  xdg.configFile."mimeapps.list".force = true;


  # dconf
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "KeepAwake@jepfa.de" 
        "blur-my-shell@aunetx"
        "power-profile@fthx"
        "mediacontrols@cliffniff.github.com"
        "Battery-Health-Charging@maniacx.github.com"
        "Bluetooth-Battery-Meter@maniacx.github.com"
      ];
    };

    "org/gnome/desktop/interface" = {
      enable-hot-corners = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
