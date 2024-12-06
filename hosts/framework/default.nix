{ pkgs, ... }:
{
  imports = [
    ../default
    ./hardware-configuration.nix
    ../default/vm.nix
  ];

  virtualisation.docker.enable = true;
  users.users.tyassine.extraGroups = ["docker"];
  networking.hostName = "framework";

  boot.kernelPackages = pkgs.linuxPackages_6_11;

  # Enable fingerprint reader
  services.fprintd.enable = true;
}