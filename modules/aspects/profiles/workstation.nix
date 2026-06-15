{ den, ... }:
{
  den.aspects.base-profile.includes = with den.aspects; [
    terminal
    git
    den.aspects."nix-tools"
    nvim
  ];

  den.aspects.dev-profile.includes = with den.aspects; [
    den.aspects."base-profile"
    containers
    den.aspects."dev-tools"
    vscode
    zed
  ];

  den.aspects.linux-workstation-user.includes = with den.aspects; [
    den.aspects."dev-profile"
    custom-packages
    den.aspects."desktop-apps"
    firefox
    gnome
    gimp
  ];

  den.aspects.framework.tyassine.includes = [ den.aspects.linux-workstation-user ];
  den.aspects.matebook.tyassine.includes = [ den.aspects.linux-workstation-user ];
  den.aspects.nexus.tyassine.includes = [ den.aspects.linux-workstation-user ];

  den.aspects.workstation = {
    includes = with den.aspects; [
      custom-packages
      tailscale
      gnome
      cosmic
      niri
    ];

    nixos =
      { pkgs, pkgs-unstable, ... }:
      {
        services.xserver = {
          # Enable the X11 windowing system.
          enable = true;

          # Configure keymap in X11.
          xkb = {
            layout = "us";
            variant = "";
          };
        };

        # For native Wayland support in Electron-based apps.
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        # Enable CUPS to print documents.
        services.printing.enable = true;

        i18n.inputMethod = {
          enable = true;
          type = "ibus";
          ibus.engines = with pkgs.ibus-engines; [ m17n ];
        };

        # Enable sound with pipewire.
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        networking.networkmanager.enable = true;

        programs.steam = {
          enable = true;
          package = pkgs.steam.override {
            # TODO: fix ugly hardcoded scaling.
            extraArgs = "-forcedesktopscaling=1.75";
          };
        };

        programs.nix-ld.enable = true;

        services.open-webui = {
          enable = true;
          package = pkgs-unstable.open-webui;
          port = 7777;
          environment.WEBUI_AUTH = "False";
        };

        virtualisation.waydroid.enable = true;

        services.fwupd.enable = true;

        fonts.packages = with pkgs; [
          nerd-fonts.hack
          corefonts
          vista-fonts
        ];

        users.users.tyassine.extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };
  };
}
