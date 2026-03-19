{ ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/castitas.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets."user/hashedPassword" = {
      neededForUsers = true;
    };
  };
}
