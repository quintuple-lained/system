{pkgs, ...}:
{
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    extraConfig = ''
                audio_output {
                             type "pipewire"
                             name "Pipewire"
                }
                '';
  };
  home.packages = with pkgs; [
    mpc
    ashuffle
    nicotine-plus
    mpv
  ];
}
