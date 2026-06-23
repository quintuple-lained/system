{ pkgs, inputs, ...}:
{
  imports = [
	inputs.disko.nixosModules.disko
	./disko.nix
	];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.11";
}
