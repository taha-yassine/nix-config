{
  disko.devices = {
    disk = {
      system = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S3PLNF0JA09394L";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            system = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "nexus";
              };
            };
          };
        };
      };

      expansion = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_1TB_S2RFNX0J123493H";
        content = {
          type = "gpt";
          partitions.system = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "nexus";
            };
          };
        };
      };
    };

    lvm_vg.nexus = {
      type = "lvm_vg";
      lvs.root = {
        size = "100%FREE";
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
          mountOptions = [ "noatime" ];
        };
      };
    };
  };
}
