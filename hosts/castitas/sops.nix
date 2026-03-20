{ ... }:

{
  sops = {
    # Personal age key — place at this path on every machine (readable by root).
    # Generate once: make secrets-init
    # Store private key in 1Password, public key goes in .sops.yaml.
    age.keyFile = "/etc/sops/age/keys.txt";

    defaultSopsFile = ../../secrets/castitas.yaml;

    secrets."user/hashedPassword" = {
      neededForUsers = true;
    };
  };
}

