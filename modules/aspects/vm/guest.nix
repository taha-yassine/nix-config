{
  den.aspects.vm.nixos =
    { pkgs, primaryUserName, ... }:
    {
      programs.virt-manager.enable = true;

      users.users.${primaryUserName}.extraGroups = [ "libvirtd" ];

      virtualisation.vmVariant = {
        users.mutableUsers = false;
        users.users.${primaryUserName}.hashedPassword = "";
      };

      environment.systemPackages = with pkgs; [
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
      ];

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            # qemu.ovmf removed in NixOS 25.11
          };
        };
        spiceUSBRedirection.enable = true;
      };

      services.spice-vdagentd.enable = true;
    };
}
