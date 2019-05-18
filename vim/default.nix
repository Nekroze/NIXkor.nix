{ pkgs, ...}:

{
  environment.systemPackages = import ./vimPackages.nix pkgs;
}
