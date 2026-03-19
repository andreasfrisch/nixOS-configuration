{ ... }:

{
  virtualisation.containers.enable = true;
  virtualisation.containers.policy = {
    default = [{ type = "insecureAcceptAnything"; }];
  };
}
