{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/luks-22b840aa-09ff-47dc-bc0f-c2b0c679b032";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-22b840aa-09ff-47dc-bc0f-c2b0c679b032".device = "/dev/disk/by-uuid/22b840aa-09ff-47dc-bc0f-c2b0c679b032";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2E29-2CAB";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  #  swapDevices =
  #  [ { device = "/dev/mapper/luks-cb16d788-7bdc-4388-815a-4fe265fe696c"; }
  #  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
