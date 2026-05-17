{ pkgs, ... }:
{
  boot = {
    loader.timeout = 5;
    initrd.compressor = "zstd";
    consoleLogLevel = 0;
    kernelParams = [
      "systemd.show_status=auto"
    ];
  };

  # you might not like it but this is what peak formatting looks like
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "en_DK.UTF-8";
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  services.xserver.xkb.layout = "us";
  console.keyMap = "us";
  
  time.timeZone = "Europe/Berlin";

  services.resolved.enable = true;

  nix = {
    settings = {
      # what are these? they were added
      use-sandbox = true;
      show-trace = true;

      sandbox-paths = [ "/bin/sh=${pkgs.busybox-sandbox-shell.out}/bin/busybox" ];

      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;

      gc = {
        automatic = true;
        dates = "weekly";
        options = ''
          --delete-older-than 62d
        '';
      };
    };
    extraOptions = "experimental-fetures = nix-command flakes ";
  };
  programs.fish.enable = true;

  security.rtkit.enable = true;

  users.users.zoe = {
    shell = pkgs.fish;
    isNormalUser = true;
    autoSubUidGidRange = true;
    home = "/home/zoe";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    initialPassword = "password";
  };

}
