{ pkgs, ...}:
{
  boot = {
    loader.timeout = 5;
    initrd.compressor = "zstf";
    consoleLogLevel = 0;
    kernelParams = [
      "systemd.show_status=auto"
    ];
  };

  i18n.defaultLocale = "en_GB.UTF-8";
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
  programs.nix-index-database.comma.enable = true;
  
  security.rtkit.enable = true;


}
