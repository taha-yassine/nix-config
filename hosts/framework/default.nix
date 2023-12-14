{
  imports = [
    ../default
    ./hardware-configuration.nix
  ];

  virtualisation.docker.enable = true;
  users.users.tyassine.extraGroups = ["docker"];
}