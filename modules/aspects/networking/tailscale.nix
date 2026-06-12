{
  den.aspects.tailscale.nixos = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraSetFlags = [ "--operator=tyassine" ];
    };
  };
}
