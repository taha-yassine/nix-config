{ den, ... }:
{
  den.aspects.tyassine = {
    homeManager =
      { pkgs, ... }:
      {
        home.username = "tyassine";
        home.homeDirectory =
          if pkgs.stdenv.hostPlatform.isDarwin then "/Users/tyassine" else "/home/tyassine";
      };
  };
}
