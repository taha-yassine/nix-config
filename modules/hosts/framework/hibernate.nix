{
  den.aspects.framework.nixos =
    { pkgs, ... }:
    {
      # Hibernation: resume from swap partition.
      boot.resumeDevice = "/dev/disk/by-uuid/d3320098-e418-402d-9720-e7602efe2223";

      # Suspend-then-hibernate: suspend first, hibernate after 1 hour of inactivity.
      systemd.sleep.settings.Sleep.HibernateDelaySec = 3600;

      # This is how lid close should be configured, but GNOME's gsd-power takes an inhibitor
      # lock on handle-lid-switch and handles suspend itself, bypassing these logind settings.
      services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
      services.logind.settings.Login.HandleLidSwitchExternalPower = "suspend-then-hibernate";

      # Workaround: override systemd-suspend to run suspend-then-hibernate instead, so all
      # suspend triggers (lid close, idle, power button, shell menu) go through s-t-h.
      # https://gitlab.gnome.org/GNOME/gnome-settings-daemon/-/issues/583
      systemd.services."systemd-suspend" = {
        serviceConfig.ExecStart = [
          ""
          "${pkgs.systemd}/lib/systemd/systemd-sleep suspend-then-hibernate"
        ];
      };

      # Force smallest possible hibernate image. This tells the kernel to aggressively free
      # memory (drop caches, push to swap) before taking the snapshot, leaving more free RAM
      # for the write phase. Default is 2/5 of RAM which can cause ENOMEM on high-memory systems.
      systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];

      systemd.services = {
        # The kernel's own shrink_all_memory() may not free enough on high-RAM systems.
        # Dropping caches beforehand ensures enough free pages for the hibernate snapshot
        # (which must fit in half of RAM).
        pre-hibernate = {
          description = "Free RAM before hibernate";
          wantedBy = [ "hibernate.target" "suspend-then-hibernate.target" ];
          before = [ "systemd-hibernate.service" "systemd-suspend-then-hibernate.service" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            ${pkgs.coreutils}/bin/sync
            echo 3 > /proc/sys/vm/drop_caches
            ${pkgs.coreutils}/bin/sleep 2
          '';
        };

        # The mt7921e WiFi driver can hang or error (-110) during sleep/resume due to PCIe
        # power state transitions. Unloading before sleep and reloading on wake prevents this.
        wifi-sleep-fix = {
          description = "Unload Mediatek WiFi driver around sleep";
          wantedBy = [
            "suspend.target"
            "hibernate.target"
            "suspend-then-hibernate.target"
            "hybrid-sleep.target"
          ];
          before = [
            "systemd-suspend.service"
            "systemd-hibernate.service"
            "systemd-suspend-then-hibernate.service"
            "systemd-hybrid-sleep.service"
          ];
          partOf = [
            "suspend.target"
            "hibernate.target"
            "suspend-then-hibernate.target"
            "hybrid-sleep.target"
          ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            TimeoutSec = "15s";
            ExecStart = [
              "-${pkgs.kmod}/bin/modprobe -r mt7921e mt7921_common mt76_connac_lib mt76"
              "${pkgs.coreutils}/bin/sleep 1"
            ];
            ExecStop = [
              "${pkgs.kmod}/bin/modprobe mt7921e"
              "${pkgs.coreutils}/bin/sleep 2"
            ];
          };
        };
      };
    };
}
