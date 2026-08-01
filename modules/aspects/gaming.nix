{
  den.aspects.gaming = {
    nixos.programs.steam.enable = true;

    homeManager =
      { pkgs-unstable, ... }:
      {
        home.packages = with pkgs-unstable; [
          gamescope
          heroic
        ];
      };
  };
}
