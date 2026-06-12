{ den, inputs, ... }:
let
  mkUnstable = system: import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
      # jellyfin-media-player still pulls qtwebengine 5.15.
      permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
    };
  };
  mkStaging = system: import inputs.nixpkgs-staging {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  den.default = {
    nixos.system.stateVersion = "23.05";
    homeManager.home.stateVersion = "23.05";

    nixos._module.args.pkgs-unstable = mkUnstable "x86_64-linux";
    nixos._module.args.pkgs-staging = mkStaging "x86_64-linux";
    homeManager._module.args.pkgs-unstable = mkUnstable "x86_64-linux";
    homeManager._module.args.pkgs-staging = mkStaging "x86_64-linux";
  };

  den.default.includes = [
    den.provides.hostname
    den.provides.define-user
  ];
}
