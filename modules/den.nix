{ lib, ... }:
{
  den.hosts.x86_64-linux.matebook.users.tyassine = { };
  den.hosts.x86_64-linux.framework.users.tyassine = { };
  den.hosts.x86_64-linux.nexus.users.tyassine = { };

  # All users get home-manager.
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.homeManager = {
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs.
    systemd.user.startServices = "sd-switch";
  };
}
