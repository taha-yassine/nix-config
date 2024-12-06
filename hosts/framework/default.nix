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

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = true;
}