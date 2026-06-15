{ den, lib, ... }:
{
  den.hosts.x86_64-linux.matebook.users.tyassine = { };
  den.hosts.x86_64-linux.framework.users.tyassine = { };
  den.hosts.x86_64-linux.nexus.users.tyassine = { };

  den.homes.aarch64-darwin."tyassine@macbook".aspect.includes = [
    den.aspects.tyassine
    den.aspects.macos-dev-profile
  ];

  # All users get home-manager.
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.homeManager = {
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs.
    systemd.user.startServices = "sd-switch";
  };
}
