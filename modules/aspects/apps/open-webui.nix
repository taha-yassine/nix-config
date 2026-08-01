{
  den.aspects.open-webui.nixos =
    { pkgs-unstable, ... }:
    {
      services.open-webui = {
        enable = true;
        package = pkgs-unstable.open-webui;
        port = 7777;
        environment.WEBUI_AUTH = "False";
      };
    };
}
