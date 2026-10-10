{config, ... }:
{
  imports = [
    ./default.nix
  ];
  xdg.configFile."niri/host.kdl".text = ''
    input {
      keyboard {
        numlock
      }
    }

    output "ASUSTek COMPUTER INC VG248 LBLMQS022989" {
      mode "1920x1080@119.982"
      position x=0 y=0
      variable-refresh-rate
      focus-at-startup
    }

    output "Dell Inc. DELL P190S 1V88T1CD0DDL" {
      mode "1280x1024@60.020"
      position x=-1280 y=0 
    }

    output "Samsung Electric Company SMS24A650 HVRBC01846" {
      mode "1920x1080@60.000"
      position x=0 y=-1080
    }

  '';
}
