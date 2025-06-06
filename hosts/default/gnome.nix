{ pkgs, pkgs-unstable, ... }:
let
  extensions = with pkgs-unstable.gnomeExtensions; [
    caffeine
    blur-my-shell
    media-controls
    battery-health-charging
    bluetooth-battery-meter
    tiling-shell
    grand-theft-focus
    power-profile-indicator-2
    just-perfection
    vitals
    wsp-windows-search-provider
  ];
in
{
  nixpkgs.overlays = [
    (self: super: {
      gnomeExtensions = super.gnomeExtensions // {
        power-profile-indicator-2 = super.power-profile-indicator-2.overrideAttrs (old: {
          version = "develop";
          src = super.fetchFromGitHub {
            owner = "fthx";
            repo = "power-profile";
            rev = "0bcdb8f";
            sha256 = super.lib.fakeSha256;
          };
        });
      };
    })
  ];

  home.packages = with pkgs-unstable; [  
    gnome-power-manager
    gnome-network-displays
  ] ++ extensions;

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.whitesur-gtk-theme;
    #   name = "WhiteSur-dark";
    # };
    # theme = {
    #   package = pkgs.flat-remix-gtk;
    #   name = "Flat-Remix-Dark-Solid";
    # };
  };

  # dconf settings
  dconf.settings = {
    # Extensions
    "org/gnome/shell" = {
      enabled-extensions = map (extension: extension.extensionUuid) 
                            (extensions ++ (with pkgs-unstable.gnomeExtensions; [
                              system-monitor
                            ]));
    };

    # Keybindings
    ## Built-in
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-up = [];
      switch-to-workspace-down = [];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
    };
    ## Custom
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "ghostty";
      binding = "<Super>q";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Emoji Picker";
      command = "smile";
      binding = "<Super>period";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Spotify";
      command = "spotify";
      binding = "<Super>m";
    };

    # Issue: The Framework key (keycode 226) was launching media player in GNOME.
    # Cause: GNOME's 'media-static' GSettings binding (org.gnome.settings-daemon.plugins.media-keys media-static) was hardcoded to ['XF86AudioMedia'], even though 'showkey' confirmed keycode 226 was seen by the kernel. This override prevented custom keybindings.
    # Fix: Cleare the 'media-static' binding in dconf-editor before adding a custom binding.
    # Related report: https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/issues/466
    "org/gnome/settings-daemon/plugins/media-keys".media-static = [""];
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Power Toggle";
      command = "power-toggle";
      binding = "AudioMedia";
    };

    # Settings
    "org/gnome/desktop/interface".enable-hot-corners = false;
    "org/gnome/desktop/wm/preferences".auto-raise = true; # Focus new windows
    "org/gnome/desktop/session".lock-enabled = false; # Disable screen lock after it blanks
  };
}
