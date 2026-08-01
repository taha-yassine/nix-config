{ den, inputs, ... }:
{
  den.aspects.nexus = {
    nixos =
      {
        config,
        lib,
        primaryUserName,
        ...
      }:
      {
        imports = [
          inputs.disko.nixosModules.disko
          ./_disko.nix
          ./_hardware.nix
        ];

        # Keep the initial installation conservative and recoverable.
        networking.firewall.enable = true;
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = false;
        };
        users.users.${primaryUserName} = {
          initialHashedPassword = "$y$j9T$RTRqkEGZv53btgoaUx0m0.$m.p0LylmN.a6GBGhcSsNgbxVcQsl9lGa.MORoXXeL00";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeyPrxikq6F85+wCqBZq9o2W3MdqjpL8Kk/yV7q/bg+ tyassine@nixos"
          ];
        };
        services.fstrim.enable = true;
        services.smartd.enable = true;
        zramSwap.enable = true;

        # Both discrete GPUs are Ampere-generation NVIDIA cards.
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };
        hardware.nvidia = {
          modesetting.enable = true;
          open = true;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };

        # Do not expose an unauthenticated Open WebUI during bootstrap.
        services.open-webui.enable = lib.mkForce false;
      };

    includes = with den.aspects; [
      den.aspects.linux-workstation
      gaming
    ];
  };
}
