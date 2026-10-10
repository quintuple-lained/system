{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "none";
      IdentitiesOnly = true;
      IdentityFile = [
        "~/.ssh/id_ed25519_sk_e5_carry"
        "~/.ssh/id_ed25519_sk_b4_backup"
      ];
    };
  };
}
