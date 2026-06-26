{ inputs, pkgs, ... }:
{

  imports = [
    ./generic.nix
  ];
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.xserver.xkb.layout = "us";

  networking.networkmanager.enable = true;

  services.fwupd.enable = true;
  services.flatpak.enable = true;

  programs.niri.enable = true;
  programs.xwayland.enable = true;

  environment.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  # Run unpatched binaries (downloaded executables, some dev tools)
  programs.nix-ld.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
  };

}
