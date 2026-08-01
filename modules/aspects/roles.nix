{ den, ... }:
{
  den.aspects.developer.includes = with den.aspects; [
    terminal
    git
    den.aspects."nix-tools"
    nvim
    containers
    den.aspects."dev-tools"
    den.aspects."ai-dev-tools"
    vscode
    zed
  ];

  den.aspects.linux-workstation = {
    includes = with den.aspects; [
      developer
      den.aspects."desktop-apps"
      firefox
      gnome
      gimp
      den.aspects.open-webui
      tailscale
    ];

    nixos =
      { pkgs, ... }:
      {
        services.xserver = {
          enable = true;
          xkb = {
            layout = "us";
            variant = "";
          };
        };

        # Prefer native Wayland support in Electron applications.
        environment.sessionVariables.NIXOS_OZONE_WL = "1";

        services.printing.enable = true;

        i18n.inputMethod = {
          enable = true;
          type = "ibus";
          ibus.engines = with pkgs.ibus-engines; [ m17n ];
        };

        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        networking.networkmanager.enable = true;
        services.fwupd.enable = true;

        fonts.packages = with pkgs; [
          nerd-fonts.hack
          corefonts
          vista-fonts
        ];
      };
  };
}
