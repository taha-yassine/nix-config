{ den, ... }:
{
  den.aspects.matebook = {
    nixos.imports = [ ./_hardware.nix ];

    # Per-user home-manager overrides on the matebook host: enable
    # fractional scaling via the mutter framebuffer feature.
    homeManager.dconf.settings."org/gnome/mutter".experimental-features = [
      "scale-monitor-framebuffer"
    ];

    includes = with den.aspects; [
      workstation
      vm
    ];
  };
}
