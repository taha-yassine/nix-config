{ pkgs, pkgs-unstable, ... }:
let
  photoGimp = pkgs.fetchFromGitHub {
    owner = "Diolinux";
    repo = "PhotoGIMP";
    rev = "3.0";
    sha256 = "sha256-R9MMidsR2+QFX6tu+j5k2BejxZ+RGwzA0DR9GheO89M=";
  };
in {
  home.packages = with pkgs-unstable; [
    gimp3-with-plugins
  ];

  xdg.configFile."GIMP/3.0" = {
    source = photoGimp + "/.var/app/org.gimp.GIMP/config/GIMP/3.0"; # TODO: update with next release
    force = true;
    recursive = true;
  };

  xdg.dataFile."applications" = {
    source = photoGimp + "/.local/share/applications";
    recursive = true;
  };

  xdg.dataFile."icons" = {
    source = photoGimp + "/.local/share/icons";
    recursive = true;
  };
  
}
