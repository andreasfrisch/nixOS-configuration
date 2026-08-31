{ pkgs, ... }:

{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  environment.systemPackages = with pkgs; [
    cups
    cups-filters
    ghostscript
  ];
}
