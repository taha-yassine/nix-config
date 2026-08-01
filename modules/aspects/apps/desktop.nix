{ inputs, ... }:
{
  den.aspects.desktop-apps.homeManager =
    {
      pkgs,
      pkgs-unstable,
      self',
      lib,
      ...
    }:
    {
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
        extraPackages = tpkgs: {
          inherit (tpkgs)
            scheme-medium
            luatex
            cm-super
            type1cm
            collection-latexextra
            biber
            ;
        };
      };

      home.packages =
        (with pkgs-unstable; [
          jabref
          zoom-us
          teams-for-linux
          (inkscape-with-extensions.override { inkscapeExtensions = [ inkscape-extensions.textext ]; })
          discord
          spotify
          slack
          libreoffice-fresh
          distrobox
          llama-cpp
          qbittorrent
          ffmpeg
          vulkan-tools
          obsidian
          element-desktop
          trayscale
          signal-desktop
          google-chrome
          vlc
          audacity
          smile
          rquickshare
          nvitop
          krita
          resources
          handbrake
          beeper
          codegrab
          calibre
          # TODO: Remove this workaround once jellyfin-desktop v3 is packaged.
          # https://github.com/NixOS/nixpkgs/issues/519073#issuecomment-4434887630
          (jellyfin-media-player.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
            postFixup = (old.postFixup or "") + ''
              wrapProgram $out/bin/jellyfin-desktop \
                --set QTWEBENGINE_FORCE_USE_GBM 0
            '';
          }))
          kooha
          gradia
          gnome-decoder
          collabora-online
          graphite
          aegisub
          kdePackages.kdenlive
          headsetcontrol
          ddcutil
          constrict
        ])
        ++ [
          inputs.affinity-nix.packages.${pkgs.system}.default
          self'.packages.power-toggle
        ];

      programs.onlyoffice.enable = true;

      xdg.configFile."vlc/vlcrc".text = lib.generators.toINI { } {
        # Stops VLC from asking for network metadata access.
        qt.qt-privacy-ask = 0;
        core.metadata-network-access = 0;

        # Mirror Youtube keybindings.
        core.global-key-rate-faster-fine = "Shift+.";
        core.global-key-rate-slower-fine = "Shift+,";
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = [ "org.gnome.Papers.desktop" ];
          "image/png" = [ "org.gnome.Loupe.desktop" ];
          "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
          "image/gif" = [ "org.gnome.Loupe.desktop" ];
          "text/plain" = [ "nvim.desktop" ];
        };
      };

      # Force mimeapps.list to be rewritten; useful when other programs change it.
      xdg.configFile."mimeapps.list".force = true;
    };
}
