{ pkgs ? import <nixpkgs> {} }:

let
  pname = "cursor";
  version = "0.38.1";
  src = pkgs.fetchurl {
    url = "https://downloader.cursor.sh/linux/appImage/x64";
    sha256 = "sha256-zIX5+J/d2HzW6pM5mQlTavqjFG119ySjdnyfgVSsI7I=";
  };
  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
in
pkgs.appimageTools.wrapType2  {
  inherit pname version src;

  extraInstallCommands = ''
    source "${pkgs.makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -m 444 -D ${appimageContents}/cursor.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cursor.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/* $out/share
  '';

  meta = with pkgs.lib; {
    description = "Cursor";
    homepage = "https://cursor.sh/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ taha-yassine ];
  };
}