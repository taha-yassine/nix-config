{
  den.aspects.containers.homeManager =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        devcontainer
      ];

      programs.lazydocker.enable = true;
    };
}
