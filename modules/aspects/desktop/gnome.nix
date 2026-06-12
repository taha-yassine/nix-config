{ den, ... }:
{
  den.aspects.gnome = {
    nixos =
      { pkgs, ... }:
      {
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

        services.displayManager.autoLogin = {
          user = "tyassine";
          enable = true;
        };

        # Disable some GNOME packages.
        # services.gnome.core-utilities.enable = false;
        # Fixes NVIDIA bug; see https://gitlab.gnome.org/GNOME/gnome-remote-desktop/-/issues/141
        environment.gnome.excludePackages = with pkgs; [ gnome-remote-desktop ];

        # extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # already added by GNOME
        xdg.portal.enable = true;

        # Workaround for GNOME autologin.
        # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
        systemd.services."getty@tty1".enable = false;
        systemd.services."autovt@tty1".enable = false;
      };

    homeManager =
      {
        pkgs,
        pkgs-unstable,
        lib,
        ...
      }:
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
          gsconnect
          runcat
          tailscale-status
          quick-settings-audio-devices-hider
          brightness-control-using-ddcutil
          (copyous.overrideAttrs (_old: {
            buildInputs = [
              pkgs-unstable.libgda5
            ];
            preInstall = ''
              sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${pkgs-unstable.libgda5}/lib/girepository-1.0');\nGIRepository.Repository.dup_default().prepend_search_path('${pkgs-unstable.gsound}/lib/girepository-1.0');\n" lib/preferences/dependencies/dependencies.js
              sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${pkgs-unstable.libgda5}/lib/girepository-1.0');\n" lib/misc/db.js
            '';
          })) # Fix from https://github.com/boerdereinar/copyous/issues/67#issuecomment-3983477333
          power-off-options
          all-in-one-clipboard

          # Search providers
          wsp-windows-search-provider
          esp-extensions-search-provider
        ];
      in
      {
        home.packages =
          (with pkgs-unstable; [
            gnome-power-manager
            gnome-network-displays
            nautilus-python
          ])
          ++ extensions;

        # Needed for nautilus-python.
        # From https://github.com/wimpysworld/nix-config/blob/aa4024fd35507df7099e11b823204f24f0cf4120/home-manager/_mixins/desktop/apps/default.nix#L72-L74
        home.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs-unstable.nautilus-python}/lib/nautilus/extensions-4";

        gtk.enable = true;

        # Allow screen recording to work with H264 for gnome-shell and Kooha.
        # Adapted from https://github.com/NixOS/nixpkgs/issues/409755#issuecomment-2931205330
        home.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.mkForce (
          lib.concatStringsSep ":" [
            "${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"
            "${pkgs.gst_all_1.gst-vaapi}/lib/gstreamer-1.0"
          ]
        );

        dconf.settings = {
          # Extensions.
          "org/gnome/shell" = {
            enabled-extensions = map (extension: extension.extensionUuid) (
              extensions ++ (with pkgs-unstable.gnomeExtensions; [ system-monitor ])
            );
          };

          # Keybindings.
          # Built-in.
          "org/gnome/desktop/wm/keybindings" = {
            switch-to-workspace-up = [ ];
            switch-to-workspace-down = [ ];
            switch-to-workspace-left = [ ];
            switch-to-workspace-right = [ ];
          };

          # Custom.
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
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
          # Fix: Clear the 'media-static' binding in dconf-editor before adding a custom binding.
          # Related report: https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/issues/466
          "org/gnome/settings-daemon/plugins/media-keys".media-static = [ "" ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            name = "Power Toggle";
            command = "power-toggle";
            binding = "AudioMedia";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
            name = "Nautilus";
            command = "nautilus";
            binding = "<Super>e";
          };

          # Settings.
          "org/gnome/desktop/interface".enable-hot-corners = false;
          # auto-raise steals focus from the lock screen password field after suspend/resume.
          # https://bugs.launchpad.net/ubuntu/+source/gnome-shell/+bug/2009712
          "org/gnome/desktop/wm/preferences".auto-raise = false;
          "org/gnome/desktop/session".lock-enabled = false; # Disable screen lock after it blanks.
          "org/gnome/shell/app-switcher".current-workspace-only = true;
          "org/gnome/shell/window-switcher".current-workspace-only = true;
          "org/gnome/settings-daemon/plugins/housekeeping".free-percent-notify = 0.1;
          "org/gnome/settings-daemon/plugins/housekeeping".free-percent-notify-again = 0.05;
          "org/gnome/settings-daemon/plugins/housekeeping".free-size-gb-no-notify = 30;

          # Extension settings.
          # Use dconf-editor to explore the available settings for each extension.
          # Just Perfection.
          # "org/gnome/shell/extensions/just-perfection".panel-button-padding-size = 2; # Value shown in settings panel is 1 less.
          "org/gnome/shell/extensions/just-perfection".clock-menu-position = 0; # Center.

          # Vitals.
          "org/gnome/shell/extensions/vitals".position-in-panel = 0; # Left.
          "org/gnome/shell/extensions/vitals".icon-style = 1; # Gnome Icons.

          # Media Controls.
          "org/gnome/shell/extensions/mediacontrols".extension-position = "Left";
          "org/gnome/shell/extensions/mediacontrols".extension-index = 5;

          # GSConnect.
          "org/gnome/shell/extensions/gsconnect".show-indicators = true;

          # RunCat.
          "org/gnome/shell/extensions/runcat".custom-system-monitor-enabled = true;
          "org/gnome/shell/extensions/runcat".custom-system-monitor-command = "resources -t processes";

          # Input sources.
          "org/gnome/desktop/input-sources" = {
            sources = [
              (lib.hm.gvariant.mkTuple [
                "xkb"
                "us+altgr-intl"
              ])
              (lib.hm.gvariant.mkTuple [
                "ibus"
                "m17n:ar:translit"
              ])
            ];
          };

          # Other.
          "org/gnome/desktop/applications/terminal" = {
            exec = "ghostty";
            exec-arg = "-e";
          };
        };
      };
  };
}
