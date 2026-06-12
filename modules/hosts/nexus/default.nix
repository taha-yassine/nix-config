{ den, ... }:
{
  den.aspects.nexus = {
    nixos.imports = [ ./_hardware.nix ];

    includes = with den.aspects; [
      workstation
    ];
  };
}
