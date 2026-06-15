{ den, inputs, ... }:
let
  mkUnstable =
    system:
    import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        # jellyfin-media-player still pulls qtwebengine 5.15.
        permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
      };
    };
  mkStaging =
    system:
    import inputs.nixpkgs-staging {
      inherit system;
      config.allowUnfree = true;
    };
in
{
  den.default = {
    nixos =
      { pkgs, ... }:
      {
        system.stateVersion = "23.05";
        _module.args.pkgs-unstable = mkUnstable pkgs.system;
        _module.args.pkgs-staging = mkStaging pkgs.system;
      };

    homeManager =
      { pkgs, ... }:
      {
        home.stateVersion = "23.05";
        _module.args.pkgs-unstable = mkUnstable pkgs.system;
        _module.args.pkgs-staging = mkStaging pkgs.system;
      };
  };

  den.default.includes = [
    den.provides.hostname
    den.provides.define-user
  ];
}
