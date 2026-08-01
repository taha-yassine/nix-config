{
  den,
  inputs,
  lib,
  ...
}:
let
  unfreePackages = [
    "beeper"
    "corefonts"
    "discord"
    "google-chrome"
    "graphite"
    "nvidia-settings"
    "nvidia-x11"
    "obsidian"
    "open-webui"
    "slack"
    "spotify"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "teams-for-linux"
    "vista-fonts"
    "zoom"
  ];
  mkUnstable =
    system:
    import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackages;
        # jellyfin-media-player still pulls qtwebengine 5.15.
        permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
      };
    };
  mkStaging =
    system:
    import inputs.nixpkgs-staging {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackages;
    };
in
{
  den.default = {
    nixos =
      { host, pkgs, ... }:
      let
        userNames = builtins.attrNames host.users;
      in
      assert builtins.length userNames == 1;
      {
        system.stateVersion = "23.05";
        _module.args.primaryUserName = builtins.head userNames;
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
    den.batteries.self'
    (den.batteries.unfree unfreePackages)
  ];
}
