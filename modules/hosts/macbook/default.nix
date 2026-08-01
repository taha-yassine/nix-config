{ den, ... }:
{
  den.aspects.macbook = {
    darwin =
      { pkgs, ... }:
      {
        system.stateVersion = 6;
        nixpkgs.hostPlatform = "aarch64-darwin";

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

    includes = [ den.aspects.developer ];
  };
}
