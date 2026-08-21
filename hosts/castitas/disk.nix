{ ... }:

{
  # disko manages partitioning during `make install` via nixos-anywhere.
  # enableConfig = false means disko won't try to set fileSystems/swapDevices
  # on normal rebuilds — hardware-configuration.nix handles that instead.
  disko.enableConfig = false;

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "fmask=0077" "dmask=0077" ];
            };
          };
          swap = {
            size = "17G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "x-initrd.mount" ];
            };
          };
        };
      };
    };
  };
}
