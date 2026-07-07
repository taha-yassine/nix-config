{ den, inputs, ... }:
{
  # Base system aspect: nix settings, networking, locale.
  # Included by every NixOS host via den.default.includes below.
  den.default.includes = [ den.aspects.base-system ];

  den.aspects.base-system.nixos =
    {
      lib,
      config,
      ...
    }:
    {
      nix = {
        # This will add each flake input as a registry.
        # To make nix3 commands consistent with your flake.
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

        # This will additionally add your inputs to the system's legacy channels.
        # Making legacy nix commands consistent as well.
        nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

        settings = {
          # Enable flakes and new 'nix' command.
          experimental-features = "nix-command flakes";
          # Deduplicate and optimize nix store.
          auto-optimise-store = true;

          substituters = [
            "https://nix-community.cachix.org"
            "https://cache.garnix.io"
            "https://cache.numtide.com"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          ];
        };

        gc = {
          automatic = true;
          persistent = true;
          dates = "05:00:00";
          options = "--delete-older-than 7d";
        };
      };

      services.automatic-timezoned.enable = true;

      # Workaround for Chromium/Electron apps showing wrong timezone when using
      # automatic-timezoned or timedatectl. Root cause is a nixpkgs systemd patch.
      # See: https://github.com/NixOS/nixpkgs/issues/499098#issuecomment-4173715348
      # TODO: remove once the upstream nixpkgs PR fixing this gets merged.
      systemd.services."systemd-timedated".environment.SYSTEMD_ETC_LOCALTIME = "/etc/localtime";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_FR.UTF-8";
        LC_IDENTIFICATION = "fr_FR.UTF-8";
        LC_MEASUREMENT = "fr_FR.UTF-8";
        LC_MONETARY = "fr_FR.UTF-8";
        LC_NAME = "fr_FR.UTF-8";
        LC_NUMERIC = "fr_FR.UTF-8";
        LC_PAPER = "fr_FR.UTF-8";
        LC_TELEPHONE = "fr_FR.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
      };

      console.keyMap = "us";

      networking.nftables.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };
}
