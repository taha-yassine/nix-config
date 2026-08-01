{ den, inputs, ... }:
{
  den.aspects.framework = {
    nixos =
      {
        pkgs,
        lib,
        primaryUserName,
        ...
      }:
      {
        imports = [
          ./_hardware.nix
          "${inputs.nixos-hardware}/framework/13-inch/common/classic-audio.nix"
        ];

        virtualisation.vmVariant = {
          swapDevices = lib.mkVMOverride [ ];
          boot.resumeDevice = lib.mkVMOverride "";
        };

        # Prefer using LTS because NVIDIA drivers tend to fail to build otherwise
        # https://discourse.nixos.org/t/cannot-build-nvidia-x11-570-153-02-6-15/64898/5
        # boot.kernelPackages = pkgs.linuxPackages_6_18;
        boot.kernelPackages = pkgs.linuxPackages_latest;

        # Fix: USB-C dongle (e.g. Arctis Nova 5X) not detected when plugged directly into USB-C.
        # The AMD Phoenix firmware returns "unrecognized command" for GET_CABLE_PROPERTY, which
        # causes ucsi_register_cable() to abort and the USB data path to never be enabled.
        # This patch makes the failure non-fatal and falls back to a passive USB-C cable assumption.
        # boot.kernelPatches = [{
        #   name = "ucsi-cable-property-non-fatal";
        #   patch = ./_ucsi-cable-property-non-fatal.patch;
        # }];

        boot.kernelModules = [ "amdgpu" ];

        # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
        # https://gitlab.freedesktop.org/drm/amd/-/issues/2862
        # https://gitlab.freedesktop.org/drm/amd/-/issues/4238
        # https://community.frame.work/t/amdgpu-error-queueing-dmub-command-status-2-when-waking-from-suspend/53155/
        # https://www.reddit.com/r/tuxedocomputers/comments/1jjzye7/amdgpu_especially_780m_is_not_ready/
        boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];

        # Enable NTFS support.
        boot.supportedFilesystems = [ "ntfs" ];

        virtualisation.docker.enable = true;
        # Required by ddcutil (used by brightness-control-using-ddcutil GNOME extension).
        hardware.i2c.enable = true;
        users.users.${primaryUserName}.extraGroups = [
          "docker"
          "i2c"
        ];

        # Enable fingerprint reader.
        services.fprintd.enable = true;
        # gdm-password delegates auth to the `login` PAM service in NixOS 26.05+,
        # so fprintd tweaks live on `login` now.
        security.pam.services.login.rules.auth.fprintd.settings = {
          timeout = -1;
          max-tries = -1;
        };

        # AMD has better battery life with PPD over TLP:
        # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
        services.power-profiles-daemon.enable = true;

        services.xserver.videoDrivers = [ "amdgpu" ];

        # The Framework is also used for occasional gaming on its HiDPI panel.
        programs.steam.package = pkgs.steam.override {
          extraArgs = "-forcedesktopscaling=1.75";
        };

        # Enable OBS virtual camera.
        programs.obs-studio = {
          enable = true;
          enableVirtualCamera = true;
          plugins = with pkgs; [
            obs-studio-plugins.obs-vaapi
            obs-studio-plugins.obs-pipewire-audio-capture
          ];
        };

        # Audio enhancements.
        hardware.framework.laptop13.audioEnhancement = {
          enable = true;
          rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stereo";
        };

        services.sunshine = {
          enable = true;
          capSysAdmin = true;
          openFirewall = true;
        };

        networking.firewall = {
          enable = true;
          allowedTCPPorts = [ 54321 ]; # rquickshare
          allowedTCPPortRanges = [
            {
              from = 1714;
              to = 1764;
            } # GSConnect
          ];
          allowedUDPPorts = [ 54321 ]; # rquickshare
          allowedUDPPortRanges = [
            {
              from = 1714;
              to = 1764;
            } # GSConnect
          ];
        };
      };

    homeManager =
      { pkgs-unstable, ... }:
      {
        home.packages = [ pkgs-unstable.framework-tool ];
      };

    includes = with den.aspects; [
      den.aspects.linux-workstation
      gaming
      android
      cosmic
      niri
      vm
    ];
  };
}
