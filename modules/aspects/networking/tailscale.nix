{
  den.aspects.tailscale.nixos =
    { primaryUserName, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client";
        extraSetFlags = [ "--operator=${primaryUserName}" ];
      };
    };
}
