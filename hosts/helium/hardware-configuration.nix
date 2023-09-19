# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/74194a1e-7e23-41e9-9985-d4d94ca199a8";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd"];
  };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/fb0b6038-91e3-4573-b91b-0fb584585145";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/74194a1e-7e23-41e9-9985-d4d94ca199a8";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/74194a1e-7e23-41e9-9985-d4d94ca199a8";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C9CC-13C7";
    fsType = "vfat";
  };

  fileSystems."/data/nvme1" = {
    device = "/dev/disk/by-uuid/7311782f-8aca-4974-94ea-5d5cf0a742f3";
    fsType = "btrfs";
    options = ["rw" "nosuid" "nodev" "ssd" "space_cache=v2" "subvolid=5" "subvol=/" "relatime" "compress=zstd"];
  };

  # /dev/mapper/nvme1 on /data/nvme1 type btrfs (rw,nosuid,nodev,relatime,ssd,space_cache=v2,subvolid=5,subvol=/,x-gvfs-show)
  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
