{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/34b592a3-6ca4-4d80-a1e4-7413a72e9cea";
      fsType = "btrfs";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/34b592a3-6ca4-4d80-a1e4-7413a72e9cea";
      fsType = "btrfs";
      options = ["subvol=home"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/34b592a3-6ca4-4d80-a1e4-7413a72e9cea";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/34b592a3-6ca4-4d80-a1e4-7413a72e9cea";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/34b592a3-6ca4-4d80-a1e4-7413a72e9cea";
      fsType = "btrfs";
      options = ["subvol=log"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/736E-80DC";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
