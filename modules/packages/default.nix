{
  den.aspects.custom-packages.nixos = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (final: _prev: {
        power-toggle = final.callPackage ./_power-toggle.nix { };
      })
    ];
  };

  den.aspects.custom-packages.homeManager = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (final: _prev: {
        power-toggle = final.callPackage ./_power-toggle.nix { };
      })
    ];
  };
}
