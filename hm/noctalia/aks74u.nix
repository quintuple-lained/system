{config, ... }:
{
  imports = [
    ./default.nix
  ];
  xdg.configFile."niri/host.kdl".text = ''
    input {
      touchpad {
        tap
        natural-scroll
      }
      tablet {
        map-to-focused-output
      }
      touch {
        map-to-output "eDP-1"
      }
    }
  '';
}
