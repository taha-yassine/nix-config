{
  imports = [
    ../default
    ./hardware-configuration.nix
    ../default/vm.nix
  ];

  virtualisation.docker.enable = true;
  users.users.tyassine.extraGroups = ["docker"];
}