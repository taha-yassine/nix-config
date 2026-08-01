{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        power-toggle = pkgs.callPackage ../../packages/power-toggle.nix { };
      };
    };
}
