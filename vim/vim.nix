{ pkgs, ...}:
let
  vimPackages = import ./vimPackages.nix pkgs;
in {
  environment.systemPackages = vimPackages;
}
