{ inputs, pkgs, ... }:
{

  imports = [
    ./generic.nix
  ];
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.xserver.xkb.layout = "us";

  networking = {
    networkmanager.enable = true;
  };
  services.displayManager.ly.enable = true;
  
  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.fwupd.enable = true;
  services.flatpak.enable = true;

  programs.niri.enable = true;
  programs.xwayland.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;

  programs.nix-ld.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/zoe/system";
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "pink";
  };

}
