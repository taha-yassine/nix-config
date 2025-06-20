# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-staging,
  ...
}: {

  # Binds nixpkgs-unstable to pkgs-unstable
  # and nixpkgs-staging to pkgs-staging
  _module.args = {
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
    pkgs-staging = import inputs.nixpkgs-staging {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
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
    ./git.nix
    ./gnome.nix
    ./shells.nix
    ./gimp.nix
    ./nvim.nix
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
  ]) ++ (with pkgs-unstable; [ # Unstable
    (python313.withPackages(ps: with ps; [ 
    ]))
    jabref
    zoom-us
    uv
    teams-for-linux
    (inkscape-with-extensions.override {inkscapeExtensions = [ inkscape-extensions.textext ];})
    olive-editor
    discord
    spotify
    libsForQt5.okular 
    dnsutils
    slack
    gnumake
    libreoffice-fresh
    distrobox
    wget
    ollama
    cht-sh
    unzip
    qbittorrent
    gamescope
    ffmpeg
    vulkan-tools
    wineWowPackages.waylandFull
    gdu
    obsidian
    nix-output-monitor
    calibre
    element-desktop # Matrix client
    trayscale # Tailscale GUI
    signal-desktop
    google-chrome
    nix-init
    vlc
    nixfmt-rfc-style
    code-cursor
    code2prompt
    yt-dlp # Youtube downloader CLI
    audacity
    sqlitebrowser
    aichat
    wl-clipboard
    smile # Emoji picker
    rquickshare
    nixd # Nix LSP
    gdu
    devcontainer
    heroic
    nvtopPackages.full
    nvitop
    krita # Image editor (Gimp alternative)
    glow # Markdown viewer
    posting # TUI API client
    jq
    resources
    windsurf
    handbrake
    beeper # Chat aggregator

    # VM
    virt-manager
    virtio-win
    virtiofsd
  ]) ++ (with pkgs-staging; [
  ]) ++ [
    outputs.packages.x86_64-linux.power-toggle
  ];

  programs.home-manager.enable = true;

  # btop
  programs.btop = {
    enable = true;
    
    # GPU support
    # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    package = pkgs-unstable.btop.override {
      cudaSupport = true;
      rocmSupport = true;
    };
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

  programs.zellij = {
    settings = {
      theme = "molokai-dark";
    };
  };  
  
  programs.lazygit.enable = true;

  programs.fzf.enable = true;

  programs.bat.enable = true;

  programs.yazi = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    settings = {
      filter_mode = "session";
      enter_accept = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better as it prevents gc of the environment
  };

  # Terminal
  programs.kitty = {
    enable = true;
    # themeFile = "Dracula";
    themeFile = "Molokai";
    # themeFile = "Japanesque";
    # themeFile = "Shaman";
    # themeFile = "Spacedust";
    # themeFile = "Thayer Bright";
    # themeFile = "Treehouse";
    settings = {
      wayland_titlebar_color="system";
    };
  };

  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "Monokai Remastered";
      keybind = [
        "ctrl+shift+w=close_surface"
      ];
    };
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--octal-permissions"
      "--hyperlink"
    ];
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      telemetry = {
        metrics = false;
      };
      vim_mode = true;
      theme = "Ayu Dark";
    };
  };

  programs.pandoc.enable = true;

  programs.ripgrep.enable = true;

  programs.nh = {
    enable = true;
  };
  
  programs.fastfetch.enable = true;

  # Tailscale GUI
  services.trayscale = {
    enable = true;
    hideWindow = true;
  };

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
      "image/gif" = ["org.gnome.Loupe.desktop"];
    };
  };
  # Force mimeapps.list to be rewritten; useful when other programs change it.
  xdg.configFile."mimeapps.list".force = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
