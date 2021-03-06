{ pkgs, lib, ...}:
with lib;
let
  vimPackages = import ./vimPackages.nix pkgs;
in {
  environment.systemPackages = vimPackages;
  environment.variables.EDITOR = mkForce "vim";
}
