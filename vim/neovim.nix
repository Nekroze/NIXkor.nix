{ pkgs, lib, ...}:
with lib;
let
  neovimPackages = import ./neovimPackages.nix pkgs;
in {
  environment.systemPackages = neovimPackages;
  environment.variables.EDITOR = mkForce "nvim";
  environment.variables.PAGER = mkForce "nvim -c 'set ro' -R";
  environment.variables.MANPAGER = mkForce "nvim -c 'set ft=man ro nomod nolist nonu noma' -";
}
