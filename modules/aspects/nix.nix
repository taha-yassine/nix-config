{
  den.aspects.nix-tools.homeManager =
    { pkgs-unstable, ... }:
    {
      home.packages = with pkgs-unstable; [
        nixfmt
        nixd
        comma
      ];

      programs.nh.enable = true;
      programs.nix-search-tv.enable = true;
      programs.nix-index.enable = true;

      # TODO: move GitHub token to secrets.
      programs.nix-init = {
        enable = true;
      };
    };
}
